variable "do_token" {
  description = "Digital Ocean auth token"
}
variable "pub_key" {
  description = "Public SSH key used for Digital Ocean droplet provisioning"
}
variable "pvt_key" {
  description = "Private SSH key used for Digital Ocean droplet provisioning"
}
variable "ssh_fingerprint" {
  description = "MD5 fingerprint for Public SSH key"
}

variable "region" {
    description = "DigitalOcean region"
    default     = "sfo2"
}