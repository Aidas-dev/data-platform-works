# Data source for the latest Ubuntu 24.04 AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Security Group Resource
resource "aws_security_group" "aidas_sg" {
  name        = "${var.resource_prefix}sg"
  description = "Allow SSH inbound traffic"
  
  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.resource_prefix}sg"
  }
}

# EC2 Instance Resource
resource "aws_instance" "aidas_ec2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  
  # Attach the security group
  vpc_security_group_ids = [aws_security_group.aidas_sg.id]

  tags = {
    Name = "${var.resource_prefix}ec2"
  }
}
