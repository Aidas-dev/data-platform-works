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
  ami           = "ami-0bbad81bd05fad66f" # AMI ID for Ubuntu 25 in eu-north-1.
  instance_type = "t3.micro"

  tags = {
    Name = "HelloWorld of Aidas"
  }
}
