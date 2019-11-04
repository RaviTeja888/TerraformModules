resource "aws_s3_bucket" "rtrb"{
  bucket = "rtrb-tf-test-bucket"
  acl    = "private"

  tags = {
    Name        = "rtrb"
    Environment = "Dev"
  }
}
resource "aws_s3_bucket_policy" "rtrb"{
  bucket = "${aws_s3_bucket.rtrb.id}"

  policy = <<POLICY
{
   "Version": "2019-11-03",
   "Id": "MyBPolicy",
   "Statement": [
     {
       "Sid": "Access-to-specific-VPCE-only",
       "Principal": "*",
       "Action": "s3:*",
       "Effect": "Deny",
       "Resource": ["arn:aws:s3:::rtrb",
                    "arn:aws:s3:::rtrb/*"],
       "Condition": {
         "StringNotEquals": {
           "aws:sourceVpce": "vpce-0ebc41b968a28b878"
         }
       }
     }
   ]
   POLICY
}
resource "aws_s3_bucket" "s3" {
  bucket = "rtrb"
  acl = "private"
  force_destroy = true
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
 }
}