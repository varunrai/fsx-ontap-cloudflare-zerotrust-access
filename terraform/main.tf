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

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">=2.7.1"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.1.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.1.0"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.2.0"
    }
    netapp-cloudmanager = {
      source  = "NetApp/netapp-cloudmanager"
      version = "23.8.0"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 4.9.0"
    }

  }

  required_version = ">= 0.14.9"
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

  fsxn_password           = var.fsxn_password
  fsxn_deployment_type    = "SINGLE_AZ_1"
  fsxn_subnet_ids         = [aws_subnet.private_subnet[0].id, aws_subnet.private_subnet[1].id]
  fsxn_security_group_ids = [aws_security_group.sg-fsx.id]
  fsxn_volume_name_prefix = "demo"

  creator_tag = var.creator_tag
}
