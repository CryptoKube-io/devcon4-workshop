output "parity_light_droplet_id" {
  #value = "${element(digitalocean_droplet.parity_light.*.id, count.index)}"
  value = "${digitalocean_droplet.parity_light.*.id}"
}

output "parity_light_ipv4_address" {
  #value = "${element(digitalocean_droplet.parity_light.*.ipv4_address, count.index)}"
  value = "${digitalocean_droplet.parity_light.*.ipv4_address}"
}

output "parity_light_ipv4_address_private" {
  #value = "${element(digitalocean_droplet.parity_light.*.ipv4_address_private, count.index)}"
  value = "${digitalocean_droplet.parity_light.*.ipv4_address_private}"
}
