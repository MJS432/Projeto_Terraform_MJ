variable "project_id" {
  description = "ID of the project"
  type        = string
}

variable "project_number" {
  description = "Project Number"
  type        = number
}

variable "region" {
  description = "Deploy region"
  type        = string
}

# sql variables
variable "sql_database" {
  description = "Database name"
  type        = string
}

variable "sql_user" {
  description = "Database user"
  type        = string
}

variable "sql_password" {
  description = "Database password"
  type        = string
}

# monitoring variables
variable "notification_email" {
  description = "Email for monitoring notifications"
  type        = string
}

variable "monitored_host" {
  description = "Host to monitor"
  type        = string
  default     = "example.com"
}