resource "google_compute_network" "VPC" {
  name                    = testproject.project_id
  auto_create_subnetworks = "true"
  routing_mode            = "GLOBAL"
}