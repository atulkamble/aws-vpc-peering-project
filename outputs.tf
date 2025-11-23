output "vpc_a_id" {
  description = "ID of VPC A"
  value       = aws_vpc.vpc_a.id
}

output "vpc_b_id" {
  description = "ID of VPC B"
  value       = aws_vpc.vpc_b.id
}

output "ec2_a_public_ip" {
  description = "Public IP of EC2 instance in VPC A"
  value       = aws_instance.ec2_a.public_ip
}

output "ec2_a_private_ip" {
  description = "Private IP of EC2 instance in VPC A"
  value       = aws_instance.ec2_a.private_ip
}

output "ec2_b_public_ip" {
  description = "Public IP of EC2 instance in VPC B"
  value       = aws_instance.ec2_b.public_ip
}

output "ec2_b_private_ip" {
  description = "Private IP of EC2 instance in VPC B"
  value       = aws_instance.ec2_b.private_ip
}

output "peering_id" {
  description = "VPC Peering Connection ID"
  value       = aws_vpc_peering_connection.peer.id
}

output "peering_status" {
  description = "VPC Peering Connection Status"
  value       = aws_vpc_peering_connection.peer.accept_status
}

output "test_commands" {
  description = "Commands to test the VPC peering connection"
  value       = <<-EOT
    
    To test the VPC Peering:
    
    1. SSH into EC2-A:
       ssh -i ${var.key_name}.pem ec2-user@${aws_instance.ec2_a.public_ip}
    
    2. Ping EC2-B from EC2-A:
       ping ${aws_instance.ec2_b.private_ip}
    
    3. SSH from EC2-A to EC2-B (using private IP):
       ssh ec2-user@${aws_instance.ec2_b.private_ip}
    
    Alternative - SSH into EC2-B:
       ssh -i ${var.key_name}.pem ec2-user@${aws_instance.ec2_b.public_ip}
    
    Then ping EC2-A:
       ping ${aws_instance.ec2_a.private_ip}
  EOT
}
