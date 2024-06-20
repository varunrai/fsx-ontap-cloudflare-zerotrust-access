# Default Security Group of VPC
resource "aws_security_group" "default" {
  name        = "${var.environment}-default-sg"
  description = "Default SG to alllow traffic from the VPC"
  vpc_id      = aws_vpc.vpc.id
  depends_on = [
    aws_vpc.vpc
  ]

  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = "true"
  }

  tags = {
    Environment = "${var.environment}"
  }
}

resource "aws_security_group" "sg-fsx" {
  name        = "AllowEC2ToFSX"
  description = "Allow outbound access from EC2 to FSXN"
  vpc_id      = aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = var.fsx_security_group_ingress_config
    content {
      description      = ingress.value["description"]
      from_port        = ingress.value["port"]
      to_port          = ingress.value["port"]
      protocol         = ingress.value["protocol"]
      cidr_blocks      = ingress.value["cidr_blocks"]
      ipv6_cidr_blocks = ingress.value["ipv6_cidr_blocks"]
    }
  }


  dynamic "egress" {
    for_each = var.fsx_security_group_egress_config
    content {
      description      = egress.value["description"]
      from_port        = egress.value["port"]
      to_port          = egress.value["port"]
      protocol         = egress.value["protocol"]
      cidr_blocks      = egress.value["cidr_blocks"]
      ipv6_cidr_blocks = egress.value["ipv6_cidr_blocks"]
    }
  }

  tags = {
    Name = "${var.creator_tag}-AllowEC2ToFSX"
  }
}

resource "aws_security_group_rule" "VPCToFSXRule" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.sg-fsx.id
  security_group_id        = aws_vpc.vpc.default_security_group_id
}

resource "aws_security_group" "sg-AllowRemoteToEC2" {
  name        = "AllowRemoteToEC2"
  description = "Allow access to RDP/SSH to EC2"
  vpc_id      = aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = var.ec2_security_group_config
    content {
      description      = ingress.value["description"]
      from_port        = ingress.value["port"]
      to_port          = ingress.value["port"]
      protocol         = ingress.value["protocol"]
      cidr_blocks      = ingress.value["cidr_blocks"]
      ipv6_cidr_blocks = ingress.value["ipv6_cidr_blocks"]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name    = "${var.creator_tag}-AllowRemoteToEC2"
    creator = var.creator_tag
  }
}
