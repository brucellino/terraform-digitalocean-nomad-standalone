[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit) [![pre-commit.ci status](https://results.pre-commit.ci/badge/github/brucellino/terraform-digitalocean-nomad-standalone/main.svg)](https://results.pre-commit.ci/latest/github/brucellino/terraform-digitalocean-nomad-standalone/main) [![semantic-release: conventional](https://img.shields.io/badge/semantic--release-conventional-e10079?logo=semantic-release)](https://github.com/semantic-release/semantic-release)

# Terraform Digitalocean Nomad standalone

This module deploys a Nomad cluster in standalone (no Consul or Vault) on DigitalOcean droplets.

The servers and agents are created separately.
Servers are added to a loadbalancer, while clients are kept behind it.

This module provisions resources _up to_ the Nomad API; for other resources (Nomad CSI volumes, Nomad jobs, Nomad configuration, _etc_, use a different module)

## Examples

The `examples/` directory contains the example usage of this module.
These examples show how to use the module in your project, and are also use for testing in CI/CD.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >1.2.0 |
| <a name="requirement_digitalocean"></a> [digitalocean](#requirement\_digitalocean) | >=2.21.0 |
| <a name="requirement_tailscale"></a> [tailscale](#requirement\_tailscale) | >=0.13.6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_digitalocean"></a> [digitalocean](#provider\_digitalocean) | 2.21.0 |
| <a name="provider_http"></a> [http](#provider\_http) | 3.0.1 |
| <a name="provider_tailscale"></a> [tailscale](#provider\_tailscale) | 0.13.6 |
| <a name="provider_vault"></a> [vault](#provider\_vault) | 3.8.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [digitalocean_droplet.client](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/droplet) | resource |
| [digitalocean_droplet.server](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/droplet) | resource |
| [digitalocean_firewall.nomad](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/firewall) | resource |
| [digitalocean_firewall.ssh](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/firewall) | resource |
| [digitalocean_loadbalancer.external](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/loadbalancer) | resource |
| [digitalocean_project_resources.nomad](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/project_resources) | resource |
| [digitalocean_ssh_key.nomad](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/ssh_key) | resource |
| [digitalocean_tag.nomad](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/tag) | resource |
| [digitalocean_tag.nomad_client](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/tag) | resource |
| [digitalocean_tag.nomad_server](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/tag) | resource |
| [digitalocean_volume.nomad_data](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/volume) | resource |
| [digitalocean_image.ubuntu](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/data-sources/image) | data source |
| [digitalocean_project.p](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/data-sources/project) | data source |
| [digitalocean_vpc.selected](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/data-sources/vpc) | data source |
| [http_http.nomad_server_health](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |
| [http_http.ssh_key](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |
| [tailscale_device.bastion](https://registry.terraform.io/providers/tailscale/tailscale/latest/docs/data-sources/device) | data source |
| [vault_generic_secret.join_token](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_agent_size"></a> [agent\_size](#input\_agent\_size) | droplet size for the servers | `string` | `"s-1vcpu-1gb"` | no |
| <a name="input_agents"></a> [agents](#input\_agents) | Number of Nomad agents | `number` | `7` | no |
| <a name="input_bastion_device_name"></a> [bastion\_device\_name](#input\_bastion\_device\_name) | Name of the Tailscale device used as bastion to connect to the cluster | `string` | n/a | yes |
| <a name="input_datacenter"></a> [datacenter](#input\_datacenter) | Name of the Nomad datacenter | `string` | `"dc1"` | no |
| <a name="input_nomad_ports"></a> [nomad\_ports](#input\_nomad\_ports) | Map of port names and numbers to assign on the firewall | <pre>map(<br>    object(<br>      {<br>        port     = number<br>        protocol = string<br>      }<br>    )<br>  )</pre> | <pre>{<br>  "api": {<br>    "port": 4646,<br>    "protocol": "tcp"<br>  },<br>  "rpc": {<br>    "port": 4647,<br>    "protocol": "tcp"<br>  },<br>  "serf": {<br>    "port": 4648,<br>    "protocol": "tcp"<br>  }<br>}</pre> | no |
| <a name="input_nomad_version"></a> [nomad\_version](#input\_nomad\_version) | Nomad version | `string` | `"1.4.3"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of the Nomad project | `string` | `"nomad"` | no |
| <a name="input_server_size"></a> [server\_size](#input\_server\_size) | droplet size for the servers | `string` | `"s-1vcpu-1gb"` | no |
| <a name="input_servers"></a> [servers](#input\_servers) | Number of Nomad servers | `number` | `3` | no |
| <a name="input_ssh_public_key_url"></a> [ssh\_public\_key\_url](#input\_ssh\_public\_key\_url) | URL of the public ssh key to add to the droplets | `string` | `"https://github.com/brucellino.keys"` | no |
| <a name="input_tailnet_name"></a> [tailnet\_name](#input\_tailnet\_name) | Name of the tailscale network we are using | `string` | n/a | yes |
| <a name="input_username"></a> [username](#input\_username) | Name of sudo user for ssh access | `string` | `"hashiuser"` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Name of the VPC we will terraform Nomad into. | `string` | `"vpc"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_agent_cost"></a> [agent\_cost](#output\_agent\_cost) | Monthly cost of the agents |
| <a name="output_lb_ip"></a> [lb\_ip](#output\_lb\_ip) | IP of the server loadbalancer |
| <a name="output_server_cost"></a> [server\_cost](#output\_server\_cost) | Monthly cost of the servers |
| <a name="output_server_ips"></a> [server\_ips](#output\_server\_ips) | Nomad server public IPs |
<!-- END_TF_DOCS -->
