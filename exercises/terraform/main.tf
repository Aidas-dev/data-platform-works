terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.32.1" # Newest at the time.
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}

resource "aws_instance" "example" {
  ami           = "ami-04ec7341c50b3f6f5" # AMI ID for Ubuntu 24 LTS in eu-north-1.
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld of Aidas"
  }
}
