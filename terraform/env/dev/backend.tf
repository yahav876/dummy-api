terraform {
  backend "s3" {
    bucket = "vidaa-israel-terraform"
    key    = "vidaa-israel-terraform/testing/dummy"
    region = "us-east-1"
  }
}
