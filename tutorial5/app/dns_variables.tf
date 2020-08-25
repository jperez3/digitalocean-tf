variable "domain" {
    description = "your custom domain name"
    default     = "taccoform.com"
}

data "digitalocean_domain" "default" {
  name = var.domain
}