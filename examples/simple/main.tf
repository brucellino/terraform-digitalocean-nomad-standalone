terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "3.8.0"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.21.0"
    }
    tailscale = {
      source  = "tailscale/tailscale"
      version = "0.13.6"
    }
  }
  backend "consul" {
    path = "terraform/modules/tfmod-digitalocean-nomad-standalone"
  }
}

provider "vault" {
  # Configuration options
}

data "vault_generic_secret" "do" {
  path = "kv/do"
}

data "vault_generic_secret" "ts" {
  path = "kv/hashiathome"
}

variable "tailnet_name" {
  type = string
}
provider "digitalocean" {
  token = data.vault_generic_secret.do.data["token"]
}

provider "tailscale" {
  api_key = data.vault_generic_secret.ts.data["tailscale_api_token"]
  tailnet = var.tailnet_name
}
module "vpc" {
  source     = "brucellino/vpc/digitalocean"
  version    = "1.0.0"
  vpc_name   = "nomad"
  vpc_region = "ams3"
  project = {
    description = "Nomad Project"
    environment = "development"
    name        = "NomadTest"
    purpose     = "Testing Nomad Standalone"
  }
}

module "nomad" {
  depends_on          = [module.vpc]
  source              = "../../"
  vpc_name            = "nomad"
  nomad_version       = "1.4.3"
  project_name        = "NomadTest"
  servers             = 3
  agents              = 4
  bastion_device_name = "wide"
  tailnet_name        = var.tailnet_name
}

output "server_ips" {
  value = module.nomad.server_ips
}

output "lb_ip" {
  value = module.nomad.lb_ip
}

output "price" {
  value = "Cost: ${sum([module.nomad.server_cost, module.nomad.agent_cost])} USD per month"
}
