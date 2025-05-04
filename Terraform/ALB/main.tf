# Creating a secuirty group for ALB
module "alb_sg" {
  source      = "./modules/security_group"
  name        = "alb-sg"
  description = "Security group for ALB"
  vpc_id      = module.network.vpc_id

  ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow HTTP from anywhere"
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
    Name        = "alb-sg"
    Environment = "prod"
  }
}


# Calling ALB module
module "alb" {
  source = "./modules/alb"

  name               = "web-alb"
  vpc_id             = module.network.vpc_id
  subnet_ids         = [module.network.public_subnet_id] # or multiple subnets
  security_group_id  = aws_security_group.alb_sg.id
  target_instance_ids = [module.ec2.instance_id]
  target_port        = 80

  tags = {
    Environment = "production"
    Project     = "web-alb"
  }
}
