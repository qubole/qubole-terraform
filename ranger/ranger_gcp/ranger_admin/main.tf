#------Private Service Connection---------
resource "google_compute_global_address" "private_ip_address" {
  provider      = "google-beta"
  count         = "${var.first_run_in_vpc ? 1 : 0 }"

  name          = "google-managed-services-${var.vpc_network}"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = "projects/${var.project}/global/networks/${var.vpc_network}"
}

resource "google_service_networking_connection" "private_service_connection" {
  provider                = "google-beta"
  count                   =  "${var.first_run_in_vpc ? 1 : 0 }"

  network                 = "projects/${var.project}/global/networks/${var.vpc_network}"
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = ["google-managed-services-${var.vpc_network}"]
}

#-----Configure MYSQL instance-----
resource "google_sql_database_instance" "ranger_mysql" {
  name = "${var.db_instance_identifier}"
  database_version = "${var.db_version}"
  region = "${var.region}"
  depends_on   = ["google_service_networking_connection.private_service_connection"]

  settings {
    tier = "${var.db_instance_type}"
    ip_configuration {
      ipv4_enabled = "false"
      private_network = "projects/${var.project}/global/networks/${var.vpc_network}"
    }
    backup_configuration {
      enabled  = false
    }
  }
}

resource "google_sql_user" "users" {
  name     = "${var.db_user}"
  instance = "${google_sql_database_instance.ranger_mysql.name}"
  host     = "%"
  password = "${var.db_pwd}"
}

data "google_compute_subnetwork" "subnet" {
  name   = "${var.subnet}"
  region = "${var.region}"
}

#---------Firewall Rule---------
resource "google_compute_firewall" "ranger" {
  name    = "${var.firewall_name}"
  network = "${var.vpc_network}"
  description = "Creates Firewall rule targetting tagged instances"
  allow {
    protocol = "tcp"
    ports    = ["${var.ranger_port}","${var.ssh_port}","${var.solr_port}"]
  }
  source_ranges = ["${data.google_compute_subnetwork.subnet.ip_cidr_range}","${data.google_compute_subnetwork.subnet.gateway_address}"]
  target_tags   = ["${var.target_tags}"]
}

#-------------SOLR--------------
data "template_file" "solr_tmpl" {
  template = "${file("solr_install.sh.tpl")}"

  vars {
    solr_download_url = "${var.solr_download_url}"
  }
}

#Configure VM instance for Solr
resource "google_compute_instance" "ranger_solr" {
  name         = "${var.ranger_solr_name}"
  machine_type = "${var.solr_machine_type}"
  tags         = ["${var.instance_tags}"]
  depends_on   = ["google_compute_firewall.ranger"]
  
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

  metadata_startup_script = "${data.template_file.solr_tmpl.rendered}"
}

#-------------Ranger Admin----------
data "template_file" "ranger_tmpl" {
  template = "${file("ranger_install.sh.tpl")}"

  vars {
    db_host = "${google_sql_database_instance.ranger_mysql.private_ip_address}"
    db_name = "${var.db_name}"
    db_root_user = "${var.db_user}" 
    db_root_password = "${var.db_pwd}"
    db_ranger_user = "${var.db_ranger_user}" 
    db_ranger_passwod = "${var.db_ranger_pwd}"
    solr_url = "${google_compute_instance.ranger_solr.network_interface.0.network_ip}"
  }
}

data "google_compute_network" "ranger-network" {
  name = "${var.vpc_network}"
}

#------------------Load balancer------------------
resource "google_compute_firewall" "lb-firewall" {
  name    = "${var.lb_firewall_name}"
  network = "${var.vpc_network}"
  allow {
    protocol = "tcp"
    ports    = ["${var.ranger_port}"]
  }
  source_ranges = ["35.191.0.0/16","130.211.0.0/22"]
  target_tags   = ["${var.target_tags}"]
}

resource "google_compute_health_check" "lb-health-check" {
  name = "${var.health_check_name}"
  description = "Ranger Health check"

  timeout_sec         = 5
  check_interval_sec  = 10
  healthy_threshold   = 3
  unhealthy_threshold = 5

  tcp_health_check {
    port = "${var.ranger_port}"
  }
}

resource "google_compute_backend_service" "be-service" {
  name          = "${var.lb_backend_name}"
  health_checks = ["${google_compute_health_check.lb-health-check.self_link}"]

  port_name = "http"
  protocol = "HTTP"
  timeout_sec = 30
  session_affinity = "GENERATED_COOKIE"
  affinity_cookie_ttl_sec = "${var.cookie_duration}"
  connection_draining_timeout_sec = 300

  backend {
  group = "${google_compute_region_instance_group_manager.ranger_instance_group.instance_group}"
  balancing_mode = "RATE"
  max_rate_per_instance = 5
  capacity_scaler = 0.8
  }
}

resource "google_compute_url_map" "url_map" {
  name            = "${var.lb_name}"
  default_service = "${google_compute_backend_service.be-service.self_link}"
}

resource "google_compute_target_http_proxy" "target_proxy" {
  name        = "${var.target_proxy}"
  url_map     = "${google_compute_url_map.url_map.self_link}"
}

resource "google_compute_global_forwarding_rule" "forward_rule" {
  name       = "${var.lb_frontend_name}"
  target     = "${google_compute_target_http_proxy.target_proxy.self_link}"
  port_range = "80"
}


#-----------managed group---------
resource "google_compute_region_autoscaler" "auto_scaler_ranger" {
  provider = "google-beta"

  name   = "${var.auto_scaler_name}"
  region = "${var.region}"
  target = "${google_compute_region_instance_group_manager.ranger_instance_group.self_link}"

  autoscaling_policy {
    min_replicas    = "${var.min_replicas}"
    max_replicas    = "${var.max_replicas}"
    cooldown_period = 60

    load_balancing_utilization {
      target = 0.8
    }
  }
}

#instance template
resource "google_compute_instance_template" "ranger_instance_template" {
  name          = "${var.instance_template_name}"
  machine_type  = "${var.machine_type}"
  tags          = ["${var.instance_tags}"]

  disk {
    source_image = "${var.image}"
  }

  network_interface {
   network = "${var.vpc_network}"
   subnetwork = "${var.subnet}"

   access_config {
     #Include this section to give the VM an external ip address
   }
  }

  metadata_startup_script = "${data.template_file.ranger_tmpl.rendered}"
}

resource "google_compute_region_instance_group_manager" "ranger_instance_group" {
  name                 = "${var.managed_group_name}"
  base_instance_name   = "${var.ranger_admin_name}"
  instance_template    = "${google_compute_instance_template.ranger_instance_template.self_link}"
  region               = "${var.region}"

  named_port {
    name = "http"
    port = "${var.ranger_port}"
  }
}


#---------------output------------
output "mysql_ip" {
  value = "${google_sql_database_instance.ranger_mysql.private_ip_address}"
}

output "solr_internal_ip" {
  value = "${google_compute_instance.ranger_solr.network_interface.0.network_ip}"
}

output "load_balancer_ip" {
  value = "${google_compute_global_forwarding_rule.forward_rule.ip_address}"
}