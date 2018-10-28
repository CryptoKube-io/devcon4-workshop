***Devcon4 Workshop***
# Architecting with Ethereum
## Exercise 02: Ethereum full node

**Introduces:** digitalocean volume, full node

Our next goal is to deploy a full node to a DigitalOcean droplet with a dedicated data volume.

### Terraform Config
TODO

### DigitalOcean
- Image: 
- Name: `devcon4-parity_full-01`
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
```bash
cd 02_full_node
```

2. Use the helper script to set Terraform variables:
```bash
bin/init_config
```

3. Initialize the Terraform configuration, get modules and view the execution plan:
```bash
terraform init
terraform get
terraform plan
```

4. Apply the Terraform config to build the infrastructure, then show the results:
```bash
terraform apply
terraform show
```
    
5. Run the Ansible playbook to install and configure Parity:
```bash
ansible-playbook -i terraform-inventory site.yml
```

6. Find the remote IP, SSH into the remote host, and show logs from our Parity light client:
```bash
ip=$(terraform-inventory -list | jq -r .parity_full[0])
ssh root@$ip
journalctl -fu parity.service
```
7. Query the Parity node using API calls to the RPC interface:
```bash
curl -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"web3_clientVersion","params":[],"id":67}' http://127.0.0.1:8545
curl -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"net_version","params":[],"id":67}' http://127.0.0.1:8545
curl -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":74}' http://127.0.0.1:8545
```

8. Clean up the infrastructure by deleting everything:
```bash
terraform destroy
```

---
