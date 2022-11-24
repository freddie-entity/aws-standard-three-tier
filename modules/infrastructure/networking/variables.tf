variable "cidr" {}

variable "azs" {}

variable "app_name" {
  default = ""
}

variable "bastion_ssh_ip" {
  default = "0.0.0.0/0"
}