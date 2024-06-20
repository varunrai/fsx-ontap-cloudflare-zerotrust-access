provider "cloudflare" {
  api_token = var.cloudflare_token
}

data "cloudflare_tunnel" "aws" {
  account_id = jsondecode(data.http.cloudflare-account-id.response_body).result[0].id
  name       = var.cloudflare_tunnel_name
}

data "http" "cloudflare-account-id" {
  url = "https://api.cloudflare.com/client/v4/accounts"

  # Optional request headers
  request_headers = {
    Content-Type  = "application/json",
    Authorization = "Bearer ${var.cloudflare_token}"
  }

  lifecycle {
    postcondition {
      condition     = contains([200], self.status_code)
      error_message = "Status code invalid"
    }
  }
}

data "http" "cloudflare-tunnel-token" {
  url = "https://api.cloudflare.com/client/v4/accounts/${jsondecode(data.http.cloudflare-account-id.response_body).result[0].id}/cfd_tunnel/${data.cloudflare_tunnel.aws.id}/token"

  # Optional request headers
  request_headers = {
    Content-Type  = "application/json",
    Authorization = "Bearer ${var.cloudflare_token}"
  }

  lifecycle {
    postcondition {
      condition     = contains([200], self.status_code)
      error_message = "Status code invalid"
    }
  }
}

data "aws_ami" "ubuntu-server-2204" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}

resource "aws_instance" "ec2-cloudflare-tunnel" {
  ami           = data.aws_ami.ubuntu-server-2204.id
  instance_type = var.ec2_instance_type
  monitoring    = false

  vpc_security_group_ids = [aws_security_group.sg-fsx.id]
  subnet_id              = aws_subnet.private_subnet[0].id
  key_name               = var.ec2_instance_keypair
  iam_instance_profile   = var.ec2_iam_role

  user_data = <<EOT
    #cloud-config
    package_update: true
    package_upgrade: true
    runcmd:
    - snap install docker
    - sleep 10
    - sudo docker run -d --name=cloudflared --restart unless-stopped cloudflare/cloudflared:latest tunnel --no-autoupdate run --token "${jsondecode(data.http.cloudflare-tunnel-token.response_body).result}"
  EOT

  root_block_device {
    volume_type = "gp2"
    volume_size = 30
    tags = {
      "creator" = "${var.creator_tag}"
    }
  }

  depends_on = [

  ]
  tags = {
    Name = "${var.creator_tag}-${var.environment}-cf-tunnel"
  }
}
