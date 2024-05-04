variable "virtual_machine" {
  nullable = false
  type = object({
    name               = string
    contact            = string
    description        = string
    flavor             = string
    image              = string
    domain             = string
    hostname           = string
    network            = string
    floating_ip_pool   = string
    attach_floating_ip = bool
    security_groups    = list(string)
    ssh_keypair        = string
    root_password      = string
    user = object({
      username       = string
      display_name   = string
      password       = string
      ssh_public_key = string
      sudo_rule      = string
      uid            = number
    })
  })
  description = <<-EOT
    virtual_machine = {
      name : "The name of the virtual machine instance when listed on the hypervisor."
      contact : "The primary contact for the resources, this should be the username and must be able to receive email by appending your domain to it (e.g. \$\{contact}@example.com) (this person can explain what/why)."
      description: "The optional description of the virtual machine instance."
      flavor : "The name of the flavor that determines the amount of cpu, memory, and disk allocated to the virtual machine (e.g. m1.medium)."
      image : "The image used to instantiate the virtual machine."
      domain : "The optional network domain used for constructing a fqdn for the virtual machine."
      hostname : "The optional short (unqualified) hostname of the instance to be created."
      network : "The network the virtual machine resides on."
      floating_ip_pool : "The name of the floating IP pool from which to allocate a floating IP address."
      attach_floating_ip : "Whether to attach a floating IP address to the virtual machine."
      security_groups : "An array of security group names that should be applied to the virtual machine."
      ssh_keypair : "The name of a SSH keypair already loaded in the Openstack project for the authenticating user which will be associated with the default cloud-init user."
      root_password : "Password for the root user of the instance (plain-text or hashed)."
      user = {
        username : "User used to access the instance."
        display_name : "Full name of the user used to access the instance."
        password : "Password for user used to access the instance (plain-text or hashed)."
        ssh_public_key : "SSH public key used to access the instance."
        sudo_rule : "Sudo rule applied to the user used to access the instance (e.g. 'ALL=(ALL) ALL')."
        uid : "The optional user ID of the user used to access the instance."
      }
    }
  EOT
}
