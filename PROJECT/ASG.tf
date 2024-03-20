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

resource "google_compute_instance_template" "asg" {
  name           = var.template_name
  machine_type   = var.machine_type
  can_ip_forward = false
  disk {
    source_image = "debian-cloud/debian-11"
  }
  network_interface {
    network = google_compute_network.sasha_vpc.self_link
    access_config {
      // Ephemeral IP
    }
  }
  metadata = {
    foo = "bar"
  }
   metadata_startup_script =  ("/Users/testuser/Desktop/apache2.sh")
    # Your startup script
  
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
  base_instance_name = "autoscaler-sample"
  named_port {
    name = "http"
    port = 80
  }
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
resource "google_sql_database_instance" "default" {
  name             = "database-instance"
  database_version = "MYSQL_5_7"
  region           = "us-central1"
  settings {
    tier = "db-f1-micro"
    backup_configuration {
      binary_log_enabled = true
      enabled            = true
    }
  }
}
resource "google_sql_database" "default" {
  name     = "example-db"
  instance = google_sql_database_instance.default.name
}