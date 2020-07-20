Digital Ocean Tutorial notes

* Several things are wrong which disrupts the tutorial/learning flow:
    - NYC region throws an error
    - Image throws an error 
    - `SFO2` region works in droplet creation, but not in load balancer creation (must use `sfo2`)
    - It's unclear if you should include the quotes or curly brackets when exporting the environment variables 
* The terraform install process is longer than it needs to be, you can install `tfswitch` then do `tfswitch 0.12.24`

* New ssh key should be created for this project, eg (`do_rsa`)
* Interesting use of `sed` to create the `www-2.tf` file from `www-1.tf`
* Including the variable flags in every terraform command is a bit annoying, you can either use a `.tfvars` file or append `TF_` to the exported environment variables which terraform will automatically pull in 
* Terraform state is stored locally, should be in terraform cloud, S3 (or the digital ocean equivalent)
* Skipped DNS creation for now