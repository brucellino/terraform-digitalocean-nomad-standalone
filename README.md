[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit) [![pre-commit.ci status](https://results.pre-commit.ci/badge/github/brucellino/terraform-digitalocean-nomad-standalone/main.svg)](https://results.pre-commit.ci/latest/github/brucellino/terraform-digitalocean-nomad-standalone/main) [![semantic-release: conventional](https://img.shields.io/badge/semantic--release-conventional-e10079?logo=semantic-release)](https://github.com/semantic-release/semantic-release)

# Terraform Digitalocean Nomad standalone

This module deploys a Nomad cluster in standalone (no Consul or Vault) on DigitalOcean droplets.

The servers and agents are created separately.
Servers are added to a loadbalancer, while clients are kept behind it.

This module provisions resources _up to_ the Nomad API; for other resources (Nomad CSI volumes, Nomad jobs, Nomad configuration, _etc_, use a different module)

## Examples

The `examples/` directory contains the example usage of this module.
These examples show how to use the module in your project, and are also use for testing in CI/CD.
