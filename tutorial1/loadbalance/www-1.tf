resource "digitalocean_droplet" "www-1" {
  image              = var.droplet_image
  name               = "${var.droplet_name}-1"
  region             = var.region
  size               = var.droplet_size
  private_networking = var.droplet_private_network
  ssh_keys = [
    var.ssh_fingerprint
  ]
  connection {

    host        = self.ipv4_address
    user        = var.droplet_user
    type        = var.droplet_type
    private_key = file(var.pvt_key)
    timeout     = var.droplet_timeout
  }
  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      # install nginx
      "sudo apt-get update",
      "sudo apt-get -y install nginx"
    ]
  }
}