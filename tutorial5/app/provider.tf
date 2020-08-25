
terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "ordisius"

    workspaces {
      name = "digital-ocean-tutorial"
    }
  }
}


terraform {
  required_providers {
    digitalocean = {
      source  = "terraform-providers/digitalocean"
      version = "~> 1.22.2"
    }
  }
  required_version = ">= 0.13"
}


provider "digitalocean" {
  token = var.do_token
}