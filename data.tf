// This is to figure account_id used in some IAM rules
data "aws_caller_identity" "current" {}

// Use current region of the credentials in some parts of the script,
// could be as well hardcoded.
data "aws_region" "current" {}

// SSM is picking alias for key to use for encryption in SSM
# data "aws_kms_alias" "ssm" {
#   name = "${var.kms_alias_name}"
# }

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
}
