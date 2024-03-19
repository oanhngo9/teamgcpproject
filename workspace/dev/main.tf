module "vpc" {
    source = "../../Modules/VPC"
    vpc_name = var.vpc_name
}
module "MYSQL" {
    source = "../../Modules/MYSQL"
    dbinstance_name  = var.dbinstance_name
    db_version       = var.db_version
    db_region        = var.db_region
    db_username      = var.db_username
    db_host          = var.db_host
    db_password      = var.db_password
    db_name          = var.db_name
}