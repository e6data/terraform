# Create firewall rules for AKS egress traffic
resource "azurerm_firewall_application_rule_collection" "aks" {
  name                = "aks-fqdn"
  azure_firewall_name = azurerm_firewall.main.name
  resource_group_name = var.resource_group_name
  priority            = 100
  action              = "Allow"

  rule {
    name = "aks-service-fqdns"
    source_addresses = ["*"]  # Will be restricted by route table

    target_fqdns = [
      "*.hcp.${var.region}.azmk8s.io",
      "mcr.microsoft.com",
      "*.data.mcr.microsoft.com",
      "management.azure.com",
      "login.microsoftonline.com",
      "packages.microsoft.com",
      "acs-mirror.azureedge.net",
      "*.blob.core.windows.net",
      "*.azureedge.net",
      "*.ubuntu.com",
      "api.snapcraft.io",
      "*.docker.io",
      "production.cloudflare.docker.com",
      "*.r2.cloudflarestorage.com"
    ]

    protocol {
      port = "443"
      type = "Https"
    }
  }

  rule {
    name = "ubuntu-updates"
    source_addresses = ["*"]

    target_fqdns = [
      "security.ubuntu.com",
      "azure.archive.ubuntu.com",
      "changelogs.ubuntu.com"
    ]

    protocol {
      port = "80"
      type = "Http"
    }
  }
}

resource "azurerm_firewall_network_rule_collection" "aks" {
  name                = "aks-network"
  azure_firewall_name = azurerm_firewall.main.name
  resource_group_name = var.resource_group_name
  priority            = 200
  action              = "Allow"

  rule {
    name = "ntp"
    source_addresses = ["*"]
    destination_ports = ["123"]
    destination_addresses = ["*"]
    protocols = ["UDP"]
  }

  rule {
    name = "dns"
    source_addresses = ["*"]
    destination_ports = ["53"]
    destination_addresses = ["*"]
    protocols = ["UDP", "TCP"]
  }
}