module "digitalocean-parity-light" {
  source = "modules/digitalocean-parity-light"

  node_count = 1

  ssh_fingerprint = "${var.ssh_fingerprint}"
  private_key_path = "${var.private_key_path}"
  public_key = "${var.public_key}"
  project = "${var.project}"
  do_region = "${var.do_region}"
  do_token = "${var.do_token}"
  do_keys = "${var.do_keys}"
  mgmt_ip = "${var.mgmt_ip}"
}
