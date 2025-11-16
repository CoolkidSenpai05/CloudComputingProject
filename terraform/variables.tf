variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "public_vpc_cidr" {
  description = "CIDR block for Public VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_vpc_cidr" {
  description = "CIDR block for Private VPC"
  type        = string
  default     = "10.1.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for Public Subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for Private Subnet (Backend)"
  type        = string
  default     = "10.1.1.0/24"
}

variable "private_nat_subnet_cidr" {
  description = "CIDR block for Private NAT Subnet"
  type        = string
  default     = "10.1.2.0/24"
}

variable "frontend_instance_type" {
  description = "EC2 instance type for frontend"
  type        = string
  default     = "t2.micro"
}

variable "backend_instance_type" {
  description = "EC2 instance type for backend"
  type        = string
  default     = "t2.micro"
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed for SSH access"
  type        = string
  default     = "0.0.0.0/0" # Thay đổi thành IP của bạn để bảo mật hơn
}

