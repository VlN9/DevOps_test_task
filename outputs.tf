output "server_pub_ip" {
  value = aws_instance.this.public_ip
}

output "load_balanser_dns" {
  value = aws_lb.wordpress.dns_name
}
