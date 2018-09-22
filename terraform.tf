terraform {
  backend "s3" {
    bucket = "byteme-iterraform-state"
    key    = "byteme-vpc-test/terraform.tfstate"
    region = "us-east-1"
  }
}
