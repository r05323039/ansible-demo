locals {
  config = yamldecode(file("../settings.yml"))
}

provider "aws" {
  region = local.config.common.aws_region
}

resource "aws_key_pair" "demo_key" {
  key_name   = local.config.common.key_name
  public_key = file("~/.ssh/id_ed25519.pub")
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_instance" "web" {
  for_each      = local.config.servers

  ami           = data.aws_ami.amazon_linux.id
  instance_type = local.config.common.instance_type

  # 【修改點】：改用資源引用，確保先傳公鑰再建機器
  key_name      = aws_key_pair.demo_key.key_name

  tags = {
    Name        = each.key
    Environment = each.value.env
    Admin       = each.value.admin
  }
}