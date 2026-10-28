# Fetch an existing subnet using its ID
data "aws_subnet" "name" {
  id = "subnet-0e251193b9c65e658"
}

# Fetch the latest Amazon Linux 2 AMI
data "aws_ami" "amzlinux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# Create an EC2 instance using the data sources
resource "aws_instance" "name" {
  ami           = data.aws_ami.amzlinux.id
  instance_type = "t2.micro"
  subnet_id     = data.aws_subnet.name.id

  tags = {
    Name        = "dev-datasource-ec2"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

# Display the subnet ID
output "subnet_id" {
  value = data.aws_subnet.name.id
}

# Display the AMI ID
output "ami_id" {
  value = data.aws_ami.amzlinux.id
}

# Display the EC2 public IP
output "ec2_public_ip" {
  value = aws_instance.name.public_ip
}