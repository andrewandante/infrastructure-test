provider "aws" {
  region = "eu-west-1"
}

resource "aws_s3_bucket" "example_bucket" {
  bucket = "andrew-test.cleandbbackups.pam.lendingworks.co.uk"
  acl    = "private"
}

resource "aws_iam_user" "example_bucket_user" {
  name          = "example_bucket_user_${var.environment}"
  force_destroy = true
}

resource "aws_iam_access_key" "example_bucket_user" {
  user = "${aws_iam_user.example_bucket_user.name}"
}

resource "aws_iam_policy" "example_bucket_policy" {
  name        = "example_bucket_policy_${var.environment}"
  description = "Allows read/write access to the example bucket."

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "s3:*",
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.example_bucket.arn}",
        "${aws_s3_bucket.example_bucket.arn}/*"
      ]
    }
  ]
}
POLICY
}

resource "aws_iam_policy_attachment" "example_bucket" {
  name       = "example_bucket_${var.environment}-attachment"
  policy_arn = "${aws_iam_policy.example_bucket_policy.arn}"

  users = [
    "${aws_iam_user.example_bucket_user.name}",
  ]
}

resource "aws_instance" "example_instance" {
  ami           = "ami-971238f1"
  instance_type = "t2.nano"
  key_name      = "${aws_key_pair.example_test.key_name}"
}

resource "aws_key_pair" "example_test" {
  key_name   = "example_test"
  public_key = "${var.public_key}"
}
