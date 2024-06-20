terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.38.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.1.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 4.9.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.4.3"
    }
  }

  required_version = ">= 1.5.7"
}

provider "aws" {
  region = var.aws_location
  default_tags {
    tags = {
      "creator" = var.creator_tag
    }
  }
}

module "fsxontap" {
  source = "./modules/fsxn"

  fsxn_password              = var.fsxn_password
  fsxn_ssd_in_gb             = 1024
  fsxn_throughput_capacity   = 128
  fsxn_deployment_type       = "SINGLE_AZ_1"
  fsxn_subnet_ids            = [aws_subnet.private_subnet[0].id, aws_subnet.private_subnet[1].id]
  fsxn_security_group_ids    = [aws_security_group.sg-fsx.id]
  fsxn_volume_name_prefix    = "demo"
  fsxn_volume_security_style = "UNIX"

  creator_tag = var.creator_tag
}
