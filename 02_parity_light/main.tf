data "docker_registry_image" "parity" {
  name = "parity/parity:stable"
}

resource "docker_image" "parity" {
  name = "${data.docker_registry_image.parity.name}"
  pull_triggers = ["${data.docker_registry_image.parity.sha256_digest}"]
}

resource "docker_container" "parity_light" {
  name = "${var.project}-parity_light"
  image = "${docker_image.parity.latest}"
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

