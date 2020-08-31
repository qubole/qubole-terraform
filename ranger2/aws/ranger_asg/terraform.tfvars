access_key = "xxxx"
secret_key = "xxxx"
aws_session_token = ""

region = "us-east-1"

vpc_id = "vpc-xxxxx"
public_subnets = ["subnet-xxxxx", "subnet-xxxxx"]
private_subnets = ["subnet-xxxxx", "subnet-xxxxx"]
#your local ip
local_ips = ["99.0.0.0/32"]

#Security Group Names
rds_sg_name = "ps-tf-ranger-rds-sg"
ranger_solr_sg_name = "ps-tf-ranger-solr-ec2-sg"
ranger_alb_sg_name = "ps-tf-ranger-alb-sg"
solr_alb_sg_name = "ps-tf-solr-alb-sg"

#Security Group Description
rds_sg_desc = "Ranger RDS Secuirty Group"
ranger_solr_sg_desc = "Ranger Solr Security Group"
ranger_alb_sg_desc = "Ranger Application Load Balancer Security Group"
solr_alb_sg_desc = "Solr Application Load Balancer Security Group"

ranger_admin_ami_name = "ps-tf-ranger-admin-ami"
ranger_solr_ami_name = "ps-tf-ranger-solr-ami"

def_inst_cnt = 1
ranger_inst_cnt = 2
solr_inst_cnt = 1
ranger_admin_name = "ps-tf-ranger-admin"
ranger_solr_name = "ps-tf-ranger-solr"

ranger_alb_name_pub = "ps-tf-ranger-alb-pub"
ranger_alb_tg_name_pub = "ps-tf-ranger-alb-tg-pub"

ranger_alb_name_int = "ps-tf-ranger-alb-int"
ranger_alb_tg_name_int = "ps-tf-ranger-alb-tg-int"

solr_alb_name_pub = "ps-tf-solr-alb-pub"
solr_alb_tg_name_pub = "ps-tf-solr-alb-tg-pub"

solr_alb_name_int = "ps-tf-solr-alb-int"
solr_alb_tg_name_int = "ps-tf-solr-alb-tg-int"

solr_lt_name = "ps-tf-solr-lt"
solr_asg_name = "ps-tf-solr-asg"

ranger_lt_name = "ps-tf-ranger-lt"
ranger_asg_name = "ps-tf-ranger-asg"

#RDS properties
db_host_name = "ps-ranger-db"
db_engine = "mysql"
db_engine_version = "5.7.25"
db_name = "ranger"
db_user = "root"
db_pwd = "xxxx"
db_ranger_user = "rangeradmin"
db_ranger_pwd = "xxxx"

db_subnet_group_name = "ps-tf-db-subnet"
db_allocated_storage = 20
db_instance_type = "db.t2.micro"

### Ranger and Solr Ami needs to be created from Base AMI.
ranger_ami_instance_type  = "t2.micro"
solr_ami_instance_type  = "t2.micro"
ami = "ami-xxxxx"

#ranger admin instance
ranger_instance_type = "t2.micro"
solr_instance_type = "t2.micro"

#Private key without .pem extension
#This key will be used to ssh into Ranger and Solr Instances
key_name = "pskey"

#port
ranger_alb_port = 80
ranger_port = 6080
solr_alb_port = 80
solr_port = 6083
rds_port = 3306
ssh_port = 22

#cookie duration in seconds
cookie_duration = 3600

mysql_path = "https://dev.mysql.com/get/Downloads/Connector-J"
mysql_version = "mysql-connector-java-5.1.48"
java_version = "java-1.8.0"
solr_version = "7.7.2"
ranger_version = "2.0.0"
solr_download_url = "http://archive.apache.org/dist/lucene/solr"
ranger_download_url = "https://dist.apache.org/repos/dist/release/ranger"
ranger_admin_path = "https://paid-qubole.s3.amazonaws.com/ranger-2.0.0"
solr_mem = "512m"

#Ranger Policy 
#Default loc without s3 prefix
def_loc = "abc-data"
service_name = "hivedev"
qbol_usr_pwd = "dummy123"
