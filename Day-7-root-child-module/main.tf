
module "network" {
  source = "./modules/network"

  vpc_cidr    = "10.0.0.0/16"
  subnet_cidr = "10.0.0.0/24"
}

module "compute" {
  source = "./modules/compute"

  ami           = "ami-0567589d25e06853e"
  instance_type = "t2.micro"
  subnet_id     = module.network.subnet_id
}
