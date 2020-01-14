output "Rundeckv1_IP" {
  value       = aws_instance.Rundeckv1.public_ip
  description = "The Public IP Address Assigned To The RunDeck v3 Instance"
}
