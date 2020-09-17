resource "digitalocean_loadbalancer" "www-lb" {
  name   = "${var.droplet_name}-lb"
  region = var.region

  forwarding_rule {
    entry_port     = var.lb_entry_port
    entry_protocol = var.lb_entry_protocol

    target_port     = var.lb_target_port
    target_protocol = var.lb_target_protocol
  }

  healthcheck {
    check_interval_seconds = var.lb_health_check_interval_seconds
    path                   = var.lb_health_check_path    
    port                   = var.lb_health_check_port
    protocol               = var.lb_health_check_protocol
  }

  droplet_ids = [digitalocean_droplet.www-1.id, digitalocean_droplet.www-2.id]
}
