terraform {
  required_version = ">1.2.0"
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.21.0"
    }

    tailscale = {
      source  = "tailscale/tailscale"
      version = "0.13.6"
    }
  }
}
