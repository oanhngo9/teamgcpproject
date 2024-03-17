variable "vpc_name" {
  description = "The name of the VPC network"
  type        = string
  default     = "dec-team-vpc"  # replace with your VPC name
}

variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "puofwswvtu"  # replace with your project name
}

variable "region" {
  description = "The region of the project"
  type        = string
  default     = "us-central1"  # replace with your region
}