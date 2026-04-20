variable "virtual_machine" {
  nullable = false
  type = object({
    # Required
    contact         = string
    flavor          = string
    network         = string
    security_groups = list(string)

    # Compute
    image = optional(string)

    # Network
    floating_ip_pool   = optional(string)
    floating_ip_domain = optional(string)
    attach_floating_ip = optional(bool, false)
    ssh_keypair        = optional(string)

    # User management
    root_password = optional(string)
    user = optional(object({
      username       = string
      display_name   = string
      password       = optional(string)
      homedir        = optional(string)
      ssh_public_key = string
      sudo_rule      = optional(string)
      uid            = optional(number)
    }))

    # First-boot commands
    runcmd = optional(list(string), [])
  })
  description = <<-EOT
    virtual_machine = {
      contact : "The primary contact for the resources."
      flavor : "The name of the flavor (e.g. m1.medium)."
      network : "The network the virtual machine resides on."
      security_groups : "A list of security group names to apply to the virtual machine."
      image : "The image used to instantiate the virtual machine."
      floating_ip_pool : "The floating IP pool name. Required when attach_floating_ip is true."
      floating_ip_domain : "The DNS domain for the floating IP. Required when attach_floating_ip is true."
      attach_floating_ip : "Whether to attach a floating IP address (default: false)."
      ssh_keypair : "The name of an SSH keypair loaded in the OpenStack project."
      root_password : "The optional hashed password for the root user."
      user = {
        username : "User used to access the instance."
        display_name : "Full name of the user."
        password : "The optional hashed password for the user."
        homedir : "The optional home directory for the user."
        ssh_public_key : "SSH public key used to access the instance."
        sudo_rule : "The optional sudo rule applied to the user (e.g. 'ALL=(ALL) NOPASSWD:ALL')."
        uid : "The optional user ID of the user."
      }
      runcmd : "An optional list of shell commands to run on first boot."
    }
  EOT
}
