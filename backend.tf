terraform {
  backend "s3" {
    bucket = var.terraform_state_bucket_name
    key    = "terraform/production.tfstate"
    region = "ap-northeast-1"
  }
}
