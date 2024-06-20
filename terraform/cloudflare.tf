provider "cloudflare" {
  api_token = var.cloudflare_token
}

data "cloudflare_tunnel" "aws" {
  account_id = var.cloudflare_account_id
  name       = var.cloudflare_tunnel_name
}

data "http" "cloudflare-tunnel-token" {
  url = "https://api.cloudflare.com/client/v4/accounts/${var.cloudflare_account_id}/cfd_tunnel/${data.cloudflare_tunnel.aws.id}/token"

  # Optional request headers
  request_headers = {
    Content-Type  = "application/json",
    Authorization = "Bearer ${var.cloudflare_token}"
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

resource "aws_instance" "ec2-cloudflare=tunnel" {
  ami           = data.aws_ami.ubuntu-server-2204.id
  instance_type = var.ec2_instance_type
  monitoring    = false

  vpc_security_group_ids = [aws_security_group.sg-default.id, aws_security_group.sg-fsx.id]
  subnet_id              = aws_subnet.public_subnet[0].id
  key_name               = var.ec2_instance_keypair
  iam_instance_profile   = var.ec2_iam_role

  user_data = <<EOT
    #cloud-config
    package_update: true
    package_upgrade: true
    runcmd:
    - apt update
    - apt -y install docker docker-compose awscli jq
    - cd /opt
    - wget https://github.com/mikefarah/yq/releases/download/v4.35.2/yq_linux_amd64.tar.gz
    - tar -xf yq_linux_amd64.tar.gz
    - cp yq_linux_amd64 /usr/bin/yq
    - chmod +x /usr/bin/yq
    - docker run -d --name=cloudflared --restart unless-stopped cloudflare/cloudflared:latest tunnel --no-autoupdate run --token "${jsondecode(data.http.cloudflare-tunnel-token.response_body).result}"
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
    Name = "${var.creator_tag}-${var.environment}-cf-tunnel}"
  }
}
