provider "aws" {
  region = "eu-west-1"
}

resource "aws_s3_bucket" "example_bucket" {
  bucket = "example-bucket-lendingworks-andrew"
  acl    = "public-read"
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
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "${aws_s3_bucket.example_bucket.arn}"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject"
            ],
            "Resource": [
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

resource "aws_security_group" "example_instance_sec_group" {
  name = "example_instance_sec_group"
}

resource "aws_security_group_rule" "example_instance_ssh" {
  from_port = 22
  protocol = "tcp"
  security_group_id = "${aws_security_group.example_instance_sec_group.id}"
  to_port = 22
  type = "ingress"
  cidr_blocks = ["${var.my_ip}/32"]
}

resource "aws_security_group_rule" "example_instance_outbound" {
  from_port = 0
  protocol = "-1"
  security_group_id = "${aws_security_group.example_instance_sec_group.id}"
  to_port = 0
  type = "egress"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_instance" "example_instance" {
  ami           = "ami-402f1a33" // debian 8.7 jessie
  instance_type = "t2.nano"
  key_name      = "andrew_test"
  security_groups = ["${aws_security_group.example_instance_sec_group.name}"]
}