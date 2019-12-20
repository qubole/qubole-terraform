project = "xxxxx"
region = "xxxxx"
zone = "xxxxx"

vpc_network = "xxxxx"
subnet = "xxxxx"

machine_type = "n1-standard-16"
image = "centos-7-v20190916"
instance_tags = ["http-server","ranger"]

#usersync
usersync_instance_count = 1
ranger_usersync_name = "ranger-usersync"

ranger_url = "xxxxx"
ldap_url = "ldap://ldap.forumsys.com:389" 
ldap_sync_interval = 5
ldap_base_dn = "dc=example,dc=com"
ldap_users_dn = "cn=read-only-admin,dc=example,dc=com"
ldap_bind_password = "password"
ldap_search_filter = ""
ldap_user_name_attribute = "cn" #cn is the default value

ldap_group_search_enabled = ""
ldap_group_name_attribute = ""
ldap_group_object_class = ""
ldap_group_member_attribute_name = ""