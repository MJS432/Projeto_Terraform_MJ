variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "network_id" {
  description = "The ID of the VPC network"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet"
  type        = string
}

variable "pods_secondary_range_name" {
  description = "The name of the secondary IP range for pods"
  type        = string
}

variable "services_secondary_range_name" {
  description = "The name of the secondary IP range for services"
  type        = string
}