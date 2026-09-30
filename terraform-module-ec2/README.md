# terraform-module-ec2

Standalone Terraform module to create an AWS EC2 instance with a Security Group.

## Features
- Creates EC2 instance + dedicated Security Group
- SSH restricted to VPC CIDR in `prod`, open in `dev`/`uat`
- Termination protection enabled automatically in `prod`
- Tags via `merge()` meta-argument pattern

## Usage

```hcl
module "ec2" {
  source = "git::https://github.com/<your-org>/terraform-module-ec2.git?ref=v1.0.0"

  instance_name = "web-server-1"
  ami_id        = "ami-0c02fb55956c7d316"
  instance_type = "t3.medium"
  subnet_id     = "subnet-xxxx"
  vpc_id        = "vpc-xxxx"
  environment   = "prod"
  tags          = { Environment = "prod", ManagedBy = "Terraform" }
}
```

## Inputs
| Name | Description | Type | Required |
|------|-------------|------|----------|
| instance_name | Name tag for the instance | string | yes |
| ami_id | AMI ID | string | yes |
| instance_type | EC2 instance type | string | no |
| subnet_id | Subnet ID | string | yes |
| vpc_id | VPC ID | string | yes |
| environment | dev / uat / prod | string | yes |
| tags | Common tags map | map(string) | no |

## Outputs
| Name | Description |
|------|-------------|
| instance_id | EC2 instance ID |
| public_ip | Public IP address |
| security_group_id | Security Group ID |
