# Common variables
variable "region" {
  default = "us-east-1"
}

variable "app_name" {
  default = "enrich"
}

# Web tier
variable "cidr" {
  default = "10.1.0.0/16"
}

variable "azs" {
  default = ["us-east-1a", "us-east-1b"]
}

# Application tier
variable "ec2_min_instance_size" {
  default     = 1
  description = "Minimum number of instances to launch in AutoScaling Group"
}

variable "ec2_max_instance_size" {
  default     = 1
  description = "Maximum number of instances to launch in AutoScaling Group"
}

# Database tier
variable "allocated_storage" {
    default = 10
}

variable "db_name" {
    default = "mydb"
}

variable "engine" {
    default = "postgres"
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
