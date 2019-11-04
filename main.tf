


resource "aws_autoscaling_group" "Rtr-asg" {
  name = "Rtr-asg"
  launch_configuration = "${aws_launch_configuration.Rtr-lc.id}"
  availability_zones = ["us-east-1"]

  min_size = 1
  max_size = 2

  load_balancers = ["${aws_elb.Rtr-elb.name}"]
  health_check_type = "ELB"

  tag {
    key = "Name"
    value = "Rtr-ASG"
    propagate_at_launch = true
  }
}

# Create launch configuration
resource "aws_launch_configuration" "Rtr-lc" {
  name = "Rtr-lc"
  image_id = "ami-024c80694b5b3e51a"
  instance_type = "t2.micro"
  key_name = "${var.key_name}"
  security_groups = ["${aws_security_group.Rtr-lc-sg.id}"]

  iam_instance_profile = "${var.iam_instance_profile}"

  

}

# Create the ELB
resource "aws_elb" "Rtr-elb" {
  name = "Rtr-elb"
  security_groups = ["${aws_security_group.Rtr-elb-sg.id}"]
  availability_zones = ["us-east-1a", "us-east-1b",]

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    #target = "TCP:${var.server_port}"
    target = "HTTP:${var.server_port}/index.html"
  }

  # This adds a listener for incoming HTTP requests.
  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "${var.server_port}"
    instance_protocol = "http"
  }
}

# Create security group that's applied the launch configuration
resource "aws_security_group" "Rtr-lc-sg" {
  name = "Rtr-lc-sg"

  # Inbound HTTP from anywhere
  ingress {
    from_port = "${var.server_port}"
    to_port = "${var.server_port}"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = "${var.ssh_port}"
    to_port = "${var.ssh_port}"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Create security group that's applied to the ELB
resource "aws_security_group" "Rtr-elb-sg" {
  name = "Rtr-elb-sg"

  # Allow all outbound
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Inbound HTTP from anywhere
  ingress {
    from_port = "${var.server_port}"
    to_port = "${var.server_port}"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}