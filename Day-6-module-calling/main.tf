module "dev" {
    source = "../Day-6-ec2-modules"
    ami_id  = "ami-0ed59cbb87dfa8dba"
    instance_type = "t2.micro"
    tags="dev" 
  
  
}
