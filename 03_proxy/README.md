***Devcon4 Workshop***
# Architecting with Ethereum
## Exercise 03: Reverse proxy

**Introduces:** haproxy

### Steps

1. Enter the exercise directory:
```bash
cd 03_haproxy
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
4. Run the Ansible playbook to install & configure HAProxy:
```bash
ansible-playbook -i terraform-inventory site.yml
```
5. Obtain IP address of proxy, query it multiple times, and observe which backend handles each request
```bash
ip=$(terraform-inventory -list | jq -r .haproxy[0])
for i in `seq 1 10`; do curl -k $ip:8545; sleep 1; done    
```
6. Clean up the infrastructure by deleting everything:
```bash
terraform destroy
```

---

Continue to [Exercise 04 - Ethereum Application](../04_ethereum_app/README.md) after returning to the workshop root: `cd /root/devcon4-workshop`
