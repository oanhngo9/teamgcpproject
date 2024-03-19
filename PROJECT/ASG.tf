resource "google_compute_network" "sasha_vpc" {
  name                    = "sasha-vpc"
  auto_create_subnetworks = true
  routing_mode            = "GLOBAL"
}

resource "google_compute_firewall" "default" {
  name    = "sasha-firewall"
  network = google_compute_network.sasha_vpc.self_link

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "1000-2000"]
  }

  source_tags = ["web"]
}

# Create Load Balancer
resource "google_compute_forwarding_rule" "lb" {
  name     = "lbname"
  region   = var.region

  target = google_compute_target_pool.default.self_link
  port_range = "80"
}

resource "google_compute_health_check" "http-health-check" {
  name = "http-health-check"

  timeout_sec        = 1
  check_interval_sec = 1

  http_health_check {
    port = 80
  }
}

resource "google_compute_health_check" "tcp-health-check" {
  name = "tcp-health-check"

  timeout_sec        = 1
  check_interval_sec = 1

  tcp_health_check {
    port = "80"
  }
}

resource "google_compute_firewall" "allow_health_checks" {
  name    = "allow-health-checks"
  network = google_compute_network.sasha_vpc.name  # Adjust the network name as per your configuration

  allow {
    protocol = "tcp"
    ports    = ["80"]  # Adjust the ports as needed, typically the health check port
  }

  source_ranges = [
    "130.211.0.0/22",   # Google Cloud Load Balancer health check IP ranges
    "35.191.0.0/16",
  ]
}


resource "google_compute_autoscaler" "default" {
  name   = var.asg_name
  zone   = var.zone
  target = google_compute_instance_group_manager.default.self_link

  autoscaling_policy {
    max_replicas    = var.maximum_instances
    min_replicas    = var.minimum_instances
    cooldown_period = 60
  }
}

resource "google_compute_instance_template" "asg" {
  name           = var.template_name
  machine_type   = var.machine_type
  can_ip_forward = false

  disk {
    source_image = "debian-cloud/debian-11"
  }

  network_interface {
    network = google_compute_network.sasha_vpc.self_link
  }

  metadata = {
    foo = "bar"
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}

resource "google_compute_target_pool" "default" {
  provider = google
  region   = var.region

  name = var.targetpool_name
}

resource "google_compute_instance_group_manager" "default" {
  provider = google

  name = var.igm_name
  zone = var.zone

  version {
    instance_template = google_compute_instance_template.asg.self_link
    name              = var.data_base_version
  }

  target_pools       = [google_compute_target_pool.default.self_link]
  base_instance_name = "autoscaler-sample"
}
