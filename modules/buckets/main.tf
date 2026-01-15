resource "google_storage_bucket" "my_bucket" {
  name          = "lusohub-a22311743"
  location      = "europe-west1"
  storage_class = "STANDARD"

  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

# FIRST RULE:
  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 30
    }
  }
  
# SECOND RULE:
  lifecycle_rule {
    action {
      type          = "SetStorageClass"
      storage_class = "NEARLINE"
    }
    condition {
      age = 7
    }
  }
}


