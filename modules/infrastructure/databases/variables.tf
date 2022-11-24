variable "tier" {
    default = "database"
}

variable "db_subnets" {
    default = []
}

variable "allocated_storage" {
    default = 10
}

variable "db_name" {
    default = "mydb"
}

variable "engine" {
    default = "postgres"
}

variable "engine_version" {
    default = "13.7"
}

variable "instance_class" {
    default = "db.t3.micro"
}

variable "username" {
    default = "foo"
}

variable "password" {
    default = "foobarbaz"
}

variable "vpc_security_group_ids" {
    default = []
}
