# Notification Channel (Email)
resource "google_monitoring_notification_channel" "email" {
  display_name = "Email Notification Channel"
  type         = "email"
  
  labels = {
    email_address = var.notification_email
  }
}

# Alert Policy - VM Instance Down
resource "google_monitoring_alert_policy" "instance_down" {
  display_name = "VM Instance Down Alert"
  combiner     = "OR"
  
  conditions {
    display_name = "VM Instance is down"
    
    condition_threshold {
      filter          = "resource.type = \"gce_instance\" AND metric.type = \"compute.googleapis.com/instance/uptime\""
      duration        = "60s"
      comparison      = "COMPARISON_LT"
      threshold_value = 1
      
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }
  
  notification_channels = [google_monitoring_notification_channel.email.id]
  
  alert_strategy {
    auto_close = "1800s"
  }
}

# Alert Policy - High CPU Usage
resource "google_monitoring_alert_policy" "high_cpu" {
  display_name = "High CPU Usage Alert"
  combiner     = "OR"
  
  conditions {
    display_name = "CPU usage above 80%"
    
    condition_threshold {
      filter          = "resource.type = \"gce_instance\" AND metric.type = \"compute.googleapis.com/instance/cpu/utilization\""
      duration        = "300s"
      comparison      = "COMPARISON_GT"
      threshold_value = 0.8
      
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

# Uptime Check - HTTP endpoint
resource "google_monitoring_uptime_check_config" "http_check" {
  display_name = "HTTP Uptime Check"
  timeout      = "10s"
  period       = "60s"
  
  http_check {
    path         = "/"
    port         = "80"
    request_method = "GET"
  }
  
  monitored_resource {
    type = "uptime_url"
    labels = {
      project_id = var.project_id
      host       = var.monitored_host
    }
  }
}
