terraform {
  backend "s3" {
    bucket = "hirokihello-deploy"
    key    = "terraform/production.tfstate"
    region = "ap-northeast-1"
  }
}
