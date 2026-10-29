# Example 1: Variable validation for AWS region

variable "aws_region" {
  description = "The region in which to create the infrastructure"
  type        = string
  nullable    = false
  default     = "us-east-1"

  validation {
    condition = contains(
      ["us-east-1", "ap-south-1"],
      var.aws_region
    )

    error_message = "The variable 'aws_region' must be us-east-1 or ap-south-1."
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "dev" {
  bucket = "statefile-configuressjs"

  tags = {
    Name        = "statefile-configuressjs"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}


# Example 2: Conditional expression to create an S3 bucket

variable "create_bucket" {
  description = "Whether to create an additional S3 bucket"
  type        = bool
  default     = true
}

resource "aws_s3_bucket" "example" {
  count  = var.create_bucket ? 1 : 0
  bucket = "deepak-conditional-practice-2026"

  tags = {
    Name        = "deepak-conditional-practice-2026"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}


# Example 3: Conditional expression to determine EC2 instance count

# variable "environment" {
#   type    = string
#   default = "test"
# }

# resource "aws_instance" "example" {
#   count         = var.environment == "prod" ? 3 : 1
#   ami           = "ami-REPLACE_WITH_VALID_AMI_ID"
#   instance_type = "t2.micro"

#   tags = {
#     Name = "example-${count.index}"
#   }
# }