output "notification_channel_id" {
  description = "ID of the notification channel"
  value       = google_monitoring_notification_channel.email.id
}

output "uptime_check_id" {
  description = "ID of the uptime check"
  value       = google_monitoring_uptime_check_config.http_check.id
}
