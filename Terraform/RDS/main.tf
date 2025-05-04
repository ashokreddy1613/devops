# Create a security group for rds
module "rds_sg" {
  source      = "./modules/security_group"
  name        = "rds-sg"
  description = "Security group for RDS instance"
  vpc_id      = module.network.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [aws_security_group.web_sg.id] # or ASG instances' SG
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-sg"
  }
}

# Call RDS module 

module "rds" {
  source              = "./modules/rds"
  name                = "app-db"
  engine              = "postgres"
  instance_class      = "db.t3.micro"
  allocated_storage   = 20
  username            = "dbadmin"
  password            = "strongpassword123"
  db_name             = "myappdb"
  subnet_ids          = [module.network.private_subnet_id] # or a list
  security_group_id   = aws_security_group.rds_sg.id
  multi_az            = false
  skip_final_snapshot = true

  tags = {
    Environment = "production"
    Project     = "rds"
  }
}
