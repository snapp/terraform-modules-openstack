# https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs

terraform {
  required_version = ">=1.0.0"

  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "1.54.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.6.0"
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

data "openstack_networking_subnet_v2" "network_subnet" {
  network_id = data.openstack_networking_network_v2.network.id
}

data "openstack_networking_secgroup_v2" "security_groups" {
  for_each = toset(var.virtual_machine.security_groups)
  name     = each.value
}

resource "openstack_networking_port_v2" "network_port" {
  name       = local.fqdn
  network_id = data.openstack_networking_network_v2.network.id
  security_group_ids = [
    for security_group_name in var.virtual_machine.security_groups :
    data.openstack_networking_secgroup_v2.security_groups[security_group_name].id
  ]

  fixed_ip {
    subnet_id = data.openstack_networking_subnet_v2.network_subnet.id
  }
}

resource "openstack_networking_floatingip_v2" "floating_ip" {
  count = (var.virtual_machine.attach_floating_ip && try(coalesce(var.virtual_machine.floating_ip, ""), "") == "") ? 1 : 0
  pool  = var.virtual_machine.floating_ip_pool
}

resource "openstack_networking_floatingip_associate_v2" "floating_ip" {
  count       = var.virtual_machine.attach_floating_ip ? 1 : 0
  floating_ip = (try(coalesce(var.virtual_machine.floating_ip, ""), "") == "") ? openstack_networking_floatingip_v2.floating_ip[count.index].address : var.virtual_machine.floating_ip
  port_id     = openstack_networking_port_v2.network_port.id
}

resource "openstack_compute_instance_v2" "virtual_machine" {
  name            = local.instance_name
  image_id        = data.openstack_images_image_v2.image.id
  flavor_id       = data.openstack_compute_flavor_v2.flavor.id
  key_pair        = var.virtual_machine.ssh_keypair
  security_groups = var.virtual_machine.security_groups
  network {
    port = openstack_networking_port_v2.network_port.id
  }

  metadata = {
    X-Contact : var.virtual_machine.contact
    X-Description : local.description
  }

  tags = [
    "X-Contact: ${var.virtual_machine.contact}"
  ]

  # inject user data if virtual machine image does not look like a windows image
  user_data = length(regexall("(?i)^win", var.virtual_machine.image)) > 0 ? null : <<-EOF
  #cloud-config
  hostname: ${local.hostname}
  fqdn: ${local.fqdn}
  prefer_fqdn_over_hostname: true
  ${var.virtual_machine.user != null || try(coalesce(var.virtual_machine.root_password, ""), "") != "" ? "users:" : ""}
  ${var.virtual_machine.user != null ? <<-EOT
      - name: "${var.virtual_machine.user.username}"
        gecos: "${var.virtual_machine.user.display_name}"
        hashed_passwd: ${var.virtual_machine.user.password}
        lock-passwd: false
        sudo: "${var.virtual_machine.user.sudo_rule}"
        ${try(coalesce(var.virtual_machine.user.uid, ""), "") != "" ? "uid: \"${var.virtual_machine.user.uid}\"" : ""}
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
