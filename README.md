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
- nginx: terraform & ansible
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
