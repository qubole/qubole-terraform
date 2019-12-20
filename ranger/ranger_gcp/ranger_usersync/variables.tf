variable "project" {}

variable "region" {
  default = "us-east1"
}

variable "zone" {
  default = "us-east1-b"
}

variable "machine_type" {}
variable "image" {}

variable "instance_tags" {
	type = "list"
}

variable "vpc_network" {}
variable "subnet" {}

#usersync
variable "usersync_instance_count" {}
variable "ranger_usersync_name" {}

variable "ranger_url" {}
variable "ldap_url" {}
variable "ldap_sync_interval" {}
variable "ldap_base_dn" {}
variable "ldap_users_dn" {}
variable "ldap_bind_password" {}
variable "ldap_search_filter" {}
variable "ldap_user_name_attribute" {}

variable "ldap_group_search_enabled" {}
variable "ldap_group_name_attribute" {}
variable "ldap_group_object_class" {}
variable "ldap_group_member_attribute_name" {}