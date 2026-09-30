output "subnet_id" {
  description = "The ID of the subnet"
  value       = aws_subnet.this.id
}

output "subnet_cidr_block" {
  description = "The CIDR block of the subnet"
  value       = aws_subnet.this.cidr_block
}
