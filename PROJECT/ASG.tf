# Networking Resources
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

resource "google_compute_firewall" "allow_health_checks" {
  name    = "allow-health-checks"
  network = google_compute_network.sasha_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = [
    "130.211.0.0/22",
    "35.191.0.0/16",
  ]
}

# Health Check Resources
resource "google_compute_http_health_check" "default" {
  name               = "http-health-check"
  request_path       = "/"
  check_interval_sec = 1
  timeout_sec        = 1
}

# Load Balancer Resources
resource "google_compute_backend_service" "lb_backend_service" {
  name                    = "lb-backend-service"
  health_checks           = [google_compute_http_health_check.default.self_link]
  protocol                = "HTTP"
  port_name               = "http"
  timeout_sec             = 10
}

resource "google_compute_url_map" "lb_url_map" {
  name            = "lb-url-map"
  default_service = google_compute_backend_service.lb_backend_service.self_link
}

resource "google_compute_target_http_proxy" "lb_target_http_proxy" {
  name        = "lb-target-http-proxy"
  url_map     = google_compute_url_map.lb_url_map.self_link
}

resource "google_compute_global_forwarding_rule" "lb_global_forwarding_rule" {
  name                  = "lb-global-forwarding-rule"
  target                = google_compute_target_http_proxy.lb_target_http_proxy.self_link
  port_range            = "80"
}

# Autoscaling Resources
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

# Google Cloud SQL Resources
resource "google_sql_database_instance" "default" {
  name             = "mysql-instance"
  database_version = "MYSQL_5_7"
  region           = var.region
  settings {
    tier = "db-f1-micro"
  }
}

resource "google_sql_database" "default" {
  name     = "example-db"
  instance = google_sql_database_instance.default.name
}

# Shell script for setting up WordPress with MySQL
resource "null_resource" "wordpress_setup" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = <<-EOT
      # Define database connection information as environment variables
      export DB_NAME="sasha-instance"
      export DB_USER="sasha-username"
      export DB_PASSWORD="12345678"
      export DB_HOST="${google_sql_database_instance.default.connection_name}"

      # Set non-interactive frontend for apt-get
      export DEBIAN_FRONTEND=noninteractive

      # Update package repositories and install required packages
      sudo apt-get update
      sudo apt-get install -y apache2 unzip wget

      # Start Apache web server
      sudo service apache2 start

      # Set ServerName directive
      echo "ServerName localhost" | sudo tee /etc/apache2/conf-available/servername.conf
      sudo a2enconf servername

      # Restart Apache to apply changes
      sudo service apache2 restart

      # Download and install PHP and related extensions
      sudo apt-get install -y php7.4 php7.4-mysql php-pear

      # Download and install the protobuf compiler and PHP protobuf extension
      sudo apt-get install -y protobuf-compiler php-protobuf

      # Restart Apache to load new PHP extensions
      sudo service apache2 restart

      # Verify PHP version
      php --version

      # Download and extract WordPress
      sudo rm -rf /var/www/html/*
      cd /tmp
      wget https://wordpress.org/latest.tar.gz
      tar -zxvf latest.tar.gz
      sudo mv wordpress/* /var/www/html/

      # Change ownership of WordPress files to Apache user
      sudo chown -R www-data:www-data /var/www/html

      # Cleanup unnecessary packages
      sudo apt autoremove -y

      # Remove wp-config.php file if it exists
      sudo rm -f /var/www/html/wp-config.php

      # Create a new wp-config.php file
      sudo tee /var/www/html/wp-config.php > /dev/null << EOF
      <?php
      define('DB_NAME', '$DB_NAME');
      define('DB_USER', '$DB_USER');
      define('DB_PASSWORD', '$DB_PASSWORD');
      define('DB_HOST', '$DB_HOST');
      define('DB_CHARSET', 'utf8mb4');
      define('DB_COLLATE', '');
      EOF
    EOT
  }
}
