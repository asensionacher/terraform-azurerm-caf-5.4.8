#
# Process membership for var.azuread_groups_membership
#

module "azuread_service_principals_membership" {
  source   = "./membership"
  for_each = try(var.settings.azuread_service_principals, {})

  group_object_id            = var.group_id
  azuread_service_principals = var.azuread_service_principals[try(each.value.lz_key, var.client_config.landingzone_key)]
  members                    = each.value
}

module "managed_identities_membership" {
  source   = "./membership"
  for_each = try(var.settings.managed_identities, {})

  group_object_id    = var.group_id
  managed_identities = var.managed_identities[try(each.value.lz_key, var.client_config.landingzone_key)]
  members            = each.value
}

module "mssql_servers_membership" {
  source   = "./membership"
  for_each = try(var.settings.mssql_servers, {})

  group_object_id = var.group_id
  mssql_servers   = var.mssql_servers[try(each.value.lz_key, var.client_config.landingzone_key)]
  members         = each.value
}

module "membership_object_id" {
  source = "./member"
  for_each = {
    for key, value in try(var.settings.object_ids, {}) : key => value
    if key != "logged_in"
  }

  group_object_id  = var.group_id
  member_object_id = each.value
}

module "membership_logged_in_object_id" {
  source = "./member"
  for_each = {
    for key, value in try(var.settings.object_ids, {}) : key => value
    if key == "logged_in"
  }

  group_object_id  = var.group_id
  member_object_id = var.client_config.object_id
}
