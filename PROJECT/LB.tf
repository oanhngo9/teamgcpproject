resource "google_compute_backend_service" "lb_backend_service" {
  name          = "lb-backend-service"
  health_checks = [google_compute_http_health_check.default.self_link]
  protocol      = "HTTP"
  port_name     = "http"
  timeout_sec   = 10
  backend {
    group = google_compute_instance_group_manager.default.instance_group
  }
}
resource "google_compute_url_map" "lb_url_map" {
  name            = "lb-url-map"
  default_service = google_compute_backend_service.lb_backend_service.self_link
}
resource "google_compute_target_http_proxy" "lb_target_http_proxy" {
  name    = "lb-target-http-proxy"
  url_map = google_compute_url_map.lb_url_map.self_link
}
resource "google_compute_global_forwarding_rule" "lb_global_forwarding_rule" {
  name       = "lb-global-forwarding-rule"
  target     = google_compute_target_http_proxy.lb_target_http_proxy.self_link
  port_range = "80"
}
resource "google_compute_http_health_check" "default" {
  name         = "authentication-health-check"
  request_path = "/health_check"

  timeout_sec        = 1
  check_interval_sec = 1
}