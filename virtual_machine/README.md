# Terraform Openstack virtual_machine Module

This terraform module provides a convenience for instantiating a virtual machine in an Openstack project.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.5.0 |
| <a name="requirement_ansible"></a> [ansible](#requirement\_ansible) | ~> 1.2.0 |
| <a name="requirement_openstack"></a> [openstack](#requirement\_openstack) | ~>1.54.1 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.6.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_ansible"></a> [ansible](#provider\_ansible) | 1.2.0 |
| <a name="provider_openstack"></a> [openstack](#provider\_openstack) | 1.54.1 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [ansible_host.virtual_machine](https://registry.terraform.io/providers/ansible/ansible/latest/docs/resources/host) | resource |
| [openstack_compute_instance_v2.virtual_machine](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/compute_instance_v2) | resource |
| [openstack_dns_recordset_v2.recordset](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/dns_recordset_v2) | resource |
| [openstack_networking_floatingip_associate_v2.floating_ip](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/networking_floatingip_associate_v2) | resource |
| [openstack_networking_floatingip_v2.floating_ip](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/networking_floatingip_v2) | resource |
| [random_id.virtual_machine](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [openstack_compute_flavor_v2.flavor](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/data-sources/compute_flavor_v2) | data source |
| [openstack_dns_zone_v2.zone](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/data-sources/dns_zone_v2) | data source |
| [openstack_images_image_v2.image](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/data-sources/images_image_v2) | data source |
| [openstack_networking_network_v2.network](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/data-sources/networking_network_v2) | data source |
| [openstack_networking_port_v2.port](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/data-sources/networking_port_v2) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_virtual_machine"></a> [virtual\_machine](#input\_virtual\_machine) | virtual\_machine = {<br>  name : "The name of the virtual machine instance when listed on the hypervisor."<br>  contact : "The primary contact for the resources, this should be the username and must be able to receive email by appending your domain to it (e.g. \$\{contact}@example.com) (this person can explain what/why)."<br>  description: "The optional description of the virtual machine instance."<br>  flavor : "The name of the flavor that determines the amount of cpu, memory, and disk allocated to the virtual machine (e.g. m1.medium)."<br>  image : "The image used to instantiate the virtual machine."<br>  domain : "The optional network domain used for constructing a fqdn for the virtual machine."<br>  groups : "An array of Ansible inventory group names that the virtual machine should be associated with."<br>  hostname : "The optional short (unqualified) hostname of the instance to be created."<br>  network : "The network the virtual machine resides on."<br>  floating\_ip\_pool : "The name of the floating IP pool from which to allocate a floating IP address."<br>  attach\_floating\_ip : "Whether to attach a floating IP address to the virtual machine."<br>  security\_groups : "An array of security group names that should be applied to the virtual machine."<br>  ssh\_keypair : "The name of a SSH keypair already loaded in the Openstack project for the authenticating user which will be associated with the default cloud-init user."<br>  root\_password : "Password for the root user of the instance (plain-text or hashed)."<br>  user = {<br>    username : "User used to access the instance."<br>    display\_name : "Full name of the user used to access the instance."<br>    password : "The optional password for user used to access the instance (plain-text or hashed)."<br>    homedir : "The optional home directory for user used to access the instance (defaults to /home)."<br>    ssh\_public\_key : "SSH public key used to access the instance."<br>    sudo\_rule : "Sudo rule applied to the user used to access the instance (e.g. 'ALL=(ALL) ALL')."<br>    uid : "The optional user ID of the user used to access the instance."<br>  }<br>  enable\_ansible\_inventory : "Whether to create an Ansible inventory host entry for the virtual machine."<br>} | <pre>object({<br>    name               = string<br>    contact            = string<br>    description        = string<br>    flavor             = string<br>    image              = string<br>    domain             = string<br>    groups             = list(string)<br>    hostname           = string<br>    network            = string<br>    floating_ip_pool   = string<br>    attach_floating_ip = bool<br>    security_groups    = list(string)<br>    ssh_keypair        = string<br>    root_password      = string<br>    user = object({<br>      username       = string<br>      display_name   = string<br>      password       = string<br>      homedir        = string<br>      ssh_public_key = string<br>      sudo_rule      = string<br>      uid            = number<br>    })<br>    enable_ansible_inventory = bool<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The unique id of the virtual machine. |
| <a name="output_name"></a> [name](#output\_name) | The name of the virtual machine instance when listed on the hypervisor. |
| <a name="output_virtual_machine"></a> [virtual\_machine](#output\_virtual\_machine) | The Openstack Compute Instance representation of the virtual machine. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Examples
- [multiple_virtual_machines](examples/example-multiple_virtual_machines/README.md)

## Licensing

GNU General Public License v3.0 or later

See [LICENSE](https://www.gnu.org/licenses/gpl-3.0.txt) to see the full text.
