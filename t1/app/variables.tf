variable "env" {
  description = "unique stage/environment name"
  default     = "prod"
}

variable "service" {
  description = "unique service name, keep short for FQDN assignment"
  default     = "lettuce"
}

variable "domain" {
  description = "domain name"
  default     = "taccoform.com"
}

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

