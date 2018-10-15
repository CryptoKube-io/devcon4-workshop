# Architecting with Ethereum
***Devcon4 Workshop***

## Prerequisites
- Digital Ocean account w/SSH & API keys
- SSH client & web browser
- Familiarity with Linux & Ethereum

## Initial Setup

### Local Setup

### Management Host
The management host is a 2GB droplet running Ubuntu Server 18.04 LTS. To provision the management host, run `init-mgmt.sh`

It comes preconfigured with the following components:
  - Nginx+LetsEncrypt
  - GoCD
  - Ansible 2.7
  - Terraform 0.11.8. 
  - Packer
  - Virtualbox

## Exercises

### Ethereum Light Client in Local Docker Container

Our first task is to use Terraform and Ansible to deploy a light client in a Docker container. The primary goal is to introduce the tools with minimal chance for complications associated with running a full node or deploying to a remote provider. In addition, this light client will be used to interact with more advanced systems in later exercises.




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
