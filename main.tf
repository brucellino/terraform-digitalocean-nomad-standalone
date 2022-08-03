# Main definition
data "digitalocean_vpc" "selected" {
  name = var.vpc_name
}

data "digitalocean_project" "p" {
  name = var.project_name
}
data "digitalocean_image" "ubuntu" {
  slug = "ubuntu-20-04-x64"
}

data "vault_generic_secret" "join_token" {
  path = "digitalocean/tokens"
}

data "http" "ssh_key" {
  url = var.ssh_public_key_url
}

resource "digitalocean_ssh_key" "nomad" {
  name       = "Nomad servers ssh key"
  public_key = data.http.ssh_key.response_body
  lifecycle {
    precondition {
      condition     = contains([201, 200, 204], data.http.ssh_key.status_code)
      error_message = "Status code is not OK"
    }
  }
}

# data "http" "nomad_health" {
#   url = join("", ["http://", digitalocean_loadbalancer.external.ip, "/v1/status/leader"])
#   lifecycle {
#     postcondition {
#       condition     = contains([201, 200, 204], self.status_code)
#       error_message = "Nomad has no leader. Service not healthy"
#     }
#   }
# }

resource "digitalocean_droplet" "server" {
  count         = var.servers
  image         = data.digitalocean_image.ubuntu.slug
  name          = "nomad-${count.index}"
  region        = data.digitalocean_vpc.selected.region
  size          = var.server_size
  vpc_uuid      = data.digitalocean_vpc.selected.id
  ipv6          = false
  backups       = false
  monitoring    = true
  tags          = ["nomad-server", "auto-destroy"]
  ssh_keys      = [digitalocean_ssh_key.nomad.id]
  droplet_agent = true
  volume_ids    = [tostring(digitalocean_volume.nomad_data[count.index].id)]
  user_data = templatefile(
    "${path.module}/templates/userdata.tftpl",
    {
      nomad_version = var.nomad_version
      server        = true
      username      = var.username
      datacenter    = var.datacenter
      servers       = var.servers
      ssh_pub_key   = data.http.ssh_key.body
      tag           = "nomad-server"
      region        = data.digitalocean_vpc.selected.region
      join_token    = data.vault_generic_secret.join_token.data["autojoin_token"]
      domain        = digitalocean_domain.cluster.name
      project       = data.digitalocean_project.p.name
      count         = count.index
    }
  )
  # connection {
  #   type = "ssh"
  #   user = "root"
  #   host = self.ipv4_address
  # }
  # provisioner "remote-exec" {
  #   script = "${path.module}/provision/start-nomad.sh"
  # }
  # lifecycle {
  #   postcondition {
  #     condition     = contains([201, 200, 204], data.http.consul_health.status_code)
  #     error_message = "Consul service is not healthy"
  #   }
  # }
}

resource "digitalocean_domain" "cluster" {
  name = "hashi.local"
}

resource "digitalocean_volume" "nomad_data" {
  count                   = var.servers
  region                  = data.digitalocean_vpc.selected.region
  name                    = "nomad-data-${count.index}"
  size                    = "1"
  initial_filesystem_type = "ext4"
  description             = "Persistent data for Nomad server ${count.index}"
}
