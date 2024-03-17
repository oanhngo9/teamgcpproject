provider "google" "vpc-network" {
  project = var.project_name
  region  = var.region
}