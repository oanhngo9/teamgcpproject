resource "google_compute_network" "dec_vpc_name" {
  name                    = var.dec_vpc_name
  auto_create_subnetworks = "true"
  routing_mode            = "GLOBAL"
}