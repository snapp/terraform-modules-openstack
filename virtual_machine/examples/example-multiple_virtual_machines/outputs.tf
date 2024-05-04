output "virtual_machines" {
  description = <<-EOT
        id : "The unique id of the virtual machine."
        name : The name of the virtual machine instance when listed by openstack."
        ipv4_address : "The ipv4 address of the virtual machine."
    EOT
  value = [
    {
      id              = module.test1.id
      name            = module.test1.name
      virtual_machine = module.test1.virtual_machine.network[0].fixed_ip_v4
    },
    {
      id           = module.test2.id
      name         = module.test2.name
      ipv4_address = module.test2.virtual_machine.network[0].fixed_ip_v4
    },
    {
      id           = module.test3.id
      name         = module.test3.name
      ipv4_address = module.test3.virtual_machine.network[0].fixed_ip_v4
    },
    {
      id           = module.test4.id
      name         = module.test4.name
      ipv4_address = module.test4.virtual_machine.network[0].fixed_ip_v4
    }
  ]
}
