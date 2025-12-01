output "strapi_public_ip" {
  description = "Public IP address of Strapi server"
  value       = aws_eip.strapi_eip.public_ip
}

output "strapi_admin_url" {
  description = "Strapi Admin Panel URL"
  value       = "http://${aws_eip.strapi_eip.public_ip}:1337/admin"
}

output "strapi_api_url" {
  description = "Strapi API endpoint"
  value       = "http://${aws_eip.strapi_eip.public_ip}:1337/api"
}

output "ssh_command" {
  description = "SSH command to connect to the server"
  value       = "ssh -i strapi-key-new.pem ubuntu@${aws_eip.strapi_eip.public_ip}"
}

output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.strapi_server.id
}