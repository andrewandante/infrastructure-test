output "example_instance_public_dns" {
  value = "${aws_instance.example_instance.public_dns}"
}