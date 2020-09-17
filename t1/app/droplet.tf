###############
# Web Droplet #
###############
resource "digitalocean_droplet" "web" {
  count              = var.droplet_count
  image              = var.droplet_image
  name               = "${var.droplet_name}${count.index}.${var.service}.${var.env}.${var.domain}"
  region             = var.region
  size               = var.droplet_size
  user_data          = file("templates/droplet_user_data.yaml")

  lifecycle {
    create_before_destroy = true
  }

}


########################
# Web Droplet Firewall #
########################

resource "digitalocean_firewall" "ingress-allow-web" {
  name = "ingress-allow-web"

  droplet_ids = digitalocean_droplet.web.*.id

  inbound_rule {
    protocol         = var.ingress_web_protocol
    port_range       = var.ingress_web_port
    source_addresses = var.internet_cidr_list
  }

}

output "droplet_public_ip" {
  value = digitalocean_droplet.web.*.ipv4_address
}