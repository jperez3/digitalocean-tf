resource "digitalocean_droplet" "www" {
  count              = var.droplet_count
  image              = var.droplet_image
  name               = "${var.droplet_name}-${count.index}"
  region             = var.region
  size               = var.droplet_size
  private_networking = var.droplet_private_network
  ssh_keys = [
    var.ssh_fingerprint
  ]
  user_data = file("${path.module}/templates/droplet_user_data.yaml")

}