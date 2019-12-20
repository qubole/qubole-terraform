project = "xxxxxx"
region = "xxxxxx"
zone = "xxxxxx"

vpc_network = "xxxxx"
subnet = "xxxxxx"
first_run_in_vpc = true

firewall_name = "ranger"
target_tags = ["ranger"]

#mysql
db_instance_identifier = "xxxxxx"
db_version = "MYSQL_5_7"
db_instance_type = "db-n1-standard-16"
db_disk_type = ""
db_disk_size = ""
db_name = "ranger"

#database root user
db_user = "root"
db_pwd = "password"
db_ranger_user = "rangeradmin"
db_ranger_pwd = "password"

ranger_admin_name = "terraform-ranger-admin"
machine_type = "n1-standard-16"
image = "centos-7-v20190916"
instance_tags = ["http-server","ranger"]

ranger_solr_name = "terraform-ranger-solr"
solr_machine_type = "n1-standard-16"

health_check_name = "ranger-health-check"
instance_template_name = "ranger-instance-template"
managed_group_name = "ranger-managed-group"
auto_scaler_name = "ranger-autoscaler"
min_replicas = 2
max_replicas = 2

#load balancer
lb_firewall_name = "allow-ranger-lb"
lb_name = "ranger-lb"
lb_backend_name = "ranger-lb-backend"
lb_frontend_name = "ranger-lb-frontend"
target_proxy = "ranger-target-proxy"

#cookie duration in seconds
cookie_duration = 86400

#port
ranger_port = 6080
solr_port = 6083
ssh_port = 22

solr_download_url = "http://archive.apache.org/dist/lucene/solr/7.0.0/solr-7.0.0.tgz"