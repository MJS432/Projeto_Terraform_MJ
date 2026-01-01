resource "google_sql_database_instance" "this" {
  name             = "my-sql-instance"
  database_version = "POSTGRES_17"
  region           = "europe-west1"

deletion_protection = false

  settings {
    tier = "db-f1-micro"

    ip_configuration {
      ipv4_enabled    = true
    }
  }
}

resource "google_sql_database" "my_database" {
  name     = var.sql_database
  instance = google_sql_database_instance.this.name
}

resource "google_sql_user" "my_user" {
  name     = var.sql_user
  instance = google_sql_database_instance.this.name
  password = var.sql_password
}