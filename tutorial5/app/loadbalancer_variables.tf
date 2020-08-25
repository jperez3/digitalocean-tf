variable "lb_entry_port" {
  description = "load balancer entry port"
  default     = 443
}

variable "lb_entry_protocol" {
  description = "load balancer entry protocol"
  default     = "https"
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
  default     = 22
}

variable "lb_health_check_protocol" {
  description = "load balancer health check protocol"
  default     = "tcp"
}