variable "droplet_image" {
  description = "droplet image or operating system"
  default     = "ubuntu-20-04-x64"
}

variable "droplet_name" {
  description = "droplet name"
  default     = "www"
}

variable "droplet_size" {
  description = "droplet resource size"
  default     = "s-1vcpu-1gb"
}

variable "droplet_private_network" {
  description = "connect droplet to private network"
  default     = true
}

variable "droplet_user" {
  description = "droplet connection user"
  default     = "root"
}

variable "droplet_type" {
  description = "droplet connection type"
  default     = "ssh"
}

variable "droplet_timeout" {
  description = "droplet connection timeout"
  default     = "2m"
}