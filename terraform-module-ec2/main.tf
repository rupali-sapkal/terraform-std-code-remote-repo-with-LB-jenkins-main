resource "aws_instance" "this" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids

  # Enable termination protection in prod
  disable_api_termination = var.environment == "prod" ? true : false

  tags = merge(var.tags, {
    Name = var.instance_name
  })
}
