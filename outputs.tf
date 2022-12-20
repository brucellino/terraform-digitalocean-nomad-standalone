# This is the default outputs file.
# Put all output values here.

# Example:
# output "test" {
#   value = resource.type.name
# }
output "server_ips" {
  description = "Nomad server public IPs"
  value       = digitalocean_droplet.server[*].ipv4_address
}

output "lb_ip" {
  description = "IP of the server loadbalancer"
  value       = digitalocean_loadbalancer.external.ip
}

output "server_cost" {
  description = "Monthly cost of the servers"
  value       = sum(digitalocean_droplet.server[*].price_monthly)
}

output "agent_cost" {
  description = "Monthly cost of the agents"
  value       = sum(digitalocean_droplet.client[*].price_monthly)
}
