output "private-ip" {
  description = "The private ip of the router"
  value       = "${aws_instance.router.private_ip}"
}

output "public-ip" {
  description = "The private ip of the router"
  value       = "${aws_instance.router.public_ip}"
}
