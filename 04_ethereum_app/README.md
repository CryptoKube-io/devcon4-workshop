***Devcon4 Workshop***
# Architecting with Ethereum
## Exercise 04: Ethereum Application Server

**Introduces:** full Ethereum application stack

---

### Steps

1. Enter the exercise directory:
```bash
cd 04_ethereum_app
```
2. Initialize the Terraform configuration, and view the execution plan:
```bash
terraform init
terraform plan
```
3. Apply the Terraform config to build the infrastructure, then show the results:
```bash
terraform apply
terraform show
```
4. View the dynamic inventory that will be used by Ansible:
```bash
terraform-inventory -inventory
```
5. Run the Ansible playbook to install & configure all applications:
```bash
ansible-playbook -i terraform-inventory site.yml
```
6. Obtain IP address of app server, and view in web browser:
```bash
ip=$(terraform-inventory -list | jq -r .app_node[0])
echo "http://$ip:3000"
```
7. Obtain IP address of proxy, and View HAProxy statistics page in web browser:
```
ip=$(terraform-inventory -list | jq -r .haproxy[0])
echo http://$ip:8545/haproxy?stats
```
8. Try some JSON-RPC requests with the proxy:
```bash
function web3query() { 
  curl -s -H "Content-Type: application/json" -X POST --data "{\"jsonrpc\":\"2.0\",\"method\":\"$1\",\"params\":[],\"id\":74}" http://$ip:8545 | jq -r .result ;
}

web3query web3_clientVersion
web3query net_version
web3query net_peerCount
```
9. Repeat the peer_count query to observe different nodes handling the request:
```bash
for i in `seq 1 6`; do
  web3query net_peerCount
  sleep 1
done
```
10. Clean up the infrastructure by deleting everything:
```bash
terraform destroy
```

---

### Improvements
- Reserved peers
- Data volume snapshotting
- Redundandt app servers behind proxy
- Quorum of full nodes, healthcheck improvements
