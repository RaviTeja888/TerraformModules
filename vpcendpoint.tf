resource "aws_vpc_endpoint" "s3" {
  vpc_id       = "vpc-0deee0d9643504f6e"
  service_name = "com.amazonaws.us-west-1.s3"
}