# Lesson 1

### Pre-Flight

* Create a DigitalOcean account
* Create a _Personal Access Token_ (DigitalOcean Control Panel: Left pane>Account>API>Personal access tokens>Generate New Token)
  - Give token Read and Write access
  - Add this token to your password manager. 


### Housekeeping

#### Create new SSH key for Digital Ocean droplets

1. In terminal run: `ssh-keygen -t rsa -b 4096 -C "your_email@example.com"`, replacing the example email address
    - Save the keys to your ssh directory, eg `/Users/johndoe/.ssh/do_rsa` (replacing `johndoe` with your username)
2. Run `cat /Users/johndoe/.ssh/do_rsa.pub` (replacing `johndoe` with your username)
    - Copy output to clipboard
3. Go back to the DigitalOcean control panel and browse to `Accounts>Settings>Security>SSH keys`
    - Press the "Add SSH Key" button and paste the contents of `do_rsa.pub` into the _SSH key content_ field and give the key an appropriate/memorable name.


#### Add DigitalOcean/Terraform environment variables

1. Open your bash profile: `sudo vi ~/.bash_profile`
2. Add your DigitalOcean Personal Access Token and SSH fingerprint (found in Account>Settings>Security>SSH Keys) 

Add the following lines to match the defined variable names in `variables.tf` and prefix them with `TF_VAR_`. Don't forget to update the values with your personal values

`~/.bash_profile`
```bash
export TF_VAR_do_token=1230jfoweaj02014812048120218240rfhiohf203r82483240328
export TF_VAR_ssh_fingerprint=12:11:22:33:44:55:66:77:88:99:00:11:22:33:44:55
export TF_VAR_pvt_key=/Users/johndoe/.ssh/do_rsa
export TF_VAR_pub_key=/Users/johndoe/.ssh/do_rsa.pub
```

_By prefixing the variable names with `TF_VAR_` terraform picks up those environment variables and registers their values. This is important to keep sensitive data out of code repositories._ 

3. Save and exit your `bash_profile`

4. In your terminal run `source ~/.bash_profile`, then make sure the variables have loaded by printing them, eg `echo $TF_VAR_pub_key`

5. Now in the `app` folder run `terraform init && terraform plan` to run them in succession
    - Now you should be able to run terraform commands without the extra `-var` flags


### Organize Terraform files and variables

Many terraform tutorials will use the filename `main.tf` and possibly `variables.tf`. When terraform will read any file in the current directory that ends with the extension `.tf`. Use this freedom to organize resources and their respective variables. I prefer to keep `variables.tf` around as a place to house variables that will be needed by multiple resources. (More on this later)


1. Create `variables.tf` file

`variables.tf`
```hcl
variable "do_token" {}
variable "pub_key" {}
variable "pvt_key" {}
variable "ssh_fingerprint" {}
```

Above is the minimum you need to define variables. When a default value isn't defined and no environment variables are found, terraform prompts the user for these missing/required values when they run terraform which is not a great experience.


3. Add descriptions to the variables to make it easier to remember what they do when you come back to this project at a later time, eg:

`variables.tf`
```hcl
variable "pub_key" {
  description = "Public SSH key used for Digital Ocean droplet provisioning"
}
variable "pvt_key" {
  description = "Private SSH key used for Digital Ocean droplet provisioning"
}
variable "ssh_fingerprint" {
  description = "MD5 fingerprint for Public SSH key"
}
```

#### Creating the www Droplet Resources
1. Create a file called `www.tf` in the `app` folder
2. Add droplet resource definitions to the `www.tf` folder

