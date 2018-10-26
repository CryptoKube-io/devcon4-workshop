***Devcon4 Workshop***
# Architecting with Ethereum
## Exercise 03: Reverse proxy

**Introduces:** ansible, haproxy, terraform modules

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

1. Install Ansible roles from Galaxy (in workshop root directory):

    ansible-galaxy install -r requirements.yml

2. Enter the exercise directory:

    cd 03_haproxy

3. Initialize the Terraform configuration, and view the execution plan:

    terraform init
    terraform plan

4. Apply the Terraform config to build the infrastructure, then show the results:

    terraform apply
    terraform show
    
6. Run the Ansible playbook to update Parity's configuration:

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
