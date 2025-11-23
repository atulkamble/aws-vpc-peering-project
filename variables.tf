variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "vpc_a_cidr" {
  description = "CIDR block for VPC A"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_b_cidr" {
  description = "CIDR block for VPC B"
  type        = string
  default     = "192.168.0.0/16"
}

variable "subnet_a_cidr" {
  description = "CIDR block for Subnet A"
  type        = string
  default     = "10.0.1.0/24"
}

variable "subnet_b_cidr" {
  description = "CIDR block for Subnet B"
  type        = string
  default     = "192.168.1.0/24"
}

variable "availability_zone_a" {
  description = "Availability zone for VPC A"
  type        = string
  default     = "us-east-1a"
}

variable "availability_zone_b" {
  description = "Availability zone for VPC B"
  type        = string
  default     = "us-east-1b"
}

variable "ami_id" {
  description = "AMI ID for EC2 instances (Amazon Linux 2023)"
  type        = string
  default     = "ami-0fa3fe0fa7920f68e"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "EC2 Key Pair name (must exist in your AWS account)"
  type        = string
  default     = "mykey"
}
