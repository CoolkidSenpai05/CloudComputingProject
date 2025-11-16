output "public_vpc_id" {
  description = "ID of the Public VPC"
  value       = aws_vpc.public_vpc.id
}

output "private_vpc_id" {
  description = "ID of the Private VPC"
  value       = aws_vpc.private_vpc.id
}

output "frontend_instance_id" {
  description = "ID of the Frontend EC2 instance"
  value       = aws_instance.frontend.id
}

output "frontend_public_ip" {
  description = "Public IP address of the Frontend EC2 instance"
  value       = aws_instance.frontend.public_ip
}

output "frontend_private_ip" {
  description = "Private IP address of the Frontend EC2 instance"
  value       = aws_instance.frontend.private_ip
}

output "backend_instance_id" {
  description = "ID of the Backend EC2 instance"
  value       = aws_instance.backend.id
}

output "backend_private_ip" {
  description = "Private IP address of the Backend EC2 instance"
  value       = aws_instance.backend.private_ip
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = aws_nat_gateway.private_nat.id
}

output "nat_gateway_public_ip" {
  description = "Public IP of the NAT Gateway"
  value       = aws_eip.nat_eip.public_ip
}

output "frontend_ssh_command" {
  description = "SSH command to connect to frontend instance"
  value       = "ssh -i your-key.pem ubuntu@${aws_instance.frontend.public_ip}"
}

output "backend_ssh_command" {
  description = "SSH command to connect to backend instance (via bastion or VPN)"
  value       = "ssh -i your-key.pem ubuntu@${aws_instance.backend.private_ip}"
}

output "vpc_peering_connection_id" {
  description = "ID of the VPC Peering Connection"
  value       = aws_vpc_peering_connection.public_to_private.id
}

