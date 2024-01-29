output "id" {
  description = "The unique id of the virtual machine."
  value       = openstack_compute_instance_v2.virtual_machine.id
}

output "name" {
  description = "The name of the virtual machine instance when listed on the hypervisor."
  value       = local.instance_name
}

output "ipv4_address" {
  description = "The ipv4 address of the virtual machine."
  value       = openstack_compute_instance_v2.virtual_machine.network[0].fixed_ip_v4
}

output "floating_ip" {
  description = "The floating ip of the virtual machine (or null if one is not attached)."
  value       = var.virtual_machine.attach_floating_ip ? openstack_networking_floatingip_associate_v2.floating_ip[0].floating_ip : null
}
