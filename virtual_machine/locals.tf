resource "random_id" "virtual_machine" {
  keepers = {
    name = try(coalesce(var.virtual_machine.name, ""), "")
  }

  byte_length = 3
}

locals {
  instance_name = try(coalesce(var.virtual_machine.name, ""), "") != "" ? var.virtual_machine.name : "${var.virtual_machine.contact}-${lower(random_id.virtual_machine.hex)}"

  hostname = coalesce(var.virtual_machine.hostname, local.instance_name)

  domain = try(coalesce(var.virtual_machine.domain, ""), "") != "" ? var.virtual_machine.domain : "compute.internal"

  fqdn = "${lower(local.hostname)}.${lower(local.domain)}"

  description = try(coalesce(var.virtual_machine.description, ""), "") != "" ? var.virtual_machine.description : <<-EOT
    name: ${local.instance_name}
    fqdn: ${local.fqdn}
    contact: ${var.virtual_machine.contact}
  EOT
}
