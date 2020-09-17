
# This is what tells terraform where to find the statefile
terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "ordisius"

    workspaces {
      name = "digital-ocean-tutorial"
    }
  }
}


# This tells terraform which APIs to expect to interaface with, which version to use and
# which version of terraform is required
terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 1.22.2"
    }
  }
  required_version = ">= 0.13"
}

# This is how authentication to digital ocean is called
provider "digitalocean" {
  token = var.do_token
}