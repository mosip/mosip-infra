resource "aws_security_group" "console" {
  name        = "console"
  description = "Rules for console"
  vpc_id      = aws_vpc.sandbox.id

  /* Open up all ports but only within VPC */
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = [
      var.vpc_cidr
    ]
  } 

  /* Open UDP 53 for DNS */
  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp" 
    cidr_blocks = [
      var.vpc_cidr
    ]
  } 

  ingress {
    from_port   = 22 
    to_port     = 22 
    protocol    = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {
    from_port   = 80 
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {
    from_port   = 443
    to_port     = 443 
    protocol    = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  /* For postgres */
  ingress {
    from_port   = 30090
    to_port     = 30090
    protocol    = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  /* For activemq */
  ingress {
    from_port   = 30616
    to_port     = 30616
    protocol    = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  /* Allow ping */
  ingress {
    from_port = 8
    to_port = 0
    protocol = "icmp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "console"
  }
}

resource "aws_security_group" "kube" {
  name        = "kube"
  description = "Rules for all kube machines"
  vpc_id      = aws_vpc.sandbox.id

  /* Open up all ports but only within VPC */
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = [
      var.vpc_cidr
    ]
  } 

  /* Allow ssh from anywhere. This is needed initially when keys
   are getting exchanged. It may restricted to VPC later */
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  } 

  /* Allow ping */
  ingress {
    from_port = 8
    to_port = 0
    protocol = "icmp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "kube"
  }
}
