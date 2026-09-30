provider "aws" {
  region = var.aws_region
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

locals {
  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = merge(var.tags, {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  })
}

# ── ALB Security Group (standalone) ──────────────────────────────────
resource "aws_security_group" "alb_sg" {
  name        = "${local.name_prefix}-alb-sg"
  description = "Security group for ALB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-alb-sg"
  })

  depends_on = [module.vpc]
}

# ── VPC ──────────────────────────────────────────────────────────────
module "vpc" {
  source = "git::https://github.com/rupali-sapkal/terraform-std-code-remote-repo-with-LB-jenkins-main.git//terraform-module-vpc"
  cidr_block = var.vpc_cidr
  vpc_name   = "${local.name_prefix}-vpc"
  tags       = local.common_tags
}

# ── Subnets ─────────────────────────────────────────────────────────
module "subnets" {
  source = "git::https://github.com/rupali-sapkal/terraform-std-code-remote-repo-with-LB-jenkins.git//terraform-module-subnet"

  for_each              = var.subnets
  subnet_name           = "${local.name_prefix}-${each.key}"
  cidr_block            = each.value.cidr
  availability_zone     = each.value.az
  vpc_id                = module.vpc.vpc_id
  public_route_table_id = module.vpc.public_route_table_id
  is_public             = each.value.is_public
  tags                  = local.common_tags
}

# ── EC2 Security Groups ─────────────────────────────────────────────
module "ec2_security_groups" {
  source = "git::https://github.com/rupali-sapkal/terraform-std-code-remote-repo-with-LB-jenkins.git//terraform-module-security-group"

  for_each      = var.ec2_instances
  instance_name = "${local.name_prefix}-${each.key}"
  vpc_id        = module.vpc.vpc_id
  vpc_cidr      = var.vpc_cidr
  environment   = var.environment
  tags          = local.common_tags
}

# ── EC2 Instances ───────────────────────────────────────────────────
module "ec2_instances" {
  source = "git::https://github.com/rupali-sapkal/terraform-std-code-remote-repo-with-LB-jenkins.git//terraform-module-ec2"

  for_each           = var.ec2_instances
  instance_name      = "${local.name_prefix}-${each.key}"
  ami_id             = data.aws_ami.amazon_linux.id
  instance_type      = each.value.instance_type
  subnet_id          = module.subnets[each.value.subnet_key].subnet_id
  security_group_ids = [module.ec2_security_groups[each.key].security_group_id]
  environment        = var.environment
  tags               = local.common_tags
}

# ── S3 Bucket ─────────────────────────────────────────────────────
module "s3_bucket" {
  source = "git::https://github.com/rupali-sapkal/terraform-std-code-remote-repo-with-LB-jenkins.git//terraform-module-s3"

  bucket_name = "${local.name_prefix}-${var.bucket_suffix}-${random_id.bucket_suffix.hex}"
  environment = var.environment
  tags        = local.common_tags
}

# ── Application Load Balancer ─────────────────────────────────────
module "alb" {
  source = "git::https://github.com/rupali-sapkal/terraform-std-code-remote-repo-with-LB-jenkins.git//terraform-module-alb"

  name   = local.name_prefix
  vpc_id = module.vpc.vpc_id

  subnets = [
    for k, s in var.subnets :
    module.subnets[k].subnet_id if s.is_public
  ]

  security_groups = [aws_security_group.alb_sg.id]

  instance_ids = {
    for k, v in module.ec2_instances :
    k => v.instance_id
  }

  tags = local.common_tags
}
