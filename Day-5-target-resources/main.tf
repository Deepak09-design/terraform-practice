
resource "aws_instance" "name" {
  ami = "ami-0ed59cbb87dfa8dba"
  instance_type = "t2.micro"
  availability_zone = "us-east-1b"

  tags = {
    Name = "deepak-1"
  }
}

resource "aws_s3_bucket" "name" {
  bucket = "bucketttt-nameee-12345"
}

# terraform plan -target=aws_s3_bucket.name
# we can apply specific resource by using targets
