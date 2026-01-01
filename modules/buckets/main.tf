resource "google_storage_bucket" "my_bucket" {
  name          = "lusohub-a22311743"
  location      = "europe-west1"
  storage_class = "STANDARD"

  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 30
    }
  }
  
#Esta nova regra irá:
#Transicionar objetos para a classe de armazenamento NEARLINE após 7 dias
#A regra existente continua a deletar objetos após 30 dias
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


