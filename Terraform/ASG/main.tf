module "asg" {
  source = "./modules/asg"

  name                = "web-asg"
  ami                 = "ami-0c55b159cbfafe1f0" # Adjust for your region
  instance_type       = "t2.micro"
  key_name            = "my-ec2-keypair"
  security_group_id   = aws_security_group.web_sg.id
  subnet_ids          = [module.network.public_subnet_id] # or multiple
  target_group_arns   = [module.alb.alb_target_group_arn]
  desired_capacity    = 2
  min_size            = 1
  max_size            = 3

  tags = {
    Environment = "production"
    Project     = "web-asg"
  }
}
