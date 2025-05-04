resource "aws_instance" "this" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  associate_public_ip_address = var.associate_public_ip
  key_name               = var.key_name
  vpc_security_group_ids = [var.security_group_id]

  tags = merge(var.tags, { Name = "ec2-instance" })
}
