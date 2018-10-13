# Workshop

## TODO
- mgmt: ansible playbook
  - ansible, terraform, packer
  - gocd
  - nginx
  - letsencrypt
- mgmt: build image w/packer
- mgmt: document/automate mgmt node deploy
- consul: terraform & ansible
- haproxy: terraform & ansible
- geth: terraform & ansible
- parity: terraform & ansible
- gocd: automate terraform & ansible
- geth: light client
- parity: light client
- apps: terraform, ansible, gocd

## Prerequisites
- Digital Ocean account w/SSH & API keys
- SSH client & web browser

## Initial Setup

### Management Host
The management host is a 2GB droplet running Ubuntu Server 18.04 LTS. To provision the management host, run `init-mgmt.sh`

It comes preconfigured with the following components:
  - Nginx+LetsEncrypt
  - GoCD
  - Ansible 2.7
  - Terraform 0.11.8. 
  - Packer

## Infrastructure Components
- HAProxy w/LetsEncrypt
- Consul service discovery
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
