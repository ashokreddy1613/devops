# Creating Securoty group for EC2

module "ec2_sg" {
  source      = "./modules/security_group"
  name        = "web-ec2-sg"
  description = "EC2 access via ALB"
  vpc_id      = module.network.vpc_id

  ingress_rules = [
    {
      from_port       = 80
      to_port         = 80
      protocol        = "tcp"
      security_groups = [module.alb_sg.id]
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  tags = {
    Name = "web-sg"
  }
}

# Calling EC2 module
module "ec2_instance" {
  source = "./modules/ec2"

  ami                  = "ami-0c55b159cbfafe1f0" # Example for us-east-1
  instance_type        = "t2.micro"
  subnet_id            = module.network.public_subnet_id
  key_name             = "my-ec2-keypair" # Replace with your actual key
  security_group_id    = aws_security_group.ec2_sg.id
  associate_public_ip  = true
  tags = {
    Environment = "production"
    Name        = "web-server"
  }
}

output "ec2_public_ip" {
  value = module.ec2_instance.public_ip
}
