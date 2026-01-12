output "notification_channel_id" {
  description = "ID of the notification channel"
  value       = google_monitoring_notification_channel.email.id
}
