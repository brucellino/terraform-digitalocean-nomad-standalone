variable "vpc_name" {
  type        = string
  default     = "vpc"
  description = "Name of the VPC we will terraform Nomad into."
}

variable "project_name" {
  type        = string
  default     = "nomad"
  description = "Name of the Nomad project"
}

variable "datacenter" {
  type        = string
  description = "Name of the Nomad datacenter"
  default     = "dc1"
}
variable "nomad_version" {
  type        = string
  default     = "1.4.3"
  description = "Nomad version"

  validation {
    condition     = can(regex("^(?P<major>0|[1-9]\\d*)\\.(?P<minor>0|[1-9]\\d*)\\.(?P<patch>0|[1-9]\\d*)(?:-(?P<prerelease>(?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\\.(?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\\+(?P<buildmetadata>[0-9a-zA-Z-]+(?:\\.[0-9a-zA-Z-]+)*))?$", var.nomad_version))
    error_message = "Only support Nomad versions up to 1.3.2. Please check Nomad releases https://releases.hashicorp.com/nomad"
  }
}

variable "ssh_public_key_url" {
  type        = string
  description = "URL of the public ssh key to add to the droplets"
  default     = "https://github.com/brucellino.keys"
}


variable "servers" {
  type        = number
  default     = 3
  description = "Number of Nomad servers"
}


variable "agents" {
  type        = number
  default     = 7
  description = "Number of Nomad agents"
}

variable "nomad_ports" {
  type = map(
    object(
      {
        port     = number
        protocol = string
      }
    )
  )
  description = "Map of port names and numbers to assign on the firewall"
  default = {
    api = {
      port     = 4646
      protocol = "tcp"
    },
    rpc = {
      port     = 4647
      protocol = "tcp"
    }
    serf = {
      port     = 4648
      protocol = "tcp"
    }
  }
}

variable "server_size" {
  type        = string
  description = "droplet size for the servers"
  default     = "s-1vcpu-1gb"

  validation {
    condition = contains([
      "s-1vcpu-512mb-10gb",
      "s-1vcpu-1gb",
      "s-1vcpu-1gb-amd",
      "s-1vcpu-1gb-intel",
      "s-1vcpu-2gb",
      "s-1vcpu-2gb-amd",
      "s-1vcpu-2gb-intel",
      "s-2vcpu-2gb",
      "s-2vcpu-2gb-amd",
      "s-2vcpu-2gb-intel",
      "s-2vcpu-4gb",
      "s-2vcpu-4gb-amd",
      "s-2vcpu-4gb-intel",
      "c-2",
      "s-4vcpu-8gb",
      "s-4vcpu-8gb-amd",
      "s-4vcpu-8gb-intel",
      "g-2vcpu-8gb",
      "gd-2vcpu-8gb",
      "m-2vcpu-16gb"],
    var.server_size)
    error_message = "Invalid server size chosen."
  }
}
variable "agent_size" {
  type        = string
  description = "droplet size for the servers"
  default     = "s-1vcpu-1gb"

  validation {
    condition = contains([
      "s-1vcpu-512mb-10gb",
      "s-1vcpu-1gb",
      "s-1vcpu-1gb-amd",
      "s-1vcpu-1gb-intel",
      "s-1vcpu-2gb",
      "s-1vcpu-2gb-amd",
      "s-1vcpu-2gb-intel",
      "s-2vcpu-2gb",
      "s-2vcpu-2gb-amd",
      "s-2vcpu-2gb-intel",
      "s-2vcpu-4gb",
      "s-2vcpu-4gb-amd",
      "s-2vcpu-4gb-intel",
      "c-2",
      "s-4vcpu-8gb",
      "s-4vcpu-8gb-amd",
      "s-4vcpu-8gb-intel",
      "g-2vcpu-8gb",
      "gd-2vcpu-8gb",
      "m-2vcpu-16gb"],
    var.agent_size)
    error_message = "Invalid agent size chosen."
  }
}

variable "username" {
  description = "Name of sudo user for ssh access"
  default     = "hashiuser"
  type        = string
}

# variable "ssh_allowed_cidrs" {
#   type        = list(string)
#   description = "List of CIDRs that we allow ssh access from"

#   validation {
#     condition     = !contains(var.ssh_allowed_cidrs, "0.0.0.0/0")
#     error_message = "Do not allow SSH from the entire internet."
#   }
# }

variable "bastion_device_name" {
  description = "Name of the Tailscale device used as bastion to connect to the cluster"
  sensitive   = false
  type        = string
}

variable "tailnet_name" {
  description = "Name of the tailscale network we are using"
  sensitive   = false
  type        = string
}
