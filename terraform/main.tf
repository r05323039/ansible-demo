provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "demo_key" {
  key_name   = "demo-key"
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
  for_each      = var.server_configs

  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.demo_key.key_name

  tags = {
    Name        = each.key
    Environment = each.value.env
    Admin       = each.value.admin
  }
}