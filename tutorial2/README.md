# Tutorial 2


### Count 


* You can have multiple resources of the same type (eg. `www-1`, `www-2`, etc), but it becomes unruly to manage after a certain point.

#### Consolidate web servers

* Delete the `www-2.tf` file
* Rename `www-1.tf` to `www.tf`
* In `www.tf`, Change the resource name to `www`:

```
 resource "digitalocean_droplet" "www" {
```

* Add a new `droplet_count` variable to `www_variables`

```
variable "droplet_count" {
    description = "the number of droplets to create"
    default     = 2
}
```

* Create a new parameter under the `digitalocean_droplet` resource called `count` and apply the previously created `droplet_count` variable

```
resource "digitalocean_droplet" "www" {
  count = var.droplet_count
  ...
  ...

}
```

* In the `digitalocean_droplet` resource, update the `name` parameter to include `count.index`, this will increment the name's suffix number starting at `0`

```
resource "digitalocean_droplet" "www" {

  "${var.droplet_name}-${count.index}"
  ...
  ...
}
```


#### Update the `digitalocean_loadbalancer` `droplet_ids`

* Since we removed `www-2` and consolidated it into one resource, the `droplet_ids` parameter needs to be updated

* Using count in the `digitalocean_droplet` changes thew way we need to reference it. Terraform represents this with the format `resource_type.resource_name.*.ids` 
* Splat or `*` is telling the parameter to loop through the list and add each droplet. In this case, parameter will look like this:

```
resource "digitalocean_loadbalancer" "www-lb" {
  ...
  ...
  ...
  droplet_ids = digitalocean_droplet.www.*.id
}
```