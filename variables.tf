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