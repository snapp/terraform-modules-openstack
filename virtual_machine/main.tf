

terraform {
  required_version = ">=1.5.0"

  # https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~>3.0.0"
    }

    # https://registry.terraform.io/providers/ansible/ansible/latest/docs
    ansible = {
      version = "~> 1.3.0"
      source  = "ansible/ansible"
    }

    # https://registry.terraform.io/providers/hashicorp/random/latest/docs
    random = {
      source  = "hashicorp/random"
      version = "~> 3.7.1"
    }
  }
}

data "openstack_compute_flavor_v2" "flavor" {
  name = var.virtual_machine.flavor
}

data "openstack_images_image_v2" "image" {
  name        = var.virtual_machine.image
  most_recent = true
}

data "openstack_networking_network_v2" "network" {
  name = var.virtual_machine.network
}

resource "openstack_compute_instance_v2" "virtual_machine" {
  name            = local.instance_name
  image_id        = data.openstack_images_image_v2.image.id
  flavor_id       = data.openstack_compute_flavor_v2.flavor.id
  key_pair        = var.virtual_machine.ssh_keypair
  security_groups = var.virtual_machine.security_groups

  network {
    name = data.openstack_networking_network_v2.network.name
  }
  metadata = {
    X-Contact : var.virtual_machine.contact
    X-Description : local.description
  }

  tags = [
    "X-Contact: ${var.virtual_machine.contact}"
  ]

  # TODO|2024-05-08| Add gid to user_data so uid/gid are consistent
  user_data = length(regexall("(?i)^win", var.virtual_machine.image)) > 0 ? null : <<-EOF
  #cloud-config
  hostname: ${local.hostname}
  fqdn: ${local.fqdn}
  prefer_fqdn_over_hostname: true
  ${var.virtual_machine.user != null || try(coalesce(var.virtual_machine.root_password, ""), "") != "" ? "users:" : ""}
  ${var.virtual_machine.user != null ? <<-EOT
      - name: "${var.virtual_machine.user.username}"
        gecos: "${var.virtual_machine.user.display_name}"
        ${try(coalesce(var.virtual_machine.user.password, ""), "") != "" ? "hashed_passwd: \"${var.virtual_machine.user.password}\"" : ""}
        lock-passwd: false
        ${try(coalesce(var.virtual_machine.user.sudo_rule, ""), "") != "" ? "sudo: \"${var.virtual_machine.user.sudo_rule}\"" : "sudo: false"}
        ${try(coalesce(var.virtual_machine.user.uid, ""), "") != "" ? "uid: \"${var.virtual_machine.user.uid}\"" : ""}
        ${try(coalesce(var.virtual_machine.user.uid, ""), "") != "" ? "gid: \"${var.virtual_machine.user.uid}\"" : ""}
        ${try(coalesce(var.virtual_machine.user.homedir, ""), "") != "" ? "homedir: \"${var.virtual_machine.user.homedir}\"" : ""}
        ssh_authorized_keys:
          - ${var.virtual_machine.user.ssh_public_key}
    EOT
  : ""}
  ${try(coalesce(var.virtual_machine.root_password, ""), "") != "" ? <<-EOT
      - name: root
        hashed_passwd: ${var.virtual_machine.root_password}
        lock-passwd: false
    EOT
: ""}
  EOF
}

data "openstack_networking_port_v2" "port" {
  network_id = data.openstack_networking_network_v2.network.id
  device_id  = openstack_compute_instance_v2.virtual_machine.id
  fixed_ip   = openstack_compute_instance_v2.virtual_machine.network[0].fixed_ip_v4
}

resource "openstack_networking_floatingip_v2" "floating_ip" {
  count       = var.virtual_machine.attach_floating_ip ? 1 : 0
  description = local.fqdn
  dns_name    = lower(local.hostname)
  dns_domain  = "${lower(local.domain)}."
  pool        = var.virtual_machine.floating_ip_pool
  fixed_ip    = openstack_compute_instance_v2.virtual_machine.network[count.index].fixed_ip_v4
  port_id     = data.openstack_networking_port_v2.port.id
  tags = [
    "X-Contact: ${var.virtual_machine.contact}"
  ]
}

resource "openstack_networking_floatingip_associate_v2" "floating_ip" {
  count       = var.virtual_machine.attach_floating_ip ? 1 : 0
  floating_ip = openstack_networking_floatingip_v2.floating_ip[count.index].address
  port_id     = data.openstack_networking_port_v2.port.id
}

# create an ansible inventory host entry
resource "ansible_host" "virtual_machine" {
  count  = var.virtual_machine.enable_ansible_inventory ? 1 : 0
  name   = local.fqdn
  groups = length(coalesce(var.virtual_machine.groups, [])) > 0 ? var.virtual_machine.groups : ["terraform_managed"]
  variables = {
    instance_name = local.instance_name
    hostname      = local.hostname
    domain        = local.domain
    description   = local.description
  }
}
