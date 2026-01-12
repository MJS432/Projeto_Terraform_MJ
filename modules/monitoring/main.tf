# Notification Channel (Email)
resource "google_monitoring_notification_channel" "email" {
  display_name = "Email Notification Channel"
  type         = "email"
  
  labels = {
    email_address = var.notification_email
  }
}

# ===== CLOUD STORAGE ALERTS =====
resource "google_monitoring_alert_policy" "storage_object_count" {
  display_name = "Storage Object Count Alert"
  combiner     = "OR"
  
  conditions {
    display_name = "Object count changed in bucket"
    
    condition_threshold {
      filter          = "resource.type = \"gcs_bucket\" AND metric.type = \"storage.googleapis.com/storage/object_count\""
      duration        = "0s"
      comparison      = "COMPARISON_GT"
      threshold_value = 0
      
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }
  
  notification_channels = [google_monitoring_notification_channel.email.id]
  
  alert_strategy {
    auto_close = "1800s"
  }
}

# ===== REDIS ALERTS =====
resource "google_monitoring_alert_policy" "redis_connections" {
  display_name = "Redis Connected Clients Alert"
  combiner     = "OR"
  
  conditions {
    display_name = "Redis clients connected"
    
    condition_threshold {
      filter          = "resource.type = \"redis_instance\" AND metric.type = \"redis.googleapis.com/clients/connected\""
      duration        = "0s"
      comparison      = "COMPARISON_GT"
      threshold_value = 0
      
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }
  
  notification_channels = [google_monitoring_notification_channel.email.id]
  
  alert_strategy {
    auto_close = "1800s"
  }
}
