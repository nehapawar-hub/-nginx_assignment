output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.nginx_server.id
}

output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.nginx_server.public_ip
}

output "website_url" {
  description = "URL of the Nginx website"
  value       = "http://${aws_instance.nginx_server.public_ip}"
}
