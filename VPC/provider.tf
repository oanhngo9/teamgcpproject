provider "google" "dec-vpc-network" {
  project = var.project_name
  region  = var.region
}