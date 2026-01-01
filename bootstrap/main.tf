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