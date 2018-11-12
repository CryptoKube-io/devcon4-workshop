***Devcon4 Workshop***
# Architecting with Ethereum
## Exercise 04: Ethereum Application Server

**Introduces:** full Ethereum application stack

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
4. Run the Ansible playbook to install & configure all applications:
```bash
ansible-playbook -i terraform-inventory site.yml
```
5. Obtain IP address of proxy, query it multiple times, and observe which backend handles each request
```bash
ip=$(terraform-inventory -list | jq -r .haproxy[0])
for i in `seq 1 10`; do curl -k $ip:8545; sleep 1; done    
```
6. View HAProxy statistics page in web browser:
```
http://$ip:8545/haproxy?stats
```
7. Obtain IP address of app server, and view in web browser:
```bash
ip=$(terraform-inventory -list | jq -r .app_node[0])
echo "http://$ip:3000"
```
8. Clean up the infrastructure by deleting everything:
```bash
terraform destroy
```

### Improvements
- Reserved peers
- Data volume snapshotting
- Redundandt app servers behind proxy
- Quorum of full nodes, healthcheck improvements
