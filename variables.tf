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
  default     = "1.3.2"
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
  type        = map(number)
  description = "Map of port names and numbers to assign on the firewall"
  default = {
    api = 4646
    rpc = 4647
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

variable "username" {
  description = "Name of sudo user for ssh access"
  default     = "hashiuser"
  type        = string
}
