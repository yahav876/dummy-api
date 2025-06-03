terraform {
  backend "s3" {
    bucket = "vidaa-israel-terraform"
    key    = "vidaa-israel-terraform/testing/dummy-dev"
    region = "us-east-1"
  }
}
