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

provider "digitalocean" {
  token = data.vault_generic_secret.do.data["token"]
}

module "vpc" {
  source     = "brucellino/vpc/digitalocean"
  version    = "1.0.0"
  vpc_name   = "nomad"
  vpc_region = "ams2"
  project = {
    description = "Nomad Project"
    environment = "development"
    name        = "NomadTest"
    purpose     = "Testing Nomad Standalone"
  }
}

module "example" {
  depends_on   = [module.vpc]
  source       = "../../"
  vpc_name     = "nomad"
  project_name = "NomadTest"
}
