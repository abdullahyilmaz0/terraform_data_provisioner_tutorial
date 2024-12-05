terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.72.1"
    }
  }
backend "s3" {
    bucket = "tf-remote-s3-bucket-abd-test"
    key = "env/dev/tf-remote-backend.tfstate"
    region = "us-east-1"
    dynamodb_table = "tf-s3-app-lock"
    encrypt = true
  }



}
locals {
  mytag = "abd-local-name"
}

data "aws_ami" "tf_ami" {
  most_recent      = true
  owners           = ["self"]

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

variable "ec2_type" {
  default = "t2.micro"
}

resource "aws_instance" "tf-ec2" {
  ami           = data.aws_ami.tf_ami.id
  instance_type = var.ec2_type
  key_name      = "test_002"
  tags = {
    Name = "${local.mytag}-this is from my-ami"
  }
}
resource "aws_s3_bucket" "tf-test-1" {
  bucket = "abd-test-1-versioning"
}
resource "aws_s3_bucket" "tf-test-2" {
  bucket = "abd-test-2-locking-2"
}
output "public_ip" {
    value = aws_instance.tf-ec2.public_ip
  
}