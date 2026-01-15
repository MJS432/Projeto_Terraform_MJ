resource "google_container_cluster" "primary" {
  name     = "projeto-cluster-lusohub"
  location = "europe-west1-b"
  network  = var.network_id
  subnetwork = var.subnet_id

  remove_default_node_pool = true
  initial_node_count       = 1
  deletion_protection      = false

  ip_allocation_policy {
    cluster_secondary_range_name  = var.pods_secondary_range_name
    services_secondary_range_name = var.services_secondary_range_name
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

# Enable the Gateway API
  gateway_api_config {
    channel = "CHANNEL_STANDARD"
  }
}

resource "google_container_node_pool" "lusohub_nodes" {
  name               = "lusohub-node-pool"
  location           = "europe-west1-b"
  cluster            = google_container_cluster.primary.name
  initial_node_count = 1

  autoscaling {
    min_node_count = 1
    max_node_count = 2
  }

  node_config {
    preemptible  = true
    machine_type = "e2-small"
    disk_size_gb = 20
    disk_type    = "pd-standard"

    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }

  lifecycle {
    ignore_changes = [
      node_config[0].resource_labels,
      node_config[0].kubelet_config,
    ]
  }
}

#--------------------------------------------------------------------------
# Workload Identity Bindings
resource "google_service_account_iam_member" "workload_identity_binding" {
  service_account_id = "projects/${var.project_id}/serviceAccounts/terraform-sa@${var.project_id}.iam.gserviceaccount.com"
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[default/meme-web-app-sa]"

  depends_on = [google_container_cluster.primary]
}

resource "google_service_account_iam_member" "workload_identity_binding_meme_maker" {
  service_account_id = "projects/${var.project_id}/serviceAccounts/terraform-sa@${var.project_id}.iam.gserviceaccount.com"
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[default/meme-maker-sa]"

  depends_on = [google_container_cluster.primary]
}