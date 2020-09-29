
# Lesson 1

### Pre-Flight

#### Create a DigitalOcean Account

* Create a DigitalOcean account [DigitalOcean Free Credit Referral Link](https://m.do.co/c/d26a4fc22a12)
* Create a _Personal Access Token_ (DigitalOcean Control Panel: Left pane>Account>API>Personal access tokens>Generate New Token)
  - Give token Read and Write access
  - Add this token to your password manager. Please look into a password manager if you don't currently use one. 


#### Create new SSH key for Digital Ocean droplets

1. In terminal run: `ssh-keygen -t rsa -b 4096 -C "your_email@example.com"`, replacing the example email address
    - Save the keys to your ssh directory, eg `/Users/johndoe/.ssh/do_rsa` (replacing `johndoe` with your username)
2. Run `cat /Users/johndoe/.ssh/do_rsa.pub` (replacing `johndoe` with your username)
    - Copy output to clipboard
3. Go back to the DigitalOcean control panel and browse to `Accounts>Settings>Security>SSH keys`
    - Press the "Add SSH Key" button and paste the contents of `do_rsa.pub` into the _SSH key content_ field and give the key the name `web-burrito-prod` (more explanation later.)


#### Add DigitalOcean/Terraform environment variables

1. Open your bash profile: `sudo vi ~/.bash_profile`
2. Add your DigitalOcean Personal Access Token

Add the following line with your personal access token pasted after the `=`.
`~/.bash_profile`
```bash
export TF_VAR_do_token=1230jfoweaj02014812048120218240rfhiohf203r82483240328
```

_By prefixing the variable names with `TF_VAR_` terraform will automatically inject the value of this variable into terraform variables with the same name. This is important to keep sensitive data out of code repositories._ 

3. Save and exit your `bash_profile`

4. In your terminal run `source ~/.bash_profile`, then make sure the variable has loaded by printing it, eg `echo $TF_VAR_pub_key`

5. Now in the `app` folder run `terraform init && terraform plan` to run them in succession



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