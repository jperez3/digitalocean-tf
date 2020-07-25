output "www-lb-ip" {
    value = "${digitalocean_loadbalancer.www-lb.ip}"
}