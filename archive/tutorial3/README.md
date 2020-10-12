# Tutorial 3

#### Migrate from ssh based configuration management to user-data config 

* Create `templates` folder in the `loadblanacer` folder
* Create `droplet_user_data.yaml` in `templates folder
* Remove `connection` and `provisioner` stanzas from `digitalocean_droplet` resource definition in `www.tf` file 
* Remove `pub_key` and `pvt_key` variables from `variables.tf`
* add `user_data` paramater to `digital_ocean_droplet` resource in `www.tf` file 
