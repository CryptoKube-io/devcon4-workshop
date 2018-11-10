***Devcon4 Workshop***
# Architecting with Ethereum
## Exercise 03: Reverse proxy

**Introduces:** haproxy

### Terraform Config
Edit `main.tf` to use the geth or parity module, and verify the correct resources are referenced in the haproxy section.

#### HAProxy
- Name: `devcon4-haproxy`
- Command (params):
  - TODO
- Ports (proto int:ext ip - name)
  - TCP 8545:8545 127.0.0.1 - HTTP RPC

### Ansible Playbook
Supports both Ethereum clients (automatically, based on inventory)

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
    
4. Run the Ansible playbook to update Parity's configuration:
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
