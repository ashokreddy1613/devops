module "vpc" {
  source = "./modules/vpc"

  name               = "prod-vpc"    # Name of the VPC
  cidr_block         = "10.0.0.0/16" # Creating IP Addresses 
  azs                = ["us-east-1a", "us-east-1b", "us-east-1c"] # AZs for high avilability
  public_subnets     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"] # list of Public subnets
  private_subnets    = ["10.0.201.0/24", "10.0.202.0/24", "10.0.203.0/24"] # List of Private subnets
  enable_nat_gateway = true       
  single_nat_gateway = true ##NAT gateways for Ooutbound internet access from private subnets
  tags = {
    Environment = "production"
    ManagedBy   = "Terraform"     # Just key-pair value that label your project
  }
}

## Output block, which is used to expose values from your Terraform configuration, such as after provisioning infrastructure.

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {            
  value = module.vpc.public_subnets   
}                                     

output "private_subnets" {
  value = module.vpc.private_subnets
}


