variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "notification_email" {
  description = "Email address for monitoring notifications"
  type        = string
}

variable "monitored_host" {
  description = "Host to monitor with uptime checks"
  type        = string
  default     = "example.com"
}
