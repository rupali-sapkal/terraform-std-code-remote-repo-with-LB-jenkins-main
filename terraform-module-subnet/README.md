# terraform-module-subnet

Standalone Terraform module to create an AWS Subnet.

## Usage

```hcl
module "subnet" {
  source = "git::https://github.com/<your-org>/terraform-module-subnet.git?ref=v1.0.0"

  vpc_id            = "vpc-xxxx"
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  subnet_name       = "public-subnet-1"
  is_public         = true
  tags              = { Environment = "dev", ManagedBy = "Terraform" }
}
```

## Inputs
| Name | Description | Type | Required |
|------|-------------|------|----------|
| vpc_id | VPC ID | string | yes |
| cidr_block | Subnet CIDR | string | yes |
| availability_zone | AZ for the subnet | string | yes |
| subnet_name | Name tag | string | yes |
| is_public | Enable public IP on launch | bool | no |
| tags | Common tags map | map(string) | no |

## Outputs
| Name | Description |
|------|-------------|
| subnet_id | The ID of the subnet |
| subnet_cidr_block | The CIDR block of the subnet |
