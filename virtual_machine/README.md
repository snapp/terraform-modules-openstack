# Terraform Openstack virtual_machine Module

This terraform module provides a convenience for instantiating a virtual machine in an Openstack project.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.5.0 |
| <a name="requirement_ansible"></a> [ansible](#requirement\_ansible) | ~> 1.4.0 |
| <a name="requirement_openstack"></a> [openstack](#requirement\_openstack) | ~>3.4.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.8.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_ansible"></a> [ansible](#provider\_ansible) | 1.4.0 |
| <a name="provider_openstack"></a> [openstack](#provider\_openstack) | 3.4.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.8.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [ansible_host.virtual_machine](https://registry.terraform.io/providers/ansible/ansible/latest/docs/resources/host) | resource |
| [openstack_blockstorage_volume_v3.volume](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/blockstorage_volume_v3) | resource |
| [openstack_compute_instance_v2.virtual_machine](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/compute_instance_v2) | resource |
| [openstack_networking_floatingip_associate_v2.floating_ip](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/networking_floatingip_associate_v2) | resource |
| [openstack_networking_floatingip_v2.floating_ip](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/networking_floatingip_v2) | resource |
| [random_id.virtual_machine](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [openstack_compute_flavor_v2.flavor](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/data-sources/compute_flavor_v2) | data source |
| [openstack_images_image_v2.image](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/data-sources/images_image_v2) | data source |
| [openstack_images_image_v2.volume_image](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/data-sources/images_image_v2) | data source |
| [openstack_networking_network_v2.network](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/data-sources/networking_network_v2) | data source |
| [openstack_networking_port_v2.port](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/data-sources/networking_port_v2) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_virtual_machine"></a> [virtual\_machine](#input\_virtual\_machine) | virtual\_machine = {<br/>  name : "The optional name of the virtual machine instance. Defaults to a generated name based on contact."<br/>  contact : "The primary contact for the resources, this should be the username and must be able to receive email by appending your domain to it (e.g. \$\{contact}@example.com)."<br/>  description : "The optional description of the virtual machine instance."<br/>  hostname : "The optional short (unqualified) hostname of the instance. Defaults to the instance name."<br/>  domain : "The optional network domain used for constructing a fqdn for the virtual machine (default: internal)."<br/>  flavor : "The name of the flavor that determines the amount of cpu, memory, and disk allocated to the virtual machine (e.g. m1.medium)."<br/>  image : "The image used to instantiate the virtual machine."<br/>  network : "The network the virtual machine resides on."<br/>  floating\_ip\_pool : "The name of the floating IP pool from which to allocate a floating IP address. Required when attach\_floating\_ip is true."<br/>  floating\_ip\_domain : "The DNS domain associated with the floating IP address. Required when attach\_floating\_ip is true."<br/>  attach\_floating\_ip : "Whether to attach a floating IP address to the virtual machine (default: false)."<br/>  security\_groups : "A list of security group names to apply to the virtual machine."<br/>  ssh\_keypair : "The name of an SSH keypair already loaded in the OpenStack project to associate with the default cloud-init user."<br/>  root\_password : "The optional hashed password for the root user."<br/>  user = {<br/>    username : "User used to access the instance."<br/>    display\_name : "Full name of the user used to access the instance."<br/>    password : "The optional hashed password for the user."<br/>    homedir : "The optional home directory for the user (defaults to /home/<username>)."<br/>    ssh\_public\_key : "SSH public key used to access the instance."<br/>    sudo\_rule : "The optional sudo rule applied to the user (e.g. 'ALL=(ALL) NOPASSWD:ALL')."<br/>    uid : "The optional user ID of the user."<br/>  }<br/>  volumes = [<br/>    volume = {<br/>      name                  = "The name of the volume when listed on the hypervisor."<br/>      description           = "The optional description of the volume."<br/>      size                  = "The size of the volume in GiB (e.g. 250)."<br/>      image                 = "The image used to initialize the volume."<br/>      volume\_type           = "Type of volume to create (e.g. 'SSD')."<br/>      delete\_on\_termination = "Whether to delete the volume when the virtual machine is deleted."<br/>    }<br/>  ]<br/>  runcmd : "An optional list of shell commands to run on first boot via cloud-init runcmd (e.g. [\"ipa-client-install --unattended ...\"])."<br/>  groups : "An optional list of Ansible inventory group names for the virtual machine (default: [])."<br/>  enable\_ansible\_inventory : "Whether to create an Ansible inventory host entry for the virtual machine (default: true)."<br/>  ansible\_host\_override : "When true, injects ansible\_host into the inventory host vars — uses the floating IP when attached, otherwise the fixed IP (default: false)."<br/>  extra\_vars : "An optional map of additional Ansible inventory host variables to merge into the host entry."<br/>} | <pre>object({<br/>    # Identity<br/>    name        = optional(string)<br/>    contact     = string<br/>    description = optional(string)<br/>    hostname    = optional(string)<br/>    domain      = optional(string)<br/><br/>    # Compute<br/>    flavor = string<br/>    image  = optional(string)<br/><br/>    # Network<br/>    network            = string<br/>    floating_ip_pool   = optional(string)<br/>    floating_ip_domain = optional(string)<br/>    attach_floating_ip = optional(bool, false)<br/>    security_groups    = list(string)<br/>    ssh_keypair        = optional(string)<br/><br/>    # User management<br/>    root_password = optional(string)<br/>    user = optional(object({<br/>      username       = string<br/>      display_name   = string<br/>      password       = optional(string)<br/>      homedir        = optional(string)<br/>      ssh_public_key = string<br/>      sudo_rule      = optional(string)<br/>      uid            = optional(number)<br/>    }))<br/><br/>    # Storage<br/>    volumes = optional(list(object({<br/>      name                  = string<br/>      description           = string<br/>      size                  = number<br/>      image                 = string<br/>      volume_type           = string<br/>      delete_on_termination = bool<br/>    })))<br/><br/>    # First-boot commands<br/>    runcmd = optional(list(string), [])<br/><br/>    # Ansible inventory<br/>    groups                   = optional(list(string), [])<br/>    enable_ansible_inventory = optional(bool, true)<br/>    ansible_host_override    = optional(bool, false)<br/>    extra_vars               = optional(map(string), {})<br/>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ansible_host"></a> [ansible\_host](#output\_ansible\_host) | The Ansible inventory host resource, or null if enable\_ansible\_inventory is false. |
| <a name="output_id"></a> [id](#output\_id) | The unique id of the virtual machine. |
| <a name="output_name"></a> [name](#output\_name) | The name of the virtual machine instance when listed on the hypervisor. |
| <a name="output_virtual_machine"></a> [virtual\_machine](#output\_virtual\_machine) | The Openstack Compute Instance representation of the virtual machine. |
<!-- END_TF_DOCS -->

## Examples
- [multiple_virtual_machines](examples/example-multiple_virtual_machines/README.md)

## Licensing

GNU General Public License v3.0 or later

See [LICENSE](https://www.gnu.org/licenses/gpl-3.0.txt) to see the full text.
