# Common variables
variable "region" {
  default = "us-east-1"
}

variable "app_name" {
  default = "enrich"
}

# Networking variables
variable "cidr" {
  default = "10.1.0.0/16"
}

variable "azs" {
  default = ["us-east-1a", "us-east-1b"]
}

# Webserver variables
variable "ec2_min_instance_size" {
  default     = 1
  description = "Minimum number of instances to launch in AutoScaling Group"
}

variable "ec2_max_instance_size" {
  default     = 1
  description = "Maximum number of instances to launch in AutoScaling Group"
}