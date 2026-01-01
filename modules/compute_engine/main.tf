resource "google_compute_instance" "vm1-instance" {
  name                      = "vm1-instance"
  machine_type              = "e2-medium"
  zone                      = "europe-west1-b"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    network = var.network_name
    subnetwork = var.subnetwork_name
    access_config {
      nat_ip = var.vm1_ip
    }
  }
  
  metadata_startup_script = templatefile("${path.module}/startup_vm1.sh.tpl", {})
  
  tags = ["https-server"]
}