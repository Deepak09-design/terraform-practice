resource "aws_instance" "name" {
    ami = "ami-004d1eaf8eaa0107d"
    instance_type = "t2.micro"
    availability_zone = "us-east-1b"
    tags = {
        Name = "Deepak"
    }

  
}
