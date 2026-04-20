variable "virtual_machine" {
  nullable = false
  type = object({
    # Identity
    name        = optional(string)
    contact     = string
    description = optional(string)
    hostname    = optional(string)
    domain      = optional(string)

    # Compute
    flavor = string
    image  = optional(string)

    # Network
    network            = string
    floating_ip_pool   = optional(string)
    floating_ip_domain = optional(string)
    attach_floating_ip = optional(bool, false)
    security_groups    = list(string)
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

    # Storage
    volumes = optional(list(object({
      name                  = string
      description           = string
      size                  = number
      image                 = string
      volume_type           = string
      delete_on_termination = bool
    })))

    # First-boot commands
    runcmd = optional(list(string), [])

    # Ansible inventory
    groups                   = optional(list(string), [])
    enable_ansible_inventory = optional(bool, true)
    ansible_host_override    = optional(bool, false)
    extra_vars               = optional(map(string), {})
  })
  validation {
    condition     = !var.virtual_machine.attach_floating_ip || (var.virtual_machine.floating_ip_pool != null && var.virtual_machine.floating_ip_domain != null)
    error_message = "floating_ip_pool and floating_ip_domain are required when attach_floating_ip is true."
  }
  description = <<-EOT
    virtual_machine = {
      name : "The optional name of the virtual machine instance. Defaults to a generated name based on contact."
      contact : "The primary contact for the resources, this should be the username and must be able to receive email by appending your domain to it (e.g. \$\{contact}@example.com)."
      description : "The optional description of the virtual machine instance."
      hostname : "The optional short (unqualified) hostname of the instance. Defaults to the instance name."
      domain : "The optional network domain used for constructing a fqdn for the virtual machine (default: internal)."
      flavor : "The name of the flavor that determines the amount of cpu, memory, and disk allocated to the virtual machine (e.g. m1.medium)."
      image : "The image used to instantiate the virtual machine."
      network : "The network the virtual machine resides on."
      floating_ip_pool : "The name of the floating IP pool from which to allocate a floating IP address. Required when attach_floating_ip is true."
      floating_ip_domain : "The DNS domain associated with the floating IP address. Required when attach_floating_ip is true."
      attach_floating_ip : "Whether to attach a floating IP address to the virtual machine (default: false)."
      security_groups : "A list of security group names to apply to the virtual machine."
      ssh_keypair : "The name of an SSH keypair already loaded in the OpenStack project to associate with the default cloud-init user."
      root_password : "The optional hashed password for the root user."
      user = {
        username : "User used to access the instance."
        display_name : "Full name of the user used to access the instance."
        password : "The optional hashed password for the user."
        homedir : "The optional home directory for the user (defaults to /home/<username>)."
        ssh_public_key : "SSH public key used to access the instance."
        sudo_rule : "The optional sudo rule applied to the user (e.g. 'ALL=(ALL) NOPASSWD:ALL')."
        uid : "The optional user ID of the user."
      }
      volumes = [
        volume = {
          name                  = "The name of the volume when listed on the hypervisor."
          description           = "The optional description of the volume."
          size                  = "The size of the volume in GiB (e.g. 250)."
          image                 = "The image used to initialize the volume."
          volume_type           = "Type of volume to create (e.g. 'SSD')."
          delete_on_termination = "Whether to delete the volume when the virtual machine is deleted."
        }
      ]
      runcmd : "An optional list of shell commands to run on first boot via cloud-init runcmd (e.g. [\"ipa-client-install --unattended ...\"])."
      groups : "An optional list of Ansible inventory group names for the virtual machine (default: [])."
      enable_ansible_inventory : "Whether to create an Ansible inventory host entry for the virtual machine (default: true)."
      ansible_host_override : "When true, injects ansible_host into the inventory host vars — uses the floating IP when attached, otherwise the fixed IP (default: false)."
      extra_vars : "An optional map of additional Ansible inventory host variables to merge into the host entry."
    }
  EOT
}
