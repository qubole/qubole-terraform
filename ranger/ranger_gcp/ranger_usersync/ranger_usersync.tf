#-------------Ranger Usersync----------
data "template_file" "ranger_usersync_tmpl" {
  template = "${file("ranger_usersync_install.sh.tpl")}"

  vars {
    ranger_url = "${var.ranger_url}"
    ldap_url = "${var.ldap_url}"
    ldap_sync_interval = "${var.ldap_sync_interval}"
    ldap_base_dn = "${var.ldap_base_dn}"
    ldap_users_dn = "${var.ldap_users_dn}"
    ldap_bind_password = "${var.ldap_bind_password}"
    ldap_search_filter = "${var.ldap_search_filter}"
    ldap_user_name_attribute = "${var.ldap_user_name_attribute}"

    ldap_group_search_enabled = "${var.ldap_group_search_enabled}"
    ldap_group_name_attribute = "${var.ldap_group_name_attribute}"
    ldap_group_object_class = "${var.ldap_group_object_class}"
    ldap_group_member_attribute_name = "${var.ldap_group_member_attribute_name}"
  }
}

#Configure VM instance for Ranger Usersync
resource "google_compute_instance" "ranger_usersync" {
  count        = "${var.usersync_instance_count}"
  name         = "${var.ranger_usersync_name}-${count.index+1}"
  machine_type = "${var.machine_type}"
  tags         = ["${var.instance_tags}"]
  
  boot_disk {
    initialize_params {
      image = "${var.image}"
    }
  }

  network_interface {
   network = "${var.vpc_network}"
   subnetwork = "${var.subnet}"

   access_config {
     #Include this section to give the VM an external ip address
   }
  }

  metadata_startup_script = "${data.template_file.ranger_usersync_tmpl.rendered}"
}
