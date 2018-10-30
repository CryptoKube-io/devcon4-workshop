resource "digitalocean_tag" "proxy_tag" {
  name = "${var.project}-proxy"
}

resource "digitalocean_tag" "eth_tag" {
  name = "${var.project}-eth"
}

resource "digitalocean_tag" "app_tag" {
  name = "${var.project}-app"
}

resource "digitalocean_tag" "project_tag" {
  name = "${var.project}"
}

resource "digitalocean_droplet" "haproxy" {
  count = "${var.proxy_node_count}"
  image = "${var.do_image_slug}"
  name = "${var.project}-proxy-${format("%02d", count.index + 1)}"
  region = "${var.do_region}"
  size = "${var.proxy_do_size}"
  private_networking = true
  monitoring = true
  ssh_keys = ["${split(",",var.do_keys)}"]
  user_data = "${data.template_file.user_data_haproxy.rendered}"
  tags = ["${digitalocean_tag.proxy_tag.id}", "${digitalocean_tag.project_tag.id}"]

  connection {
    user     = "root"
    type     = "ssh"
    key_file = "${var.private_key_path}"
    timeout  = "2m"
  }
}

resource "digitalocean_volume" "parity_data" {
  count = "${var.eth_node_count}"
  region = "${var.do_region}"
  name = "${var.project}-parity-data-${format("%02d", count.index + 1)}"
  size = 250
  initial_filesystem_type = "ext4"
  description = "Parity Ethereum data"
}

resource "digitalocean_droplet" "parity_node" {
  count = "${var.eth_node_count}"
  image = "${var.do_image_slug}"
  name = "${var.project}-eth-${format("%02d", count.index + 1)}"
  region = "${var.do_region}"
  size = "${var.eth_do_size}"
  private_networking = true
  ssh_keys = ["${split(",",var.do_keys)}"]
  user_data = "${data.template_file.user_data_eth.rendered}"

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

resource "digitalocean_volume_attachment" "parity_data" {
  count = "${var.eth_node_count}"
  droplet_id = "${element(digitalocean_droplet.parity_node.*.id, count.index)}"
  volume_id = "${element(digitalocean_volume.parity_data.*.id, count.index)}"
}

resource "digitalocean_droplet" "app_node" {
  count = "${var.app_node_count}"
  image = "${var.do_image_slug}"
  name = "${var.project}-app-${format("%02d", count.index + 1)}"
  region = "${var.do_region}"
  size = "${var.app_do_size}"
  private_networking = true
  ssh_keys = ["${split(",",var.do_keys)}"]
  user_data = "${data.template_file.user_data_app.rendered}"

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

# Pre-configure Droplets using cloud-init user data
data "template_file" "user_data_haproxy" {
  template = "${file("${path.module}/config/haproxy-config.yaml")}"

  vars {
    public_key = "${var.public_key}"
    ansible_user = "${var.ansible_user}"
  }
}

data "template_file" "user_data_eth" {
  template = "${file("${path.module}/config/eth-config.yaml")}"

  vars {
    public_key = "${var.public_key}"
    ansible_user = "${var.ansible_user}"
  }
}

data "template_file" "user_data_app" {
  template = "${file("${path.module}/config/app-config.yaml")}"

  vars {
    public_key = "${var.public_key}"
    ansible_user = "${var.ansible_user}"
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

#resource "digitalocean_firewall" "proxy" {
#  name = "proxy"
#  droplet_ids = ["${digitalocean_droplet.haproxy.id}"]
#
#  inbound_rule = [
#    {
#      protocol = "tcp"
#      port_range = "22"
#      source_addresses = ["${var.mgmt_ip}"]
#    },
#    {
#      protocol = "tcp"
#      port_range = "8545-8546"
#      source_addresses = ["${var.mgmt_ip}"]
#    },
#    {
#      protocol = "tcp"
#      port_range = "30303"
#      source_addresses = ["0.0.0.0/0", "::/0"]
#    },
#    {
#      protocol = "udp"
#      port_range = "30301"
#      source_addresses = ["0.0.0.0/0", "::/0"]
#    }
#  ]
#
#  outbound_rule = [
#    {
#      protocol = "tcp"
#      port_range = "1-65535"
#      destination_addresses = ["0.0.0.0/0", "::/0"]
#    },
#    {
#      protocol = "udp"
#      port_range = "1-65535"
#      destination_addresses = ["0.0.0.0/0", "::/0"]
#    }
#  ]
#}
#
#resource "digitalocean_firewall" "backend" {
#  name = "backend"
#  droplet_ids = ["${digitalocean_droplet.backend_node.id}"]
#
#  inbound_rule = [
#    {
#      protocol = "tcp"
#      port_range = "22"
#      source_addresses = ["${var.mgmt_ip}"]
#    },
#    {
#      protocol = "tcp"
#      port_range = "8545-8546"
#      source_addresses = ["${digitalocean_droplet.haproxy.ipv4_address_private}"]
#    },
#    {
#      protocol = "tcp"
#      port_range = "30303"
#      source_addresses = ["0.0.0.0/0", "::/0"]
#    },
#    {
#      protocol = "udp"
#      port_range = "30301"
#      source_addresses = ["0.0.0.0/0", "::/0"]
#    }
#  ]
#
#  outbound_rule = [
#    {
#      protocol = "tcp"
#      port_range = "1-65535"
#      destination_addresses = ["0.0.0.0/0", "::/0"]
#    },
#    {
#      protocol = "udp"
#      port_range = "1-65535"
#      destination_addresses = ["0.0.0.0/0", "::/0"]
#    }
#  ]
#}

