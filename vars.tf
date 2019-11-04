
variable region {
  default = "us-east-1"
}
variable key_name {
    type      = "string"
    default   = "null"
}

variable iam_instance_profile {
    type      = "string"
  default     = ""
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default = 80
}

variable "ssh_port" {
  default = 22
}

variable "cn" {
  description = "Number of EC2 instances"
  default = 1
}