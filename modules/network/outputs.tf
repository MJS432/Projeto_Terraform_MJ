#VM E NETWORK 
output "vm1_ip_address" {
  description = "Static external IP for VM1"
  value       = google_compute_address.vm1-ip-address.address
}

output "network_name" {
  value = google_compute_network.this.name
}

output "subnetwork_name" {
  value = google_compute_subnetwork.this.name
}

#--------------------------------------------------------------------------
output "network_id" {
  description = "ID of the VPC network"
  value       = google_compute_network.this.id
}

output "subnet_id" {
  description = "ID of the subnet"
  value       = google_compute_subnetwork.this.id
}

output "pods_secondary_range_name" {
  description = "Name of the secondary range for pods"
  value       = "pods"
}

output "services_secondary_range_name" {
  description = "Name of the secondary range for services"
  value       = "services"
}
