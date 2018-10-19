# Architecting with Ethereum
***Devcon4 Workshop***

## Intro
TODO :)

---

## Prerequisites
- Digital Ocean account w/SSH & API keys
- SSH client & web browser
- Familiarity with Linux & Ethereum

---

## Initial Setup

### Local Setup
TODO

### Management Host
The management host is a 2GB droplet running Ubuntu Server 18.04 LTS. To provision the management host, run TODO

It comes preconfigured with the following components:
  - Nginx+LetsEncrypt
  - GoCD
  - Ansible
  - Terraform 
  - Packer
  - Virtualbox

---

## Excercise 01: Geth Light Client

**Introduces:** terraform, docker, geth, Eth light client

Our first task is to use Terraform and Ansible to deploy a light client in a Docker container. The primary goal is to introduce the tools with minimal chance for complications (avoiding full nodes and cloud providers). In addition, this light client will be used to interact with more advanced systems in later exercises.

### Terraform Config
This Terraform config is very basic. It checks Docker Hub for the latest stable geth image, downloads it, and creates a container from it.

### Docker Container
- Image: [ethereum/client-go](https://hub.docker.com/r/ethereum/client-go/)
- Name: `devcon4-geth_light`
- Command (params):
  - `--syncmode light`
  - `--rpc --rpcaddr 127.0.0.1 --rpcport 8545`
  - `--ws --wsaddr 127.0.0.1 --wsport 8546`
- Ports (proto int:ext ip - name)
  - TCP 8545:8545 127.0.0.1 - HTTP RPC
  - TCP 8546:8546 127.0.0.1 - HTTP WS
  - TCP 30303:30303 0.0.0.0 - P2P
  - UDP 30301:30301 0.0.0.0 - node discovery

### Steps

    cd 01_geth_light
    terraform init
    terraform plan
    terraform apply
    terraform show
    
    docker ps
    docker logs devcon4-geth_light
    curl -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"web3_clientVersion","params":[],"id":67}' http://127.0.0.1:8545
    curl -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"net_version","params":[],"id":67}' http://127.0.0.1:8545
    curl -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":74}' http://127.0.0.1:8545

    terraform destroy

---

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

## Excercise 03: HAProxy

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

## Exercise 04: Parity Full Node

**Introduces:** digitalocean (droplet/volume/firewall), data volumes, Eth full node

### Terraform Config
TODO



---
---

# OLD STUFF

## Infrastructure Components
- HAProxy w/LetsEncrypt
- Consul service discovery (using [brianshumate/ansible-consul](https://github.com/brianshumate/ansible-consul) role)
- Nginx web server
- Ethereum nodes
  - geth
    - full
    - bootstrap
    - light
  - parity
    - full
    - bootstrap
    - light
- Ethereum Applications
  - [Ethereum Network Stats](https://github.com/cubedro/eth-netstats)
    - uses [Ethereum Network Intelligence API](https://github.com/cubedro/eth-net-intelligence-api)
  - [Etherchain light](https://github.com/gobitfly/etherchain-light)
  - [smart-contract-watch](https://github.com/Neufund/smart-contract-watch)
  - [BlockScout](https://github.com/poanetwork/blockscout) - excellent Terraform setup for AWS

# External References
- [Ansible User Guide](https://docs.ansible.com/ansible/latest/user_guide/index.html) (latest)
- [Terraform Docs](https://www.terraform.io/docs/)
- [The Navigator's Guide to Digital Ocean](https://www.digitalocean.com/community/tutorial_series/the-navigator-s-guide-to-digitalocean)
- [Explaining the Genesis Block in Ethereum](https://arvanaghi.com/blog/explaining-the-genesis-block-in-ethereum/)
- [Comparison of the Different Testnets](https://ethereum.stackexchange.com/questions/27048/comparison-of-the-different-testnets) (links to testnet faucets)
