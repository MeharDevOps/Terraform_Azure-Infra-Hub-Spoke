resource "azurerm_resource_group" "rg" {
  for_each = var.resource_group
  name     = each.value.rg_name
  location = each.value.location

  # Optional attributes
  managed_by = lookup(each.value, "managed_by", null)

  #  Tags (optional key-value pairs)
  tags = lookup(each.value, "tags", {
    environment = "dev"
    owner       = "mehar"
  })
}

