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

variable "ASG_name" {
  type        = string
  default     = "dec_asg"
  description = "desired name for the autoscaling"
}

variable "zone" {
  type        = string
  default     = "us-central1-a"
  description = "zone where to deploy resource"
}

variable "minimum_instances" {
  type        = number
  default     = "1"
  description = "minimum desired instances running"
}

variable "maximum_instances" {
  type        = number
  default     = "5"
  description = "maximum desired instances"
}