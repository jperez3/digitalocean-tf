resource "digitalocean_loadbalancer" "www-lb" {
  name   = "${var.droplet_name}-lb"
  region = var.region

  forwarding_rule {
    entry_port     = var.lb_entry_port
    entry_protocol = var.lb_entry_protocol

    target_port     = var.lb_target_port
    target_protocol = var.lb_target_protocol

    certificate_id = digitalocean_certificate.www.id
  }

  healthcheck {
    port     = var.lb_health_check_port
    protocol = var.lb_health_check_protocol
  }

  droplet_ids = digitalocean_droplet.www.*.id
}

#####################
# DNS + Certificate #
#####################

resource "digitalocean_record" "www" {
  domain = data.digitalocean_domain.default.name
  type   = var.dns_record_type
  name   = var.subdomain
  value  = digitalocean_loadbalancer.www-lb.ip
}

resource "digitalocean_certificate" "www" {
  name    = var.subdomain
  type    = var.cert_type
  domains = ["${var.subdomain}.${var.domain}"]
}