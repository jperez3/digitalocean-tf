provider "digitalocean" {
  token = var.do_token
}

terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "ordisius"

    workspaces {
      name = "digital-ocean-tutorial"
    }
  }
}
