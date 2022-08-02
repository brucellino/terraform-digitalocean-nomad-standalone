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

variable "nomad_version" {
  type        = string
  default     = "1.3.2"
  description = "Nomad version"

  validation {
    condition     = can(regex("^(?P<major>0|[1-9]\\d*)\\.(?P<minor>0|[1-9]\\d*)\\.(?P<patch>0|[1-9]\\d*)(?:-(?P<prerelease>(?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\\.(?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\\+(?P<buildmetadata>[0-9a-zA-Z-]+(?:\\.[0-9a-zA-Z-]+)*))?$", var.nomad_version))
    error_message = "Only support Nomad versions up to 1.3.2. Please check Nomad releases https://releases.hashicorp.com/nomad"
  }
}
