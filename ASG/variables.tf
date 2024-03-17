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

variable "template_name" {
  type        = string
  default     = "sasha-template"
  description = "desired name for the compute instance template"
}

variable "machine_type" {
  type        = string
  default     = "e2-small"
  description = "add your machine type"
}

variable "targetpool_name" {
  type        = string
  default     = "project"
  description = "description"
}

variable "igm_name" {
  type        = string
  default     = "project"
  description = "description"
}

variable "data_base_version" {
  type        = string
  default     = "MYSQL_5_7" #MYSQL_5_6, MYSQL_5_7, MYSQL_8_0, POSTGRES_9_6,POSTGRES_10, POSTGRES_11, POSTGRES_12, POSTGRES_13, SQLSERVER_2017_STANDARD, SQLSERVER_2017_ENTERPRISE, SQLSERVER_2017_EXPRESS, SQLSERVER_2017_WEB
  description = "specifies the database version"
}