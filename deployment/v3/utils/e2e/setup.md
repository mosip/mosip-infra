# Cluster on E2E Cloud

## VM
- Ubuntu 20.04
- Hourly billed
- CPU 12, RAM 30
- Same VPC
- Rename the nodes to a consistent name
- Number of replicas
- Public IP is not required as we would use Wireguard
- Root user is 'root' (not 'ubuntu')

## Docker 
```
ansible-playbook -i hosts.ini docker.yaml
```

## Wireguard
- Open required Wireguard ports 
```
ansible-playbook -i hosts.ini wireguard.yaml
```
- Install wireguard docker with enough number of peers
- Assign peer1 to yourself and set your wireguard client

## Open ports
```
ansible-playbook -i hosts.ini ports.yaml
```

## Disable swap 
Need to check if this step is required.

```
ansible-playbook -i hosts.ini swap.yaml
```

