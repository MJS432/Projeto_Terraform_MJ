# Notification Channel (Email)
resource "google_monitoring_notification_channel" "email" {
  display_name = "Email Notification Channel"
  type         = "email"
  
  labels = {
    email_address = var.notification_email
  }
}

# Alert Policy - VM CPU Usage
resource "google_monitoring_alert_policy" "vm_cpu_low" {
  display_name = "VM CPU Usage Alert"
  combiner     = "OR"
  
  conditions {
    display_name = "VM CPU usage detected"
    
    condition_threshold {
      filter          = "resource.type = \"gce_instance\" AND metric.type = \"compute.googleapis.com/instance/cpu/utilization\""
      duration        = "0s"
      comparison      = "COMPARISON_GT"
      threshold_value = 0.01
      
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }
  
  notification_channels = [google_monitoring_notification_channel.email.id]
  
  alert_strategy {
    auto_close = "300s"
  }
}

# Alert Policy - Disk Read Operations
resource "google_monitoring_alert_policy" "disk_ops" {
  display_name = "VM Disk Operations Alert"
  combiner     = "OR"
  
  conditions {
    display_name = "Disk read operations detected"
    
    condition_threshold {
      filter          = "resource.type = \"gce_instance\" AND metric.type = \"compute.googleapis.com/instance/disk/read_ops_count\""
      duration        = "0s"
      comparison      = "COMPARISON_GT"
      threshold_value = 1
      
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }
  
  notification_channels = [google_monitoring_notification_channel.email.id]
  
  alert_strategy {
    auto_close = "300s"
  }
}

# Alert Policy - Network Bytes Sent
resource "google_monitoring_alert_policy" "network_sent" {
  display_name = "VM Network Bytes Sent Alert"
  combiner     = "OR"
  
  conditions {
    display_name = "Network bytes sent detected"
    
    condition_threshold {
      filter          = "resource.type = \"gce_instance\" AND metric.type = \"compute.googleapis.com/instance/network/sent_bytes_count\""
      duration        = "0s"
      comparison      = "COMPARISON_GT"
      threshold_value = 100
      
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }
  
  notification_channels = [google_monitoring_notification_channel.email.id]
  
  alert_strategy {
    auto_close = "300s"
  }
}
