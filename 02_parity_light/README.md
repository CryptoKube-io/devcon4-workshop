***Devcon4 Workshop***
# Architecting with Ethereum
## Exercise 02: Parity Light Client

**Introduces:** ansible, parity, Eth reserved peers

### Terraform Config
Same as geth, but substitute in parity Docker image.

### Docker Container
- Image: [parity/parity](https://hub.docker.com/r/parity/parity/)
- Name: `devcon4-parity_light`
- Command (params):
  - TODO `light`
  - `--jsonrpc-interface 127.0.0.1`
  - TODO `ws`
- Ports (proto int:ext ip - name)
  - TCP 8545:8545 127.0.0.1 - HTTP RPC
  - TCP 8546:8546 127.0.0.1 - HTTP WS
  - TCP 30303:30303 0.0.0.0 - P2P
  - UDP 30301:30301 0.0.0.0 - node discovery

### Ansible Playbook
Uses `terraform-inventory` for automated inventory. Applies Parity configuration via config.toml

### Steps

    ansible-galaxy install -r requirements.yml
    cd 02_parity_light

    terraform init

    terraform plan
    terraform apply
    terraform show
    
    docker ps
    docker logs devcon4-parity_light
    curl -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"web3_clientVersion","params":[],"id":67}' http://127.0.0.1:8545
    curl -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"net_version","params":[],"id":67}' http://127.0.0.1:8545
    curl -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":74}' http://127.0.0.1:8545

    ansible-playbook -i terraform-inventory site.yml

    docker logs devcon4-parity_light
    curl -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"web3_clientVersion","params":[],"id":67}' http://127.0.0.1:8545
    curl -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"net_version","params":[],"id":67}' http://127.0.0.1:8545
    curl -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":74}' http://127.0.0.1:8545

    terraform destroy

---
