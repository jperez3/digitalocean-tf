# Tutorial 5

### DNS
* Purchase a domain
* Create NS records for domain and point them to ns{1-3}.digitalocean.com
* Create core workspace
    - change workspace name
    - go into `app.terraform.io` settings and disable remote runs for new workspace
    - Add new DNS zone for the domain you purchased
    - Run `terraform apply`
* Check NS records: `dig taccoform.com NS`
    - might take a while to see new records due to TTL setting
* Create `dns_variables.tf` file for domain variable and data source lookup for dns zone
* Create DigitalOcean A record for `www` and point it to the LB public IP
* Update port and protocol on load balancer (https/443)
* Create `www` certificate 
* Add `www` certificate to load balancer




#### doctl

* get droplet names: `doctl compute droplet list --output json | jq '.[].name'`