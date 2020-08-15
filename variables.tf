variable "stage" {
  default = "production"
}
variable "instance_type" {
  default = "t2.small"
}

variable "terraform_state_bucket_name" {
  default = "hirokihello-ecs-fargate-infra-deploy-sample"
}

variable "domain_name" {}

variable "cidr-all" {
  default = [
    "0.0.0.0/0"
  ]
}

variable "db_password" {
  default = "password"
}
