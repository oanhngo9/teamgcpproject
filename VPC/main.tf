resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = "true"
  routing_mode            = "GLOBAL"
}

resource "google_compute_firewall" "firewall" {
  name    = "firewall-rule-name"
  project = "puofwswvtu"
  network = var.vpc_name  

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
}