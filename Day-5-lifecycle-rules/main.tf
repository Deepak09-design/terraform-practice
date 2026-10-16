resource "aws_instance" "name" {
    ami = "ami-0ed59cbb87dfa8dba"
    instance_type = "t2.micro"
    availability_zone = "us-east-1b"
    tags = {
        Name = "deepak"
    }

  
#   lifecycle {
#     ignore_changes = [tags]
#   }
lifecycle {
  create_before_destroy = true
}

# lifecycle {
#    prevent_destroy = true
# }
}