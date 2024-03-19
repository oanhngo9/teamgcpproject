# Create Load Balancer
resource "google_compute_forwarding_rule" "lbname" {
  name     = "lbname"
  region   = var.region

  target = var.targetpool_name
  port_range = "80"
}