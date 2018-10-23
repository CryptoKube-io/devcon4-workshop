***Devcon4 Workshop***
# Architecting with Ethereum
## Exercise 03: HAProxy

**Introduces:** haproxy, load-balancing, high-availability, terraform modules

### Terraform Config
Edit `main.tf` to use the geth or parity module, and verify the correct resources are referenced in the haproxy section.

### Docker Containers
#### Ethereum
- [geth](https://hub.docker.com/r/ethereum/client-go/) or [parity](https://hub.docker.com/r/parity/parity/) (your choice from previous exercise)
#### HAProxy
- Image: [haproxy](https://hub.docker.com/_/haproxy/)
- Name: `devcon4-haproxy`
- Command (params):
  - TODO
- Ports (proto int:ext ip - name)
  - TCP 8545:8545 127.0.0.1 - HTTP RPC

### Ansible Playbook
Supports both Ethereum clients (automatically, based on inventory)

### Steps

    ansible-galaxy install -r requirements.yml
    cd 03_haproxy

    terraform init

    terraform plan
    terraform apply
    terraform show
    
    ansible-playbook -i terraform-inventory site.yml

    docker ps
    docker logs devcon4-parity_light-01
    docker logs devcon4-parity_light-02
    docker logs devcon4-haproxy

    curl -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"web3_clientVersion","params":[],"id":67}' http://127.0.0.1:8545
    curl -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"net_version","params":[],"id":67}' http://127.0.0.1:8545
    curl -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":74}' http://127.0.0.1:8545

    terraform destroy

---
