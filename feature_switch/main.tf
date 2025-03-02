provider "aws" {
  region = "us-east-1" 
}

variable "environment" {
  type = string  
}

resource "aws_instance" "ec2" {
  count = var.environment == "dev" ? 1 : 0
  ami = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  tags = {
    Name = "myec2"
  }
}