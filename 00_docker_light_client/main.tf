data "docker_registry_image" "geth" {
  name = "ethereum/client-go:stable"
}

resource "docker_image" "geth" {
  name = "${data.docker_registry_image.geth.name}"
  pull_triggers = ["${data.docker_registry_image.geth.sha256_digest}"]
}

resource "docker_container" "geth_light" {
  name = "${var.project}-geth_light"
  image = "${docker_image.geth.latest}"
  ports = {
    internal = "30301"
    external = "30301"
    protocol = "udp"
  }
  ports = {
    internal = "30303"
    external = "30303"
  }
  ports = {
    internal = "8545"
    external = "8545"
    ip = "127.0.0.1"
  }
  ports = {
    internal = "8546"
    external = "8546"
    ip = "127.0.0.1"
  }
  command = [
    "--syncmode", "light",
    "--rpc", "--rpcaddr", "0.0.0.0", 
    "--ws", "--wsaddr", "0.0.0.0"
  ]
}

