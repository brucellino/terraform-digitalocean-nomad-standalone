#!/bin/bash
set -eou pipefail
echo "waiting for cloud-init to finish"
while [ ! -f /var/lib/cloud/data/result.json ] ; do
  sleep 10
done
while [[ ! $(exec systemctl list-unit-files | grep nomad) ]] ; do
  echo "waiting for nomad service to be available"
  sleep 10
done
service nomad start || sleep 10 ; service nomad start
echo "waiting for servers to stabilise"
sleep 20
