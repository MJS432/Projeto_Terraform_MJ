#Network VPC 
resource "google_compute_network" "this" {
  name                    = "custom-vpc"
  auto_create_subnetworks = false
}

#subnet
resource "google_compute_subnetwork" "this" {
  name          = "subnetwork"
  network       = google_compute_network.this.id
  ip_cidr_range = "10.0.1.0/24"
  region        = "europe-west1"

  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = "10.1.0.0/16"
  }

  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = "10.2.0.0/16"
  }
}

#Permitir HTTP
resource "google_compute_firewall" "default-allow-http" {
  name      = "default-allow-http"
  network   = google_compute_network.this.name
  priority  = 1000
  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["https-server"]
}

#Permitir Tráfego Interno
resource "google_compute_firewall" "default-allow-internal" {
  name      = "default-allow-internal"
  network   = google_compute_network.this.name
  priority  = 1000
  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "icmp"
  }
  source_ranges = ["10.0.1.0/24"]
}


#Permitir SSH
resource "google_compute_firewall" "default-allow-ssh" {
  name      = "default-allow-ssh"
  network   = google_compute_network.this.name
  priority  = 2000
  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

#Por default: Negar tudo
resource "google_compute_firewall" "deny-all" {
  name      = "deny-all"
  network   = google_compute_network.this.name
  priority  = 65534
  direction = "INGRESS"

  deny {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
}

#--------------------------------------------------------------------------
#VM1
#Reservar IP Público
resource "google_compute_address" "vm1-ip-address" {
  name = "vm1-ipv4-address"
  region = "europe-west1"
}

#Ping e SSH
resource "google_compute_firewall" "default-allow-ssh-icmp" {
  name      = "default-allow-ssh-icmp"
  network   = google_compute_network.this.name
  priority  = 2000
  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["https-server"]
}

#--------------------------------------------------------------------------
#VM2
#NAT Gateway
resource "google_compute_router" "nat-router" {
  name    = "nat-router"
  region  = "europe-west1"
  network = google_compute_network.this.name
}

resource "google_compute_router_nat" "nat-config" {
  name                               = "nat-config"
  router                             = google_compute_router.nat-router.name
  region                             = "europe-west1"
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
#--------------------------------------------------------------------------

#MANAGED INSTANCE GROUP 

#Cloud Armor
resource "google_compute_security_policy" "multi_policy" {
  name = "multi-policy"

  rule {
    action   = "deny(403)"
    priority = 1000
    match {
      expr {
        expression = "!(origin.region_code == 'PT' || origin.region_code == 'ES')"
      }
    }
    description = "Bloquear tráfego fora de PT e ES"
  }

# FIRST RULE
  rule {
    action   = "throttle"
    priority = 1200
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }

    rate_limit_options {
      rate_limit_threshold {
        count        = 20
        interval_sec = 60
      }

      conform_action = "allow"
      exceed_action  = "deny(429)"
      enforce_on_key = "IP"
    }

    description = "Limitar 20 req/min por IP"
  }

#SECOND  RULE
  rule {
    action   = "allow"
    priority = 2147483647
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
  }
}

#Reservar IP
resource "google_compute_global_address" "load_balancer_ip" {
  name = "load-balancer-ip"
}


#Health Check
resource "google_compute_health_check" "default" {
  name               = "http-health-check"
  check_interval_sec = 5
  timeout_sec        = 5
  healthy_threshold  = 2
  unhealthy_threshold = 2

  http_health_check {
    port = 80
    request_path = "/"
  }
}

#Certificado SSL
resource "google_compute_managed_ssl_certificate" "default" {
  name = "managed-cert"

  managed {
    domains = ["deusnosajude.pt"]
  }
}

#Backend Service
resource "google_compute_backend_service" "default" {
  name                  = "backend-service"
  protocol              = "HTTP"
  port_name             = "http"
  timeout_sec           = 10
  load_balancing_scheme = "EXTERNAL"

  backend {
    group = var.mig_instance_group
  }

  health_checks  = [google_compute_health_check.default.id]
  security_policy = google_compute_security_policy.multi_policy.id
}

# URL Map
resource "google_compute_url_map" "default" {
  name            = "url-map"
  default_service = google_compute_backend_service.default.id
}

# HTTP
resource "google_compute_target_http_proxy" "default" {
  name    = "http-proxy"
  url_map = google_compute_url_map.default.id
}

# HTTPS
resource "google_compute_target_https_proxy" "default" {
  name    = "https-proxy"
  url_map = google_compute_url_map.default.id
  ssl_certificates = [google_compute_managed_ssl_certificate.default.id]
}

# Forwarding Rule
resource "google_compute_global_forwarding_rule" "default" {
  name       = "http-forwarding-rule"
  ip_address = google_compute_global_address.load_balancer_ip.address
  port_range = "80"
  target     = google_compute_target_http_proxy.default.id
}

resource "google_compute_global_forwarding_rule" "https" {
  name       = "https-forwarding-rule"
  ip_address = google_compute_global_address.load_balancer_ip.address
  port_range = "443"
  target     = google_compute_target_https_proxy.default.id
}