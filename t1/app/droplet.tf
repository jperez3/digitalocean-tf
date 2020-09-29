data "digitalocean_ssh_key" "root" {
  name = "joe-win1"
}

resource "digitalocean_droplet" "web" {
  image     = "ubuntu-20-04-x64"
  name      = "web-burrito-prod"
  region    = "sfo2"
  size      = "s-1vcpu-1gb"
  ssh_keys  = [data.digitalocean_ssh_key.root.id]
  user_data = templatefile("templates/user_data_nginx.yaml", { hostname = "web-burrito-prod" })

  lifecycle {
    create_before_destroy = true
  }
}

output "droplet_public_ip" {
  value = digitalocean_droplet.web.ipv4_address
}