`www.tf`
```hcl
resource "digitalocean_droplet" "www-1" {
    image = "ubuntu-20-04-x64" # Ubuntu 18.04 image was unavailable 
    name               = "www-1"
    region             = "sfo2"
    size               = "s-1vcpu-1gb"
    private_networking = true
    ssh_keys = [
      var.ssh_fingerprint
    ]
  connection {

    host        = self.ipv4_address
    user        = "root"
    type        = "ssh"
    private_key = file(var.pvt_key)
    timeout     = "2m"
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

resource "digitalocean_droplet" "www-2" {
    image              = "ubuntu-20-04-x64"
    name               = "www-2"
    region             = "sfo2"
    size               = "s-1vcpu-1gb"
    private_networking = true
    ssh_keys = [
      var.ssh_fingerprint
    ]
  connection {

    host        = self.ipv4_address
    user        = "root"
    type        = "ssh"
    private_key = file(var.pvt_key)
    timeout     = "2m"
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
```

3. Create a file called `www_variables.tf` in the `app` folder
4. Create a variable for each parameter in the `digitalocean_droplet` resource definition, excluding the provisioner provisioner block
    - For the `name` variable, be sure to add interpolation create unique naming for the droplets

`www.tf`
```hcl
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
``` 

`www_variables.tf`
```hcl
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
```

#### Creating the Load Balancer Resource
1. Create a file called loadbalancer.tf in the `app` folder with the following resource:

`loadbalancer.tf`
```hcl
resource "digitalocean_loadbalancer" "www-lb" {
  name   = "web-lb"
  region = "sfo2" # SFO2 (all caps) works in droplet creation, but not here 

  forwarding_rule {
    entry_port     = 80
    entry_protocol = "http"

    target_port     = 80
    target_protocol = "http"
  }

  healthcheck {
    check_interval_seconds = 5
    path                   = "/"
    port                   = 80
    protocol               = "http"
  }

  droplet_ids = [digitalocean_droplet.www-1.id, digitalocean_droplet.www-2.id ]
}
```

2. Create a file called `loadbalancer_variables.tf` in the `app` folder
3. Create a variable for each parameter in the `digitalocean_loadbalancer` resource definition, reusing previously created `region` variable 
- For the `name` variable, be sure to add interpolation to map the droplet name to the load balancer to help organize future services 


`loadbalancer.tf`
```hcl
resource "digitalocean_loadbalancer" "www-lb" {
  name   = "${var.droplet_name}-lb"
  region = var.region

  forwarding_rule {
    entry_port     = var.lb_entry_port
    entry_protocol = var.lb_entry_protocol

    target_port     = var.lb_target_port
    target_protocol = var.lb_target_protocol
  }

  healthcheck {
    port                   = var.lb_health_check_port
    protocol               = var.lb_health_check_protocol
    check_interval_seconds = var.lb_health_check_interval_seconds
    path                   = var.lb_health_check_path    
  }

  droplet_ids = [digitalocean_droplet.www-1.id, digitalocean_droplet.www-2.id]
}


```

`loadbalancer_variables.tf`
```
variable "lb_entry_port" {
  description = "load balancer entry port"
  default     = 80
}

variable "lb_entry_protocol" {
  description = "load balancer entry protocol"
  default     = "http"
}

variable "lb_target_port" {
  description = "load balancer target port"
  default     = 80
}

variable "lb_target_protocol" {
  description = "load balancer target protocol"
  default     = "http"
}

variable "lb_health_check_port" {
  description = "load balancer health check port"
  default     = 80
}

variable "lb_health_check_protocol" {
  description = "load balancer health check protocol"
  default     = "http"
}

variable "lb_health_check_interval_seconds" {
  description = "load balancer health check interval seconds"
  default     = 5
}

variable "lb_health_check_path" {
  description = "load balancer health check path"
  default     = "/"
}
```

#### Configuring the DigitalOcean Provider
The provider is what tells terraform which version of terraform should be used and tells terraform which APIs to use to create resources. In our case, terraform will be interacting with the DigitalOcean APIs and will be using the DigitalOcean provider.


1. Create a file called `provider.tf` in the `app` folder with the following provider information defined:

`provider.tf`
```hcl
terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 1.22.2"
    }
  }
  required_version = ">= 0.13"
}

provider "digitalocean" {
  token = var.do_token
}
```

