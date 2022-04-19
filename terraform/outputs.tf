output "azure_vm_public_ip" {
  value = azurerm_public_ip.demo1.ip_address
}

output "aws_ec2_public_ip" {
  value = aws_instance.app_server_1.public_ip
}

output "dns" {
  value = cloudflare_record.app_server_2.hostname
}
