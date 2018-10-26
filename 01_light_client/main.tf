resource "digitalocean_tag" "eth_light_tag" {
  name = "${var.project}-eth_light"
}

resource "digitalocean_tag" "project_tag" {
  name = "${var.project}"
}

resource "digitalocean_droplet" "parity_light" {
  count = 1
  image = "${var.do_image_slug}"
  name = "${var.project}-parity-light-${format("%02d", count.index + 1)}"
  region = "${var.do_region}"
  size = "${var.do_size}"
  private_networking = true
  ssh_keys           = ["${split(",",var.do_keys)}"]
  user_data          = "${data.template_file.user_data.rendered}"
  tags               = ["${digitalocean_tag.eth_light_tag.id}", "${digitalocean_tag.project_tag.id}"]

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

# Passing in user-data to set up Ansible user for configuration
data "template_file" "user_data" {
  template = "${file("config/cloud-config.yaml")}"

  vars {
    public_key   = "${var.public_key}"
    ansible_user = "${var.ansible_user}"
  }
}

resource "digitalocean_firewall" "etherum_light" {
  name = "ethereum-light"
  droplet_ids = ["${digitalocean_droplet.parity_light.id}"]

  inbound_rule = [
    {
      protocol = "tcp"
      port_range = "22"
      source_addresses = ["${var.mgmt_ip}"]
    },
    {
      protocol = "tcp"
      port_range = "8545-8546"
      source_addresses = ["${var.mgmt_ip}"]
    },
    {
      protocol = "tcp"
      port_range = "30303"
      source_addresses = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol = "udp"
      port_range = "30301"
      source_addresses = ["0.0.0.0/0", "::/0"]
    }
  ]

  outbound_rule = [
    {
      protocol = "tcp"
      port_range = "1-65535"
      destination_addresses = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol = "udp"
      port_range = "1-65535"
      destination_addresses = ["0.0.0.0/0", "::/0"]
    }
  ]
}

