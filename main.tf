provider "aws" { 
      region = "ap-southeast-2"
        access_key = "AKIAVKDEYDGU35A6JD5W"
      secret_key = "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"
}
resource "aws_instance" "instance1" {
    ami = "ami-0310483fb2b488153"
    instance_type = "t2.micro"
    key_name = "tf"
    subnet_id = aws_subnet.publicsubnet.id
    vpc_security_group_ids = [aws_security_group.ec2-sg.id]
    tags = {
            Name = "tf"
        }
}
resource "aws_vpc" "myvpc" {
    cidr_block = "10.0.0.0/24"

   
        tags = {
            Name = "tfvpc"
        }
}

resource "aws_subnet" "publicsubnet" {
     tags = {
            Name = "publicsubnet"
        }
     vpc_id =aws_vpc.myvpc.id
     cidr_block = "10.0.0.0/25"
}
 
resource "aws_subnet" "privatesubnet" {
     vpc_id =aws_vpc.myvpc.id
     cidr_block = "10.0.0.128/25"
}

resource "aws_internet_gateway" "igw" {
     vpc_id =aws_vpc.myvpc.id
}
  
resource "aws_route_table" "publicrt" {
     vpc_id =aws_vpc.myvpc.id
     route{
     cidr_block = "0.0.0.0/0"
     gateway_id = aws_internet_gateway.igw.id
}
}

resource "aws_route_table_association" "publicrtassociation" {
     subnet_id = aws_subnet.publicsubnet.id
     route_table_id = aws_route_table.publicrt.id
}
resource "aws_security_group" "ec2-sg" {
  tags = {
            Name = "sg1"
        }
  vpc_id = aws_vpc.myvpc.id

  ingress {
     from_port =22
         to_port = 22
         protocol = "tcp"
         cidr_blocks = ["0.0.0.0/0"]
  }
  
ingress {
     from_port =80
         to_port = 80
         protocol = "tcp"
         cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
     from_port = 0
         to_port = 0
         protocol = "-1"
         cidr_blocks = ["0.0.0.0/0"]
  }
}
