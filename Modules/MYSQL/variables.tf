variable "dbinstance_name" {
  type        = string
  default = "sasha-instance"
  description = "Name of the database instance"
}
variable "db_version" {
  type        = string
  default = "MYSQL_5_7"
  description = "Version of the database"
}

variable "db_region" {
  type        = string
  default = "us-central1"
  description = "Region where the resources will be created"
}
variable "db_username" {
  type        = string
  default = "sasha-username"
  description = "Username for the database"
}

variable "db_host" {
  type        = string
  default = "sasha-host"
  description = "Host for the database"
}

variable "db_password" {
  type        = string
  default = "12345678"
  description = "Password for the database"
}

variable "db_name" {
  type        = string
  default = "sasha-db"
  description = "Name of the database"
}