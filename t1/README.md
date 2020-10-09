
# Lesson 1

### Pre-Flight

#### Create a DigitalOcean Account

* Create a DigitalOcean account [DigitalOcean Free Credit Referral Link](https://m.do.co/c/d26a4fc22a12)
* Create a _Personal Access Token_ (DigitalOcean Control Panel: Left pane>Account>API>Personal access tokens>Generate New Token)
  - Give token Read and Write access
  - Add this token to your password manager. Please look into a password manager if you don't currently use one. 


#### Create new SSH key for Digital Ocean droplets

1. In terminal run: `ssh-keygen -t ed25519 -C "YOUR_EMAIL_ADDRESS_GOES@HERE.COM"`
2. When it asks you for a place to save the key, use the suggested path, but update the filename to be `do_ed25519`, eg. `/home/johndoe/.ssh/do_ed25519` (replacing `johndoe` with your username)
3. Next create a passphrase for the key and confirm it a second time.
4. Run `cat /Users/johndoe/.ssh/do_ed25519.pub` (replacing `johndoe` with your username)
    - Copy output to clipboard
5. Go back to the DigitalOcean control panel and browse to `Accounts>Settings>Security>SSH keys`
    - Press the "Add SSH Key" button and paste the contents of `do_ed25519.pub` into the _SSH key content_ field and give the key the name `taccoform-tutorial`


#### Fork and clone the Taccoform Tutorial repo
1. Go to the [Taccoform Tutorial Repo](https://github.com/jperez3/taccoform-tutorial), fork the repo and clone it.


### Terraform Files

Terraform file basics:
* Terraform files end with `.tf`
* Terraform will only read `.tf` files that live the same directory (usually)
* Terraform files contain a mix of variables, data resource lookups, and resource definitions. 

#### Create a Secrets file

1. Navigate to `tutorial-1`
1. Create a new file called `secrets.tf`
2. In the `secrets.tf` file, create a new terraform variable for your DigitalOcean key:

```
variable "do_token" {
  description = "DigitalOcean personal access token"
  default     = "lfj312lfjh2lfh1orh1fl1jth2jlhga"
}
```
_Note: Replace the default value with your DigitalOcean personal access token_



#### Provider file

The instructions in the `provider.tf` file is a heads up of sorts which tells terraform "Wake up! Expect to communicate with these cloud providers!" As you can see, there are some pre-configured settings on how to connect to DigitalOcean

#### User Data template

In the templates folder you will find a user data file. This file is passed to the droplet (or virtual machine) as instructions on how to configure the operating system after it boots up. This might be the easiest way to automatically configure a droplet, but there are other methods which have their own sets of pros and cons. 


#### Droplet file 

As you can see, the `droplet.tf` file is empty right now, you will now start to write your first bit of terraform.


In the pre-flight, you created an SSH key and uploaded it to DigitalOcean. If you want to load that SSH key onto a new droplet, you will need to perform a lookup on DigitalOcean to find that key. In terraform land this is known as a "data resource." Below you will see the data resource lookup which is needed prior to creating the droplet. Add this definition to your `droplet.tf` file

```hcl
data "digitalocean_ssh_key" "root" { 
  name = "taccoform-tutorial"
}
```
Components:
* `data` tells terraform that the following resource is a lookup
* `digitalocean_ssh_key` is a unique name created by the DigitalOcean provider which allows you to pull in SSH keys
* `root` is a static name give by you and can be anything, but it's better when it's more specific 
* `name` is a parameter which is allowed by the `digitalocean_ssh_key` data resource. More information on this data resource can be found [here](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/data-sources/ssh_key)


Now it's time to actually create the droplet. you will do this by creating a droplet resource definition.


```hcl
resource "digitalocean_droplet" "web" {
  image     = "ubuntu-20-04-x64"
  name      = "web-burrito-prod"
  region    = "sfo2"
  size      = "s-1vcpu-1gb"
  ssh_keys  = [data.digitalocean_ssh_key.root.id]
  user_data = templatefile("templates/user_data_nginx.yaml", { hostname = "web-burrito-prod" })
}
```
Components:
* `resource` tells terraform that the following definition is something that needs to be created
* `digitalocean_droplet` is a unique name created by the DigitalOcean provider which creates a droplet
* `web` is a static name given by you and can be anything, but it's btter when it's more specific
* `image` is a DigitalOcean supported operating system (required)
* `name` is a unique name provided by you. I prefer to use the format `NodeType-ServiceName-Environment` (required)
* `region` is a unique location provided by DigitalOcean (required)
* `size` is a unique code provided by DigitalOcean to tell terraform how big of a droplet needs to be provisioned. The size defined is the smallest server offering by DigitalOcean and is $5/month. We're destroy these after the tutorial, so your bill will be less than that. (required)
* `user_data` is the set of instructions on what to do after the operating system has been installed. Of note here is that we're using the template function to call the file from the templates folder and pass through the `hostname` variable.


### Terraform Installation and Commands

#### Install Terraform

**Mac OS**

* Open terminal
* Install Brew: `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"`
* Install Hashicorp tap: `brew tap hashicorp/tap`
* Install Terraform: `brew install terraform`

**Windows**

* Open terminal app
* Install Chocolatey: `Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))`
* Install Terraform: `choco install terraform`

#### Terraform Commands

* `terraform init` - This initializes terraform (duh) which means it pulls in the provider information, downloads any modules that are referenced in the code and set up the terraform statefile 

* `terraform plan` - This is a dry-run feature of terraform to see what would happen if you executed the provisioning based on what's in the code and in your terraform statefile 

* `terraform apply` - This executes the provisioning or destruction of resources based on what is in your code and the terraform statefile 

* `terraform destroy` - This is a pretty well named subcommand. It will destroy everything listed in your terraform statefile 


#### Run Terraform



