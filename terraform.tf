# Enable S3 remote state.
terraform {
  backend "s3" {
    bucket = "byteme-terraform-state"
    key    = "byteme-vpc-test/terraform.tfstate"
    region = "us-east-1"
  }
}
