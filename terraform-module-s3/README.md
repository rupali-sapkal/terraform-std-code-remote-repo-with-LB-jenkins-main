# terraform-module-s3

Standalone Terraform module to create an AWS S3 bucket.

## Features
- AES256 server-side encryption always enabled
- Versioning enabled automatically in `prod`, suspended in `dev`/`uat`
- `force_destroy = true` in `dev`/`uat` for easy cleanup; disabled in `prod`
- Tags via `merge()` meta-argument pattern

## Usage

```hcl
module "s3" {
  source = "git::https://github.com/<your-org>/terraform-module-s3.git?ref=v1.0.0"

  bucket_name = "myapp-prod-assets-20240101"
  environment = "prod"
  tags        = { Environment = "prod", ManagedBy = "Terraform" }
}
```

## Inputs
| Name | Description | Type | Required |
|------|-------------|------|----------|
| bucket_name | Globally unique bucket name | string | yes |
| environment | dev / uat / prod | string | yes |
| tags | Common tags map | map(string) | no |

## Outputs
| Name | Description |
|------|-------------|
| bucket_name | The bucket name |
| bucket_arn | The bucket ARN |
| bucket_id | The bucket ID |
