# Main definition
data "digitalocean_vpc" "selected" {
  name = var.vpc_name
}
