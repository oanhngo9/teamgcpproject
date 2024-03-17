variable "dec_vpc_name" {
  type        = string
  default     = ""
  description = "desired name of the vpc being created"
}

variable "project_name" {
  type        = string
  default     = "YourProjectID" 
  description = "enter your project name"
}

variable "region" {
  description = "provide a region"
  type        = string
  default     = ""
}