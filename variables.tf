variable "stage" {
  default = "production"
}
variable "instance_type" {
  default = "t2.small"
}

variable "domain_name" {}

variable "cidr-all" {
  default = [
    "0.0.0.0/0"
  ]
}

variable "db_password" {}
