***Devcon4 Workshop***
# Architecting with Ethereum

## Table of Contents

- [Intro](#intro)
- [Prerequisites](#prerequisites)
- [Initial Setup](#initial-setup)
  - [Local Setup](#local-setup)
  - [Management Host](#management-host)
- [Exercises](#exercises)
  - [01: Geth Light Client](01_geth_light/README.md)
  - [02: Parity Light Client](02_parity_light/README.md)
  - [03: HAProxy](03_haproxy/README.md)
  - [04: Ethereum Full Node](04_full_node/README.md)
  - [05: IPFS Node](05_ipfs/README.md)
- [Administrative Tooling](#administrative-tooling)
  - [Docker](#docker) (containerization)
  - [Ansible](#ansible) (configuration management)
  - [Packer](#packer) (image builder)
  - [Terraform](#terraform) (cloud deployment)
  - [DigitalOcean](#digitalocean) (IaaS platform)
- [Infrastructure Components](#infrastructure-components)
  - [Reverse Proxy](#reverse-proxy)
    - [HAProxy](#haproxy)
    - [Nginx](#nginx)
  - [Key-value Store](#kv-store) and Service Discovery
    - [Consul](#consul)
- [IPFS](#ipfs)
- [Ethereum Node](#ethereum)
  - [Node Types](#node-types)
  - [Geth](#geth)
  - [Parity](#parity)
- [Ethereum Applications](#ethereum-applications)

---

## Intro

Welcome to the Architecting with Ethereum workshop, presented at Devcon IV in Prague on October 30, 2018.

### CryptoKube.io
CryptoKube is an open source software stack for hosting peer-to-peer cryptographic applications. It currently consists of many separate modules (primarily Ansible, Terraform, and Docker). The ultimate goal is to provide a turnkey Kubernetes implementation (still under development).

Visit [CryptoKube.io](https://cryptokube.io) for the latest details.

### Workshop
In this workshop we build a basic Ethereum application stack using components from the CryptoKube public repos.

We begin by introducing the adminstrative tooling and the major components of the stack. Then we conduct a series of exercises to demonstrate the concepts in realistic use cases. Each exercise builds on previous exercises, and each aims to introduce one major administrative concept and one major P2P crypto node concept.

It is possible to run the exercises locally, although it is recommended to use the provided management host image for greatest environment consistency.

---

## Prerequisites
- Experience: Familiarity with Ethereum and remote Linux administration
- Software: SSH client & web browser
- Assets: Digital Ocean account w/SSH & API keys

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

## Exercises
- [Exercise 01: Geth Light Node](01_geth_light/README.md)
- [Exercise 02: Parity Light Node](02_parity_light/README.md)
- [Exercise 03: HAProxy](03_haproxy/README.md)
- [Exercise 04: Ethereum Full Node](04_full_node/README.md)
- [Exercise 05: IPFS Node](05_ipfs/README.md)

---

## Administrative Tooling
We'll primarily be using Terraform, Ansible, terraform-inventory, Docker, and Git.


### Terraform
*HashiCorp Terraform enables you to safely and predictably create, change, and improve infrastructure. It is an open source tool that codifies APIs into declarative configuration files that can be shared amongst team members, treated as code, edited, reviewed, and versioned.*

Overview:
- Easily describe your infrastructure as code
- Version control your resources, allowing rollback to previous state
- Uses declarative syntax ([HCL](https://github.com/hashicorp/hcl)), fully JSON compatible but extended for easier human consumption

Major Concepts:
- [Configuration](https://www.terraform.io/docs/configuration/index.html): text files with `.tf` extension, describes infrastructure and sets variables
- [State](https://www.terraform.io/docs/state/index.html): `terraform.tfstate`, maps real world resources to your configuration, and keeps track of metadata
- [Providers](https://www.terraform.io/docs/providers/index.html): responsible for understanding API interactions and exposing resources, example: [DigitalOcean](https://www.terraform.io/docs/providers/docker/index.html), [Docker](https://www.terraform.io/docs/providers/docker/index.html), [Consul](https://www.terraform.io/docs/providers/consul/index.html)
- [Modules](https://www.terraform.io/docs/modules/index.html): self-contained packages configurations that are managed as a group, used to create reusable components

**Basic Commands**
To view a list of the available commands at any time, just run `terraform` with no arguments. For details about a command, run `terraform <command> -h`
- `terraform init` - Initialize a new or existing Terraform configuration (install plugins, perform minimal validation)
- `terraform plan` - Generate and show an execution plan
- `terraform show` - Inspect Terraform state or plan
- `terraform apply` - Builds or changes infrastructure
- `terraform destroy` - Destroy Terraform-managed infrastructure

**Links**
- [Terraform Docs](https://www.terraform.io/docs/)
  - [Digitalocean provider](https://www.terraform.io/docs/providers/do/index.html)


### Ansible
*Ansible is an open source software that automates software provisioning, configuration management, and application deployment.* -wikipedia

- [Ansible User Guide](https://docs.ansible.com/ansible/latest/user_guide/index.html) (latest)
- [Ansible Galaxy](https://galaxy.ansible.com/) - repository of roles

*External Training*
- RedHat DO007 [Ansible Essentials: Simplicity in Automation Technical Overview](https://www.redhat.com/en/services/training/do007-ansible-essentials-simplicity-automation-technical-overview)
- Linux Academy: [Ansible Quick Start](https://linuxacademy.com/devops/training/course/name/ansible-quick-start)
- [How To Test Ansible Roles with Molecule on Ubuntu 18.04](https://www.digitalocean.com/community/tutorials/how-to-test-ansible-roles-with-molecule-on-ubuntu-18-04)
- [How to Manage Multistage Environments with Ansible](https://www.digitalocean.com/community/tutorials/how-to-manage-multistage-environments-with-ansible)


### Docker
*Docker is a computer program that performs operating-system-level virtualization also known as containerization.* -wikipedia

- [Docker Reference documentation](https://docs.docker.com/reference/)
- [Docker Community Edition](https://docs.docker.com/install/)
- [Docker Hub](https://hub.docker.com/)


### Packer
*HashiCorp Packer is a tool for building images for cloud platforms, virtual machines, containers and more from a single source configuration.*
- [Packer Docs](https://packer.io/docs/)
- [Community Tools: templates](https://www.packer.io/community-tools.html#templates)


### DigitalOcean
*DigitalOcean is an Infrastructure as a Service (IaaS) platform that aims to be "The simplest cloud platform for developers & teams."*
- [DigitalOcean Product Documenation](https://www.digitalocean.com/docs/)
- [The Navigator's Guide to DigitalOcean](https://www.digitalocean.com/community/tutorial_series/the-navigator-s-guide-to-digitalocean)
- [Use Terraform with DigitalOcean](https://www.digitalocean.com/community/tutorials/how-to-use-terraform-with-digitalocean)

---

## Infrastructure Components

### Reverse Proxy

**Load balancing**
*Load balancing improves the distribution of workloads across multiple computing resources, such as computers, a computer cluster, network links, central processing units, or disk drives.* -wikipedia

**High availability**
*High availability is a characteristic of a system, which aims to ensure an agreed level of operational performance, usually uptime, for a higher than normal period.* -wikipedia

- DigitalOcean tutorials
  - [What is Load Balancing?](https://www.digitalocean.com/community/tutorials/what-is-load-balancing)
  - [What is High Availability?](https://www.digitalocean.com/community/tutorials/what-is-high-availability)
  - [Navigator's Guide: High Availability](https://www.digitalocean.com/community/tutorials/navigator-s-guide-high-availability)

#### HAProxy
- [HAProxy Community Edition](http://www.haproxy.org/)
- [HAProxy 1.8 Docs](http://www.haproxy.org/#doc1.8)

#### Nginx
- [NGINX Admin Guide](https://docs.nginx.com/nginx/admin-guide/)
- Nginx glossary: [What is Load Balancing? How Load Balancers Work](https://www.nginx.com/resources/glossary/load-balancing/)

### Service Discovery & KV Store

#### Consul
- [Consul Docs](https://www.consul.io/docs/)
- Consul service discovery (using [brianshumate/ansible-consul](https://github.com/brianshumate/ansible-consul) role)

---

## Interplanetary Filesystem (IPFS)
- [IPFS Docs](https://docs.ipfs.io/)
- Docker Hub: [ipfs/go-ipfs](https://hub.docker.com/r/ipfs/go-ipfs/) ([github](https://github.com/ipfs/go-ipfs))
- IPFS blog: [Run IPFS in a Docker Container](https://ipfs.io/blog/1-run-ipfs-on-docker/)

---

## Ethereum 
- [Ethereum Wiki](https://github.com/ethereum/wiki/wiki)
- [Ethereum Yellow Paper](https://github.com/ethereum/yellowpaper)
- Book: [Mastering Ethereum](https://github.com/ethereumbook/ethereumbook) by Andreas M. Antonopoulos, Gavin Wood

### Ports
Service | Protocol | Port | Interface
--------|----------|------|----------
HTTP RPC | TCP | 8545 | private
HTTP WS | TCP | 8546 | private
P2P | TCP | 30303 | public
Node discovery | UDP | 30301 | public

### Networks
Here are the most commonly-used networks:

Net ID | Chain ID | Description | Consensus | Client(s)
-------|----------|-------------|-----------|----------
1 | 1 | Ethereum mainnet | PoW | All
3 | 1 | Ropsten testnet | PoW | All
4 | 1 | Rinkeby tesnet | PoA | Geth
42 | 1 | Kovan testnet | PoA | Parity
1 | 61 | Ethereum Classic mainnet | PoW | All
2 | 1 | Ethereum Classic testnet | PoW | All

**Links**
- EIP-155: [List of Chain ID's](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-155.md#list-of-chain-ids)
- [Comparison of the Different Testnets](https://ethereum.stackexchange.com/questions/27048/comparison-of-the-different-testnets) (links to testnet faucets)
- [Explaining the Genesis Block in Ethereum](https://arvanaghi.com/blog/explaining-the-genesis-block-in-ethereum/) (important to understand for private networks, which are not addressed further in this workshop)

### Node Types
Name | Headers | Transactions | State | Notes
-----|---------|--------------|-------|------
Light client    | All | On-demand | On-demand | suitable for mobile & embedded applications
Full node       | All | All       | Pruned    | suitable for most server applications
Archive node    | All | All       | All       | necessary only for deep block exploration
Bootstrap node  | All | All       | Pruned    | required for private blockchains

### Geth
- Docker Hub: [ethereum/client-go](https://hub.docker.com/r/ethereum/client-go/)
- Geth wiki
  - [Command Line Options](https://github.com/ethereum/go-ethereum/wiki/Command-Line-Options)
  - [Connecting to the network](https://github.com/ethereum/go-ethereum/wiki/Connecting-to-the-network) (geth does not work well with a config file, so use command-line options for everything)
  - [Running in Docker](https://github.com/ethereum/go-ethereum/wiki/Running-in-Docker)
  - [JSON-RPC](https://github.com/ethereum/wiki/wiki/JSON-RPC) reference

### Parity
- Docker Hub: [parity/parity](https://hub.docker.com/r/parity/parity)
- Parity Wiki: [Docker](https://wiki.parity.io/Docker)

---

## Ethereum Applications
  - [Ethereum Network Stats](https://github.com/cubedro/eth-netstats)
    - uses [Ethereum Network Intelligence API](https://github.com/cubedro/eth-net-intelligence-api)
  - [Etherchain light](https://github.com/gobitfly/etherchain-light)
  - [smart-contract-watch](https://github.com/Neufund/smart-contract-watch)
  - [BlockScout](https://github.com/poanetwork/blockscout) - excellent Terraform setup for AWS

---
