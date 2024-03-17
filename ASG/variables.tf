variable "dec_vpc_name" {
  type        = string
  default     = ""
  description = "desired name of the vpc being created"
}

variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "region" {
  description = "The region of the project"
  type        = string
}