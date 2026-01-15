#VM 1
variable "vm1_ip" {
  description = "Static IP for VM1"
  type        = string
}

variable "network_name" {
  description = "Network name"
  type        = string
}

variable "subnetwork_name" {
  description = "Subnet name"
  type        = string
}