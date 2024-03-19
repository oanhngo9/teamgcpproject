resource "google_compute_network" "sasha_vpc" {
  name                    = "sasha-vpc"
  auto_create_subnetworks = "true"
  routing_mode            = "GLOBAL"
}