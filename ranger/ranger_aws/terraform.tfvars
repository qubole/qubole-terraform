access_key = "*****"  
secret_key = "*****"
region = "us-east-1"

vpc_id = "vpc-********"
public_subnets = ["subnet-******", "subnet-*******"]
private_subnets = ["subnet-******", "subnet-******"]
#your local ip
local_ips = ["*.*.*.*/32"] 

#Security Group Names
rds_sg_name = "terraform-ranger-rds-sg"
ranger_admin_sg_name = "terraform-ranger-admin-sg"
ranger_lb_sg_name = "terraform-ranger-lbalancer-sg"

#Security Group Description
rds_sg_desc = "Ranger RDS Secuirty Group"
ranger_admin_sg_desc = "Ranger Admin Security Group"
ranger_lb_sg_desc = "Ranger Load Balancer Security Group"

ranger_admin_name = "terraform-ranger-admin"
ranger_solr_name = "terraform-ranger-solr"
ranger_lb_name = "terraform-ranger-lb" 
ranger_target_name = "terraformf-ranger-lb-tg"

#RDS properties
db_instance_identifier = "your db identifier"
db_engine = "mysql"
db_engine_version = "5.7.25"
db_name = "ranger"
#Database root user
db_user = "root"
db_pwd = "password"
db_ranger_user = "rangeradmin"
db_ranger_pwd = "password"
#should be a private subnet
db_subnet_group_name = "tf-db-subnet"
db_allocated_storage = 20
db_instance_type = "db.m3.medium"

ami = "ami-035b3c7efe6d061d5"
#ranger admin instance
ranger_instance_type = "m5.xlarge"
solr_instance_type = "m5.xlarge"
#key pair
key_name = "your keypair"
instance_count = 2

#port
ranger_port = 6080
solr_port = 6083
rds_port = 3306
ssh_port = 22

#cookie duration in seconds
cookie_duration = 86400

solr_download_url = "http://archive.apache.org/dist/lucene/solr/7.0.0/solr-7.0.0.tgz"
log_location = "your s3 log location"

