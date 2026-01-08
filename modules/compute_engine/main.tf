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

resource "google_compute_instance" "vm2-instance" {
  name                      = "vm2-instance"
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
  }
  
  tags = ["https-server"]
}

#Managed Instance Group
resource "google_compute_instance_template" "default" {
  name         = "vm-template-server"
  machine_type = "e2-micro"
  region       =  "europe-west1"

  tags = ["https-server"]

  disk {
    source_image = "debian-cloud/debian-12"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network    = var.network_name
    subnetwork = var.subnetwork_name
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt update && apt install -y nginx
    echo "Hello from MIG instance $(hostname)" > /var/www/html/index.html
  EOT
}

#Group Manager
resource "google_compute_instance_group_manager" "default" {
  name               = "vm-group"
  base_instance_name = "mig-vm"
  zone = "europe-west1-b"

  version {
    instance_template = google_compute_instance_template.default.id
  }

  target_size = 3

  update_policy {
    type                    = "PROACTIVE"
    minimal_action          = "REPLACE"
    max_surge_fixed         = 1
    max_unavailable_fixed   = 0
  }

  lifecycle {
    create_before_destroy = true 
  }

  named_port {
    name = "http" 
    port = 80
  }
}