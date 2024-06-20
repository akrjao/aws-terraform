resource "aws_vpc" "aws_vpc" {
  cidr_block = "10.0.0.0/27"
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true
}