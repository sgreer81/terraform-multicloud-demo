# Adds two DNS records to an existing Cloudflare DNS zone enabling round-robin load balancing

data "cloudflare_zone" "demo1" {
  name = "stephengreer.me"
}

resource "random_pet" "dns_record" {
}

resource "cloudflare_record" "app_server_1" {
  zone_id = data.cloudflare_zone.demo1.zone_id
  name    = "${random_pet.dns_record.id}.projects"
  value   = aws_instance.app_server_1.public_ip
  type    = "A"
  ttl     = 60
}

resource "cloudflare_record" "app_server_2" {
  zone_id = data.cloudflare_zone.demo1.zone_id
  name    = "${random_pet.dns_record.id}.projects"
  value = azurerm_linux_virtual_machine.app_server_2.public_ip_address
  type  = "A"
  ttl   = 60
}
