resource "digitalocean_tag" "proxy_tag" {
  name = "${var.project}-proxy"
}

resource "digitalocean_tag" "backend_tag" {
  name = "${var.project}-backend"
}

resource "digitalocean_tag" "project_tag" {
  name = "${var.project}"
}

resource "digitalocean_droplet" "haproxy" {
  count = 1
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

resource "digitalocean_droplet" "backend_node" {
  count = 2
  image = "${var.do_image_slug}"
  name = "${var.project}-backend-${format("%02d", count.index + 1)}"
  region = "${var.do_region}"
  size = "1gb"
  private_networking = true
  ssh_keys = ["${split(",",var.do_keys)}"]
  user_data = "${data.template_file.user_data_nginx.rendered}"

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
  }
}

data "template_file" "user_data_nginx" {
  template = "${file("${path.module}/config/nginx-config.yaml")}"

  vars {
    public_key = "${var.public_key}"
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

