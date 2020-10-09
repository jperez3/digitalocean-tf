#### Save for later

```hcl

resource "digitalocean_firewall" "ingress-allow-web" {
  name = "ingress-allow-web"

  droplet_ids = digitalocean_droplet.web.*.id

  inbound_rule {
    protocol         = var.ingress_web_protocol
    port_range       = var.ingress_web_port
    source_addresses = var.internet_cidr_list
  }

}
```

```hcl
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
```