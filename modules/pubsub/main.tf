# First Pub/Sub 
resource "google_pubsub_topic" "events_topic" {
  name                       = "events-topic"
  message_retention_duration = "86600s" 
}

resource "google_pubsub_topic" "events_topic_dead_letter" {
  name = "events-topic-dead-letter"
}

resource "google_pubsub_subscription" "events_subscription" {
  name  = "events-subscription"
  topic = google_pubsub_topic.events_topic.id

  expiration_policy {
    ttl = "" 
  }

  ack_deadline_seconds         = 30
  enable_exactly_once_delivery = true

  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.events_topic_dead_letter.id
    max_delivery_attempts = 5
  }

  retry_policy {
    minimum_backoff = "5s"
    maximum_backoff = "10s"
  }
}

# Second Pub/Sub 
resource "google_pubsub_topic" "data_topic" {
  name                       = "data-topic"
  message_retention_duration = "86600s" 
}

resource "google_pubsub_topic" "data_topic_dead_letter" {
  name = "data-topic-dead-letter"
}

resource "google_pubsub_subscription" "data_subscription" {
  name  = "data-subscription"
  topic = google_pubsub_topic.data_topic.id

  expiration_policy {
    ttl = "" # Never
  }

  ack_deadline_seconds         = 30
  enable_exactly_once_delivery = true

  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.data_topic_dead_letter.id
    max_delivery_attempts = 5
  }

  retry_policy {
    minimum_backoff = "5s"
    maximum_backoff = "10s"
  }
}