***Devcon4 Workshop***
# Architecting with Ethereum
## Excercise 01: Ethereum light client

**Introduces:** terraform, docker, geth, light client

Our first task is to use Terraform to deploy a light client in a Docker container. The primary goal is to introduce the tools with minimal chance for complications (avoiding full nodes and cloud providers). Geth is best configured using only command-line options (rather than a config file), so we can accomplish this using just Terraform and Docker.

### Terraform Config
This Terraform config is very basic. It checks Docker Hub for the latest stable geth image, downloads it, and creates a container from it.

### Docker Container
- Image: [ethereum/client-go](https://hub.docker.com/r/ethereum/client-go/)
- Name: `devcon4-geth_light`
- Command (params):
  - `--syncmode light`
  - `--rpc --rpcaddr 127.0.0.1 --rpcport 8545`
  - `--ws --wsaddr 127.0.0.1 --wsport 8546`
- Ports (proto int:ext ip - name)
  - TCP 8545:8545 127.0.0.1 - HTTP RPC
  - TCP 8546:8546 127.0.0.1 - HTTP WS
  - TCP 30303:30303 0.0.0.0 - P2P
  - UDP 30301:30301 0.0.0.0 - node discovery

### Steps

1. Enter the exercise directory:

    cd 01_geth_light

2. Initialize the Terraform configuration, and view the execution plan:

    terraform init
    terraform plan

3. Apply the Terraform config to build the infrastructure, then show the results:

    terraform apply
    terraform show
   
4. View running Docker containers, and show logs from our Geth light client:
 
    docker ps
    docker logs devcon4-geth_light

5. Query the Geth node using API calls to the RPC interface:

    curl -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"web3_clientVersion","params":[],"id":67}' http://127.0.0.1:8545
    curl -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"net_version","params":[],"id":67}' http://127.0.0.1:8545
    curl -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":74}' http://127.0.0.1:8545

6. Clean up the infrastructure by deleting everything:

    terraform destroy

---

Continue to [exercise 02](../02_parity_light/README.md)
