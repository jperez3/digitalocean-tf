resource "digitalocean_droplet" "www-1" {
    image = "ubuntu-20-04-x64" # Ubuntu 18.04 image was unavailable 
    name = "www-1"
    region = "SFO2" #Could not create in region from tutorial 
    size = "s-1vcpu-1gb"
    private_networking = true
    ssh_keys = [
      var.ssh_fingerprint
    ]
  connection {

    host = self.ipv4_address
    user = "root"
    type = "ssh"
    private_key = file(var.pvt_key)
    timeout = "2m"
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