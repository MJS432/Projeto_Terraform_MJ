resource "google_redis_instance" "redis" {
  name         = "redis-instance"
  display_name = "Redis Instance"

  redis_version  = "REDIS_7_2"
  tier           = "BASIC"
  memory_size_gb = 2

  region             = "europe-west1"

  authorized_network = var.network

  auth_enabled = true

  maintenance_policy {
    weekly_maintenance_window {
      day = "SUNDAY"
      start_time {
        hours   = 6
        minutes = 0
        seconds = 0
        nanos   = 0
      }
    }
  }

  persistence_config {
    persistence_mode    = "RDB"
    rdb_snapshot_period = "SIX_HOURS"
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "google_secret_manager_secret" "redis_auth_string" {
  secret_id = "redis-auth-string"
  replication {
    user_managed {
      replicas {
        location = "europe-west1"
      }
    }
  }
}

resource "google_secret_manager_secret_version" "redis_auth_string_version" {
  secret      = google_secret_manager_secret.redis_auth_string.id
  secret_data = google_redis_instance.redis.auth_string
}

resource "google_secret_manager_secret" "redis_host" {
  secret_id = "redis-host"
  replication {
    user_managed {
      replicas {
        location = "europe-west1"
      }
    }
  }
}

resource "google_secret_manager_secret_version" "redis_host_version" {
  secret      = google_secret_manager_secret.redis_host.id
  secret_data = google_redis_instance.redis.host
}

resource "google_secret_manager_secret" "redis_port" {
  secret_id = "redis-port"
  replication {
    user_managed {
      replicas {
        location = "europe-west1"
      }
    }
  }
}

resource "google_secret_manager_secret_version" "redis_port_version" {
  secret      = google_secret_manager_secret.redis_port.id
  secret_data = google_redis_instance.redis.port
}