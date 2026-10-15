
# Creation of VPC
resource "aws_vpc" "custom_vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name = "custom_vpc"
    }
  
}

resource "aws_subnet" "subnet-1" {
  cidr_block = "10.0.0.0/24"
  vpc_id = aws_vpc.custom_vpc.id
  tags={
    Name="subnet-1"
  }

}

resource "aws_internet_gateway" "dev_igw" {
   vpc_id = aws_vpc.custom_vpc.id
   tags = {
        Name = "dev_igw"
    }
}
resource "aws_route_table" "dev_rt" {
    vpc_id = aws_vpc.custom_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.dev_igw.id
    }
  
}

resource "aws_route_table_association" "name" {
    subnet_id = aws_subnet.subnet-1.id
    route_table_id = aws_route_table.dev_rt.id

  
}

resource "aws_security_group" "name" {
    name        = "dev-security-group"
    description = "Allow SSH and HTTP traffic"
    vpc_id      = aws_vpc.custom_vpc.id
    
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port   = 0 #any port
        to_port     = 0 
        protocol    = "-1" #any protocol
        cidr_blocks = ["0.0.0.0/0"] #any source
    }
}
resource "aws_instance" "name" {
    ami = "ami-004d1eaf8eaa0107d"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.subnet-1.id
    vpc_security_group_ids = [aws_security_group.name.id]
    tags = {
      Name="Deepak"
    }
  
}
