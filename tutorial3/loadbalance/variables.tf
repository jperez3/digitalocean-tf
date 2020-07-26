variable "do_token" {
  description = "Digital Ocean auth token"
}

variable "ssh_fingerprint" {
  description = "MD5 fingerprint for Public SSH key"
}

variable "region" {
  description = "DigitalOcean region"
  default     = "sfo2"
}