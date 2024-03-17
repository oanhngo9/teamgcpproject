resource "google_compute_autoscaler" "default" {
  provider = google-beta

  name   = var.ASG_name
  zone   = var.zone
  target = google_compute_instance_group_manager.default.id

  autoscaling_policy {
    max_replicas    = var.maximum_instances
    min_replicas    = var.minimum_instances
    cooldown_period = 60
  }
}
