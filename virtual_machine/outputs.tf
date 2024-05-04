output "id" {
  description = "The unique id of the virtual machine."
  value       = openstack_compute_instance_v2.virtual_machine.id
}

output "name" {
  description = "The name of the virtual machine instance when listed on the hypervisor."
  value       = local.instance_name
}

output "virtual_machine" {
  description = "The Openstack Compute Instance representation of the virtual machine."
  value       = openstack_compute_instance_v2.virtual_machine
}
