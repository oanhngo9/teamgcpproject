resource "google_sql_database_instance" "main" {
  name                = var.dbinstance_name
  database_version    = var.db_version
  deletion_protection = false
  region              = var.db_region
  
  settings {
    # Second-generation instance tiers are based on the machine
    # type. See argument reference below.
    tier = "db-f1-micro"
  }
}

resource "google_sql_user" "users" {
  name     = var.db_username
  instance = google_sql_database_instance.main.name
  host     = var.db_host
  password = var.db_password
}

resource "google_sql_database" "database" {
  name     = var.db_name
  instance = google_sql_database_instance.main.name
}

data "google_compute_image" "debian-11" {
  provider = google-beta

  family  = "debian-11"
  project = "debian-cloud"
}
