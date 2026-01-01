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