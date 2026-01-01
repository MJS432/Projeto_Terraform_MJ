resource "google_container_cluster" "primary" {
  name     = "projeto-cluster-lusohub"
  location = "europe-west1-b"         #alteração da região

  network    = var.network_name
  subnetwork = var.subnetwork_name

  remove_default_node_pool = true
  initial_node_count       = 1
  deletion_protection      = false

  gateway_api_config {
    channel = "CHANNEL_STANDARD"
  }
}

resource "google_container_node_pool" "lusohub_nodes" {
  name       = "lusohub-node-pool"
  location   = "europe-west1-b"       #alteração da região
  cluster    = google_container_cluster.primary.name
  initial_node_count = 1

  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }

  node_config {
    preemptible  = true
    machine_type = "e2-medium"
    disk_size_gb = 30                 #alteração do tamanho do disco
    disk_type    = "pd-standard"      #alteração do tipo do disco
  }

  lifecycle {
    ignore_changes = [
      node_config[0].resource_labels,
      node_config[0].kubelet_config,
    ]
  }
}