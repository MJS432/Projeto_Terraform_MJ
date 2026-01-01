locals {
  terraform_sa_email = "terraform-sa@${var.project_id}.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "terraform_network_admin" {
  project = var.project_id
  role    = "roles/compute.networkAdmin"
  member  = "serviceAccount:${local.terraform_sa_email}"
}

# firewall
resource "google_project_iam_member" "terraform_security_admin" {
  project = var.project_id
  role    = "roles/compute.securityAdmin"
  member  = "serviceAccount:${local.terraform_sa_email}"
}

resource "google_project_iam_member" "terraform_instance_admin" {
  project = var.project_id
  role    = "roles/compute.instanceAdmin.v1"
  member  = "serviceAccount:${local.terraform_sa_email}"
}

# Cloud Storage Admin
resource "google_project_iam_member" "terraform_storage_admin" {
  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${local.terraform_sa_email}"
}

# Cloud SQL Admin
resource "google_project_iam_member" "terraform_sql_admin" {
  project = var.project_id
  role    = "roles/cloudsql.admin"
  member  = "serviceAccount:${local.terraform_sa_email}"
}

resource "google_project_iam_member" "terraform_container_admin" {
  project = var.project_id
  role    = "roles/container.admin"
  member  = "serviceAccount:${local.terraform_sa_email}"
}

resource "google_project_iam_member" "terraform_service_account_user" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${local.terraform_sa_email}"
}

resource "google_project_iam_member" "terraform_artifact_registry_admin" {
  project = var.project_id
  role    = "roles/artifactregistry.admin"
  member  = "serviceAccount:${local.terraform_sa_email}"
}

resource "google_project_iam_member" "terraform_run_admin" {
  project = var.project_id
  role    = "roles/run.admin"
  member  = "serviceAccount:${local.terraform_sa_email}"
}

resource "google_project_iam_member" "terraform_cloud_functions_admin" {
  project = var.project_id
  role    = "roles/cloudfunctions.admin"
  member  = "serviceAccount:${local.terraform_sa_email}"
}