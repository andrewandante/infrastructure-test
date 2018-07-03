provider "aws" {
  region = "eu-west-1"
}

resource "aws_s3_bucket" "example_bucket" {
  bucket = "andrew-test.cleandbbackups.pam.lendingworks.co.uk"
  acl    = "private"
}