#### Creating an output

1. Create a file called `outputs.tf` in the `app` folder
    - Create an output for the load balancer IP, this will make it easier to grab the IP address for testing and the IP might change between rebuilds 

`outputs.tf`
```hcl
output "www-lb-ip" {
  value = digitalocean_loadbalancer.www-lb.ip
}
```

_`digitalocean_loadbalancer.www-lb.ip` grabs the `ip` attribute from the `www-lb` `digitalocean_loadbalancer`_

### Running Terraform

* Terraform's most common commands are:
  - `terraform init` which initializes the workspaces, providers, modules, etc
  - `terraform plan` which compares the current state of the workspace (or folder) to what is defined in the terraform files. This acts as a dry-run for terraform changes
  - `terraform apply` which executes the creation/changes/destruction of resources within the workspace or folder

_By default, Terraform only reads the resource definitions in `.tf` files in the current directory_

* Run `terraform init`, you should see something like the output below:

`terraform init`
```
Initializing the backend...

Initializing provider plugins...
- Finding digitalocean/digitalocean versions matching "~> 1.22.2"...
- Installing digitalocean/digitalocean v1.22.2...
- Installed digitalocean/digitalocean v1.22.2 (signed by a HashiCorp partner, key ID F82037E524B9C0E8)

Partner and community providers are signed by their developers.
If you'd like to know more about provider signing, you can read about it here:
https://www.terraform.io/docs/plugins/signing.html

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

* If all looks good, move on to `terraform plan`. You should see the 3 resources to be created and an output similar to the one below:

`terraform plan`
```
Plan: 3 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + www-lb-ip = (known after apply)

------------------------------------------------------------------------

Note: You didn't specify an "-out" parameter to save this plan, so Terraform
can't guarantee that exactly these actions will be performed if
"terraform apply" is subsequently run.
```

* After plan comes apply, run `terraform apply`. You will get a similar response as plan with a confirmation to continue with the execution. 

`terraform apply`
```
Plan: 3 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + www-lb-ip = (known after apply)

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: 
```
Confirm with `yes`


* After the apply has completed, ou should see the load balancer's Public IP address:

```
Apply complete! Resources: 2 added, 0 changed, 1 destroyed.

Outputs:

www-lb-ip = XXX.XXX.XXX.XXX
```

* Browse to the load balancer's IP via `http://XXX.XXX.XXX.XXX` and you should be greeted by the default NGINX page


* Remove all resources so that you don't get billed for them with `terraform destory`:

`terraform destroy`
```
Plan: 0 to add, 0 to change, 3 to destroy.

Changes to Outputs:
  - www-lb-ip = "123.123.1233.123" -> null

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

digitalocean_loadbalancer.www-lb: Destroying... [id=0496ca6e-c3df-40ec-875f-28eb49b96aaa]
digitalocean_loadbalancer.www-lb: Destruction complete after 1s
digitalocean_droplet.www-2: Destroying... [id=207315327]
digitalocean_droplet.www-1: Destroying... [id=207315506]
digitalocean_droplet.www-1: Still destroying... [id=207315506, 10s elapsed]
digitalocean_droplet.www-2: Still destroying... [id=207315327, 10s elapsed]
digitalocean_droplet.www-1: Still destroying... [id=207315506, 20s elapsed]
digitalocean_droplet.www-2: Still destroying... [id=207315327, 20s elapsed]
digitalocean_droplet.www-1: Destruction complete after 22s
digitalocean_droplet.www-2: Destruction complete after 23s
```

#### Wrap up 


* In this tutorial, you:
    - Updated the environment variables to make it easier to work with terraform commands
    - Organized the terraform files and variables to make it easier to keep variables in sync across multiple resources (eg. `region`)
    - Created an output to retrieve the load balancer IP so that you can check the nginx functionality without having to lookup the IP in the DigitalOcean console

* Remember to run `terraform destroy` at the end to deprovision the resources 

