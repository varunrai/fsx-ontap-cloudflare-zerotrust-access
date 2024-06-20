
variable "creator_tag" {
  description = "Value of the creator tag"
  type        = string
}

variable "aws_location" {
  description = "Value of the location"
  type        = string
  default     = "ap-southeast-1"

  validation {
    condition     = can(regex("[a-z][a-z]-[a-z]+-[1-9]", var.aws_location))
    error_message = "Must be valid AWS Region names."
  }
}

variable "ec2_iam_role" {
  description = "Value of the EC2 IAM Role"
  type        = string
}

variable "ec2_instance_type" {
  description = "Value of the instance type"
  type        = string
}

variable "ec2_instance_keypair" {
  description = "Value of the instance key pair"
  type        = string
}

variable "fsxn_password" {
  description = "Default Password"
  type        = string
  sensitive   = true
}

variable "volume_security_style" {
  description = "Default Volume Security Style"
  type        = string
  default     = "NTFS"
}

variable "environment" {
  description = "Deployment Environment"
  default     = "Demo"
}

variable "vpc_cidr" {
  description = "CIDR block of the vpc"
  default     = "10.0.0.0/16"
}

variable "public_subnets_cidr" {
  type        = list(any)
  description = "CIDR block for Public Subnet"
  default     = ["10.0.0.0/20", "10.0.16.0/20"]
}

variable "private_subnets_cidr" {
  type        = list(any)
  description = "CIDR block for Private Subnet"
  default     = ["10.0.128.0/20", "10.0.144.0/20"]
}

variable "availability_zones" {
  type        = list(any)
  description = "AZ in which all the resources will be deployed"
  default     = ["ap-southeast-1a", "ap-southeast-1b"]
}

variable "fsx_security_group_ingress_config" {
  default = [
    {
      description      = "All Ports"
      port             = 0
      protocol         = "-1"
      cidr_blocks      = ["10.0.0.0/16"]
      ipv6_cidr_blocks = ["::/0"]
    },
    {
      description      = "SSH Ports"
      port             = 22
      protocol         = "TCP"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  ]
}

variable "fsx_security_group_egress_config" {
  default = [
    {
      description      = "All Ports"
      port             = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  ]
}


variable "cloudflare_token" {
  description = "Cloudflare API token created at https://dash.cloudflare.com/profile/api-tokens"
  type        = string
  sensitive   = true
}

variable "cloudflare_tunnel_name" {
  description = "Cloudflare tunnel name as created under zerotrust"
  type        = string
  sensitive   = true
}
