# Notification Channel (Email)
resource "google_monitoring_notification_channel" "email" {
  display_name = "Email Notification Channel"
  type         = "email"
  
  labels = {
    email_address = var.notification_email
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

# ===== CLOUD SQL ALERTS =====
resource "google_monitoring_alert_policy" "sql_cpu" {
  display_name = "Cloud SQL High CPU Alert"
  combiner     = "OR"
  
  conditions {
    display_name = "SQL CPU usage above 70%"
    
    condition_threshold {
      filter          = "resource.type = \"cloudsql_database\" AND metric.type = \"cloudsql.googleapis.com/database/cpu/utilization\""
      duration        = "300s"
      comparison      = "COMPARISON_GT"
      threshold_value = 0.7
      
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

resource "google_monitoring_alert_policy" "sql_connections" {
  display_name = "Cloud SQL Active Connections Alert"
  combiner     = "OR"
  
  conditions {
    display_name = "SQL active connections detected"
    
    condition_threshold {
      filter          = "resource.type = \"cloudsql_database\" AND metric.type = \"cloudsql.googleapis.com/database/postgresql/num_backends\""
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

# ===== GKE ALERTS =====
resource "google_monitoring_alert_policy" "gke_node_cpu" {
  display_name = "GKE Node High CPU Alert"
  combiner     = "OR"
  
  conditions {
    display_name = "GKE node CPU above 75%"
    
    condition_threshold {
      filter          = "resource.type = \"k8s_node\" AND metric.type = \"kubernetes.io/node/cpu/allocatable_utilization\""
      duration        = "300s"
      comparison      = "COMPARISON_GT"
      threshold_value = 0.75
      
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

resource "google_monitoring_alert_policy" "gke_pod_restart" {
  display_name = "GKE Pod Restart Alert"
  combiner     = "OR"
  
  conditions {
    display_name = "Pod restart detected"
    
    condition_threshold {
      filter          = "resource.type = \"k8s_container\" AND metric.type = \"kubernetes.io/container/restart_count\""
      duration        = "0s"
      comparison      = "COMPARISON_GT"
      threshold_value = 0
      
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_DELTA"
      }
    }
  }
  
  notification_channels = [google_monitoring_notification_channel.email.id]
  
  alert_strategy {
    auto_close = "1800s"
  }
}

# ===== PUB/SUB ALERTS =====
resource "google_monitoring_alert_policy" "pubsub_unacked_messages" {
  display_name = "Pub/Sub Unacked Messages Alert"
  combiner     = "OR"
  
  conditions {
    display_name = "Unacknowledged messages detected"
    
    condition_threshold {
      filter          = "resource.type = \"pubsub_subscription\" AND metric.type = \"pubsub.googleapis.com/subscription/num_undelivered_messages\""
      duration        = "0s"
      comparison      = "COMPARISON_GT"
      threshold_value = 5
      
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

resource "google_monitoring_alert_policy" "pubsub_publish_rate" {
  display_name = "Pub/Sub Publish Rate Alert"
  combiner     = "OR"
  
  conditions {
    display_name = "Message published to topic"
    
    condition_threshold {
      filter          = "resource.type = \"pubsub_topic\" AND metric.type = \"pubsub.googleapis.com/topic/send_request_count\""
      duration        = "0s"
      comparison      = "COMPARISON_GT"
      threshold_value = 0
      
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

# ===== LOAD BALANCER ALERTS =====
resource "google_monitoring_alert_policy" "lb_latency" {
  display_name = "Load Balancer High Latency Alert"
  combiner     = "OR"
  
  conditions {
    display_name = "HTTP latency above 500ms"
    
    condition_threshold {
      filter          = "resource.type = \"https_lb_rule\" AND metric.type = \"loadbalancing.googleapis.com/https/backend_latencies\""
      duration        = "300s"
      comparison      = "COMPARISON_GT"
      threshold_value = 500
      
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_DELTA"
        cross_series_reducer = "REDUCE_MEAN"
        group_by_fields      = ["resource.url_map_name"]
      }
    }
  }
  
  notification_channels = [google_monitoring_notification_channel.email.id]
  
  alert_strategy {
    auto_close = "1800s"
  }
}

resource "google_monitoring_alert_policy" "lb_requests" {
  display_name = "Load Balancer Request Alert"
  combiner     = "OR"
  
  conditions {
    display_name = "HTTP requests detected"
    
    condition_threshold {
      filter          = "resource.type = \"https_lb_rule\" AND metric.type = \"loadbalancing.googleapis.com/https/request_count\""
      duration        = "0s"
      comparison      = "COMPARISON_GT"
      threshold_value = 0
      
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

# ===== REDIS ALERTS =====
resource "google_monitoring_alert_policy" "redis_memory" {
  display_name = "Redis High Memory Alert"
  combiner     = "OR"
  
  conditions {
    display_name = "Redis memory usage above 80%"
    
    condition_threshold {
      filter          = "resource.type = \"redis_instance\" AND metric.type = \"redis.googleapis.com/stats/memory/usage_ratio\""
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
