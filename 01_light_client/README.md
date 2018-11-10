***Devcon4 Workshop***
# Architecting with Ethereum
## Exercise 01: Ethereum light client

**Introduces:** digitalocean, parity

Our next goal is to deploy light client to a DigitalOcean droplet. This time we will use Parity instead of Geth.

### Terraform Config
TODO

### DigitalOcean
- Image: 
- Name: `devcon4-parity_light-01`
- Size: 2gb
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
  - cache: 1024

### Steps

1. Enter the exercise directory, from the workshop root:
```bash
cd 01_light_client
```
2. Initialize Terraform working directory:
```bash
terraform init
```
3. Get Terraform modules:
```bash
terraform get
```
4. View Terraform execution plan:
```bash
terraform plan
```
5. Apply the Terraform config to build the infrastructure:
```bash
terraform apply
```
6. Display the results:
```bash
terraform show
```
7. Run the Ansible playbook to install and configure a Parity light client:
```bash
ansible-playbook -i terraform-inventory site.yml
```
8. Find the remote IP, and SSH into the remote host:
```bash
ip=$(terraform-inventory -list | jq -r .parity_light[0])
ssh root@$ip
```
9. Show logs from our Parity light client (ctrl+c to exit):
```bash
journalctl -fu parity.service
```
10. Query Parity using the JSON-RPC interface:
```bash
curl -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"web3_clientVersion","params":[],"id":67}' http://127.0.0.1:8545
curl -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"net_version","params":[],"id":67}' http://127.0.0.1:8545
curl -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":74}' http://127.0.0.1:8545
```
11. Logout from the SSH session (ctrl-d)

12. From the management host, clean up the infrastructure by deleting everything:
```bash
terraform destroy
```

---

Continue to [Exercise 02 - Full Node](../02_full_node/README.md) after returning to the workshop root: `cd /root/devcon4-workshop`
