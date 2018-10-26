***Devcon4 Workshop***
# Architecting with Ethereum
## Exercise 02: Ethereum full node

**Introduces:** digitalocean, parity, full node

Our next goal is to deploy a full node, except this time we deploy to a DigitalOcean droplet and use Parity instead of Geth.

### Terraform Config
TODO

### DigitalOcean
- Image: 
- Name: `devcon4-parity_full-00
- Size: 4gb
- Firewall (allow):
  - Ingress:
    - TCP 22: allow from private net
    - TCP 8545-8546: allow from private net
    - TCP 30303: allow from all
    - UDP 30301: allow from all
  - Egress:
    - TCP 22: allow to private net
    - TCP 80: allow to all
    - TCP 8545-8546: allow to private net
    - TCP 30303: allow to all
    - UDP 30301: allow to all

### Ansible 
- Inventory: `terraform-inventory`
- Parity:
  - network: kovan
  - cache: 3072

### Steps

1. Enter the exercise directory:

    cd 02_full_node

2. Use the helper script to set Terraform variables:

    bin/init_config

3. Initialize the Terraform configuration, and view the execution plan:

    terraform init
    terraform plan

4. Apply the Terraform config to build the infrastructure, then show the results:

    terraform apply
    terraform show
    
4. View running Docker containers, and show logs from our Parity light client:

    docker ps
    docker logs devcon4-parity_light

5. Query the Parity node using API calls to the RPC interface:

    curl -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"web3_clientVersion","params":[],"id":67}' http://127.0.0.1:8545
    curl -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"net_version","params":[],"id":67}' http://127.0.0.1:8545
    curl -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":74}' http://127.0.0.1:8545

6. Run the Ansible playbook to update Parity's configuration:

    ansible-playbook -i terraform-inventory site.yml

7. Show Parity logs and make API calls again:

    docker logs devcon4-parity_light
    curl -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"web3_clientVersion","params":[],"id":67}' http://127.0.0.1:8545
    curl -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"net_version","params":[],"id":67}' http://127.0.0.1:8545
    curl -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":74}' http://127.0.0.1:8545

6. Clean up the infrastructure by deleting everything:

    terraform destroy

---
