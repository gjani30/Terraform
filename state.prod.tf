terraform {
  backend "s3" {
    bucket = "prod-state-012345"
    key    = "state1.tfstate"
    region = "us-east-1"
  }
}