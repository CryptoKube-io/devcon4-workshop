***Devcon4 Workshop***
# Architecting with Ethereum
## Exercise 02: Ethereum full node

**Introduces:** digitalocean volume, full node

Our next goal is to deploy a full node to a DigitalOcean droplet with a dedicated data volume.

### DigitalOcean
- Image: Ubuntu-18-04-x64
- Name: `devcon4-parity-full-01`
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
2. Initialize Terraform working directory:
```bash
terraform init
```
3. View Terraform execution plan:
```bash
terraform plan
```
4. Apply the Terraform config to build the infrastructure:
```bash
terraform apply
```
5. Display the results:
```bash
terraform show
```
6. Run the Ansible playbook to install and configure a Parity full node:
```bash
ansible-playbook -i terraform-inventory site.yml
```
7. Find the remote IP, and SSH into the remote host:
```bash
ip=$(terraform-inventory -list | jq -r .parity_full[0])
ssh root@$ip
```
8. Show logs from our Parity node (ctrl-c to exit):
```bash
journalctl -fu parity.service
```
9. Query Parity using the JSON-RPC interface:
```bash
curl -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"web3_clientVersion","params":[],"id":67}' http://127.0.0.1:8545
curl -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"net_version","params":[],"id":67}' http://127.0.0.1:8545
curl -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":74}' http://127.0.0.1:8545
```
10. Logout from the SSH session (ctrl-d)

11. From the management host, clean up the infrastructure by deleting everything:
```bash
terraform destroy
```

---

Continue to [Exercise 03 - Proxy](../03_proxy/README.md) after returning to the workshop root: `cd /root/devcon4-workshop`
