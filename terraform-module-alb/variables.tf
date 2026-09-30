variable "name" {}
variable "vpc_id" {}
variable "subnets" {
  type = list(string)
}
variable "security_groups" {
  type    = list(string)
  default = []
}
variable "instance_ids" {
  type = map(string)
}
variable "tags" {
  type = map(string)
}
