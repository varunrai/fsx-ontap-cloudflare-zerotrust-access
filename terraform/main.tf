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

provider "cloudflare" {
  api_token = var.cloudflare_token
}

data "cloudflare_tunnel" "aws" {
  account_id = var.cloudflare_account_id
  name       = "AWS Work VPC - Singapore"
}

data "http" "cloudflare-tunnel-token" {
  url = "https://api.cloudflare.com/client/v4/accounts/${var.cloudflare_account_id}/cfd_tunnel/${data.cloudflare_tunnel.aws.id}/token"

  # Optional request headers
  request_headers = {
    Content-Type  = "application/json",
    Authorization = "Bearer ${var.cloudflare_token}"
  }
}
