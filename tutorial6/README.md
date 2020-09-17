# Tutorial 6

# Updating app 
* Add "create before distroy" to web droplets
    - Still takes around ~1:30min outage
* update load balancer health check:
    - `check_interval_section`: 5 (seconds)
    - `protocol`: http
    - `port`: 80



# Deployment Ideas
* Use `tbump` to update the configs to kick off `user-data` change to:
    - download version zip from git, unzip, build container, run container
    or
    - pull repo, build container, run container
    or 
    - pull container from public repo and run container


### Resources
* [Zero downtime updates with terraform](https://github.com/nicholasjackson/terraform-digitalocean-lifecycle)    