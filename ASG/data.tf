data "google_compute_image" "debian-11" {
  provider = google-beta

  family  = "debian-11"
  project = "debian-cloud"
}