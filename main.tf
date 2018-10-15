# Creating Tags for Load Balancer and Firewall Controls
resource "digitalocean_tag" "backend_tag" {
  name = "${var.project}-backend"
}

resource "digitalocean_tag" "project_tag" {
  name = "${var.project}"
}

## Creating Management Node
#resource "digitalocean_droplet" "mgmt_node" {
#  count               = "1"
#  image               = "${var.image_slug}"
#  name                = "${var.project}-mgmt"
#  region              = "${var.region}"
#  size                = "2gb"
#  private_networking  = true
#  ssh_keys            = ["${split(",",var.keys)}"]
#  user_data           = "${data.template_file.user_data.rendered}"
#  tags                = ["${digitalocean_tag.backend_tag.id}", "${digitalocean_tag.project_tag.id}"]
#
#  lifecycle {
#    create_before_destroy = true
#  }
#
#  connection {
#    user        = "root"
#    type        = "ssh"
#    private_key = "${var.private_key_path}"
#    timeout     = "2m"
#  }
#}

# Creating Ethereum data volume
resource "digitalocean_volume" "eth_node_data" {
  count                   = "${var.eth_node_count}"
  region                  = "${var.region}"
  name                    = "${var.project}-eth-${format("%02d", count.index + 1)}_data"
  size                    = "${var.eth_data_size}"
  initial_filesystem_type = "ext4"
  description             = "Ethereum node data volume"
}

# Creating Ethereum node
resource "digitalocean_droplet" "eth_node" {
  count               = "${var.eth_node_count}"
  image               = "${var.image_slug}"
  name                = "${var.project}-eth-${format("%02d", count.index + 1)}"
  region              = "${var.region}"
  size                = "2gb"
  private_networking  = true
  ssh_keys            = ["${split(",",var.keys)}"]
  user_data           = "${data.template_file.user_data.rendered}"
  volume_ids          = ["${element(digitalocean_volume.eth_node_data.*.id, count.index)}"]
  tags                = ["${digitalocean_tag.backend_tag.id}", "${digitalocean_tag.project_tag.id}"]

  lifecycle {
    create_before_destroy = true
  }

  connection {
    user        = "root"
    type        = "ssh"
    private_key = "${var.private_key_path}"
    timeout     = "2m"
  }
}

## Attaching Ethereum data volume
#resource "digitalocean_volume_attachment" "eth_node_data" {
#  count       = "${var.eth_node_count}"
#  droplet_id  = "${digitalocean_droplet.eth_node[${format("%02d", count.index + 1)}].id}"
#  volume_id   = "${digitalocean_volume.eth_node_data[${format("%02d", count.index + 1)}].id}"
#}

## Creating Consul Nodes
#resource "digitalocean_droplet" "consul_node" {
#  count              = "${var.consul_nodes["count"]}"
#  image              = "${var.image_slug}"
#  name               = "${var.project}-consul-${format("%02d", count.index + 1)}"
#  region             = "${var.region}"
#  size               = "${var.consul_nodes["size"]}"
#  private_networking = true
#  ssh_keys           = ["${split(",",var.keys)}"]
#  user_data          = "${data.template_file.user_data.rendered}"
#  tags               = ["${digitalocean_tag.backend_tag.id}", "${digitalocean_tag.project_tag.id}"]
#
#  lifecycle {
#    create_before_destroy = true
#  }
#
#  connection {
#    user        = "root"
#    type        = "ssh"
#    private_key = "${var.private_key_path}"
#    timeout     = "2m"
#  }
#}

## Creating Web Server Nodes
#resource "digitalocean_droplet" "web_node" {
#  count              = "${var.node_count}"
#  image              = "${var.image_slug}"
#  name               = "${var.project}-web-${format("%02d", count.index + 1)}"
#  region             = "${var.region}"
#  size               = "${var.node_size}"
#  private_networking = true
#  ssh_keys           = ["${split(",",var.keys)}"]
#  user_data          = "${data.template_file.user_data.rendered}"
#  tags               = ["${digitalocean_tag.backend_tag.id}", "${digitalocean_tag.project_tag.id}"]
#
#  lifecycle {
#    create_before_destroy = true
#  }
#
#  connection {
#    user        = "root"
#    type        = "ssh"
#    private_key = "${var.private_key_path}"
#    timeout     = "2m"
#  }
#}

# Passing in user-data to set up Ansible user for configuration
data "template_file" "user_data" {
  template = "${file("config/cloud-config.yaml")}"

  vars {
    public_key   = "${var.public_key}"
    ansible_user = "${var.ansible_user}"
  }
}

## Creating DigitalOcean Load Balancer for Web Servers
#resource "digitalocean_loadbalancer" "public" {
#  name                   = "${var.project}-lb"
#  region                 = "${var.region}"
#  droplet_tag            = "${digitalocean_tag.backend_tag.id}"
#  redirect_http_to_https = false
#  depends_on             = ["digitalocean_tag.backend_tag"]
#
#  forwarding_rule {
#    entry_port     = 80
#    entry_protocol = "http"
#
#    target_port     = 80
#    target_protocol = "http"
#  }
#
#  healthcheck {
#    port                     = 80
#    protocol                 = "http"
#    path                     = "/"
#    check_interval_seconds   = 5
#    response_timeout_seconds = 3
#    unhealthy_threshold      = 2
#    healthy_threshold        = 2
#  }
#}

## Create the Highly Available Database Cluster using Galera and HAProxy
#module "sippin_db" {
#  source           = "github.com/DO-Solutions/galera-tf-mod.git?ref=v1.0.2"
#  project          = "${var.project}"
#  region           = "${var.region}"
#  keys             = "${var.keys}"
#  private_key_path = "${var.private_key_path}"
#  ssh_fingerprint  = "${var.ssh_fingerprint}"
#  public_key       = "${var.public_key}"
#  ansible_user     = "${var.ansible_user}"
#}
