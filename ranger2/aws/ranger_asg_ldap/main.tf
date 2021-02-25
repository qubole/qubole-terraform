#Declare the data source
data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_subnet_ids" "private" {
  vpc_id = var.vpc_id
}

data "aws_subnet_ids" "public" {
  vpc_id = var.vpc_id
}

data "aws_vpc" "selected" {
  id = var.vpc_id
}

#------MySQL Ranger RDS---------
#Create DB subnet groups
resource "aws_db_subnet_group" "rds_db_subnet_grp" {
  name       = "${var.prefix_name}${var.db_subnet_group_name}"
  subnet_ids = var.private_subnets

  tags = {
    Name = "${var.prefix_name}${var.db_subnet_group_name}"
  }
}
#Configure security group for RDS
resource "aws_security_group" "rds_sg" {
  name        = "${var.prefix_name}${var.rds_sg_name}"
  description = var.rds_sg_desc
  vpc_id      = var.vpc_id

  #Allow mysql traffic
  ingress {
    from_port       = var.rds_port
    to_port         = var.rds_port
    protocol        = "tcp"
    cidr_blocks = [data.aws_vpc.selected.cidr_block]
  }
  
  #Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.prefix_name}${var.rds_sg_name}"
  }
}

#Configure MYSQL RDS instance
resource "aws_db_instance" "ranger_mysql" {
  identifier                = "${var.prefix_name}${var.db_host_name}"
  engine                    = var.db_engine
  engine_version            = var.db_engine_version
  instance_class            = var.db_instance_type
  allocated_storage         = var.db_allocated_storage
  name                      = var.db_name
  username                  = var.db_user
  password                  = var.db_pwd
  port                      = var.rds_port
  db_subnet_group_name      = aws_db_subnet_group.rds_db_subnet_grp.name
  vpc_security_group_ids    = [aws_security_group.rds_sg.id]
  skip_final_snapshot       = true
  final_snapshot_identifier = "Ignore"
  publicly_accessible       = false
}
provider "mysql" {
  endpoint = aws_db_instance.ranger_mysql.endpoint
  username = aws_db_instance.ranger_mysql.username
  password = aws_db_instance.ranger_mysql.password
}

output "ranger_rds_endpoint"{  
  value = aws_db_instance.ranger_mysql.endpoint
}

output "ranger_rds_address"{  
  value = aws_db_instance.ranger_mysql.address
}

#------Ranger and Solr Instance Security Groups-----
#Configure Security Group for EC2
resource "aws_security_group" "ec2_sg" {
  name        = "${var.prefix_name}${var.ranger_solr_sg_name}"
  description = var.ranger_solr_sg_desc
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.prefix_name}${var.ranger_solr_sg_name}"
  }

  #Allow ranger admin
  ingress {
    from_port       = var.ranger_port
    to_port         = var.ranger_port
    protocol        = "tcp"
    cidr_blocks = [data.aws_vpc.selected.cidr_block]
  }
  #allow solr
  ingress {
    from_port   = var.solr_port
    to_port     = var.solr_port
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.selected.cidr_block]
  }
  # SSH 
  ingress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = [var.ssh_access, data.aws_vpc.selected.cidr_block]
  }
  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

##### Solr Setup
data "template_file" "solr_base_ami_tmpl" {
  template = file("${path.module}/solr_ami.tpl")

  vars = {
    JAVA_VER    = var.java_version
    SOLR_VER    = var.solr_version
    RANGER_VER  = var.ranger_version
    SOLR_URL    = var.solr_download_url
    RANGER_URL  = var.ranger_download_url
    SOLR_MEM    = var.solr_mem
    SOLR_AUDIT_RET_DAYS = var.solr_audit_ret_days
  }
}

#Configure EC2 instance for solr AMI
resource "aws_instance" "tf_solr_base_inst" {
  ami = var.baseami
  instance_type = var.solr_ami_inst_type
  associate_public_ip_address = "true"
  key_name = var.key_name
  subnet_id = var.public_subnets[0]
  security_groups = [aws_security_group.ec2_sg.id]
  tags = { 
    Name = "${var.prefix_name}${var.solr_base_inst_name}"
  }
  user_data = data.template_file.solr_base_ami_tmpl.rendered

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ec2-user"
      host        = aws_instance.tf_solr_base_inst.public_dns
      private_key = file("${var.key_path}/${var.key_name}.pem")
    }
    script = "setup_file_chk.sh"
  }
}
output "solr_base_inst_id" {
  value = aws_instance.tf_solr_base_inst.id
}

#Create SOLR AMI 
resource "aws_ami_from_instance" "tf_solr_ami" {
  name               = "${var.prefix_name}${var.solr_ami_name}"
  source_instance_id = aws_instance.tf_solr_base_inst.id
  tags = { 
    Name = "${var.prefix_name}${var.solr_ami_name}"
  }
}
output "solr_ami_id" {
  value = aws_ami_from_instance.tf_solr_ami.id
}

###---- Solr Load Balancer -----
### Configure Security Group for Solr Load Balancer
resource "aws_security_group" "solr_alb_sg" {
  name        = "${var.prefix_name}${var.solr_alb_sg_name}"
  description = var.solr_alb_sg_desc
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.prefix_name}${var.solr_alb_sg_name}"
  }

  #Allow Ranger traffic
  ingress {
    from_port       = var.solr_alb_port
    to_port         = var.solr_alb_port
    protocol        = "tcp"
    cidr_blocks     = [data.aws_vpc.selected.cidr_block]
  }

  ingress {
    from_port       = var.solr_alb_port
    to_port         = var.solr_alb_port
    protocol        = "tcp"
    cidr_blocks     = var.access_from_ips
  }

  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Configure target group for Solr Load Balancer Public
resource "aws_lb_target_group" "solr_alb_tg_pub" {
  name                 = "${var.prefix_name}${var.solr_alb_tg_name_pub}"
  port                 = var.solr_port
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  deregistration_delay = 10
  stickiness {
    type = "lb_cookie"
    enabled = true
    cookie_duration = var.cookie_duration
  }

  health_check {    
    healthy_threshold   = 3    
    unhealthy_threshold = 5 
    timeout             = 10
    interval            = 20
    path                = "/"    
    port                = var.solr_port
    matcher             = "200,302"
  }

  tags = {
    Name = "${var.prefix_name}${var.solr_alb_tg_name_pub}"
  }
}

#Configure Solr Load Balancer Public
resource "aws_lb" "solr_alb_pub" {
  name                       = "${var.prefix_name}${var.solr_alb_name_pub}"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.solr_alb_sg.id]
  subnets                    = var.public_subnets
  enable_deletion_protection = false

  tags = {
    Name = "${var.prefix_name}${var.solr_alb_name_pub}"
  }
}

#Configure listener for Solr load balancer Public
resource "aws_lb_listener" "solr_alb_listener_pub" {
  load_balancer_arn = aws_lb.solr_alb_pub.arn
  port              = var.solr_alb_port 
  protocol          = "HTTP"
  
  default_action {    
    target_group_arn = aws_lb_target_group.solr_alb_tg_pub.arn
    type             = "forward"  
  }
}

output "solr_alb_name_pub"{
  value = aws_lb.solr_alb_pub.dns_name
}

#Configure target group for Solr Load Balancer Internal
resource "aws_lb_target_group" "solr_alb_tg_int" {
  name                 = "${var.prefix_name}${var.solr_alb_tg_name_int}"
  port                 = var.solr_port
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  deregistration_delay = 10
  stickiness {
    type = "lb_cookie"
    enabled = true
    cookie_duration = var.cookie_duration
  }

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 5
    timeout             = 10
    interval            = 20
    path                = "/"
    port                = var.solr_port
    matcher             = "200,302"
  }

  tags = {
    Name = "${var.prefix_name}${var.solr_alb_tg_name_int}"
  }
}

#Configure Solr Load Balancer Internal
resource "aws_lb" "solr_alb_int" {
  name                       = "${var.prefix_name}${var.solr_alb_name_int}"
  internal                   = true
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.solr_alb_sg.id]
  subnets                    = var.private_subnets
  enable_deletion_protection = false

  tags = {
    Name = "${var.prefix_name}${var.solr_alb_name_int}"
  }
}

#Configure listener for Solr load balancer Internal
resource "aws_lb_listener" "solr_alb_listener_int" {
  load_balancer_arn = aws_lb.solr_alb_int.arn
  port              = var.solr_alb_port
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.solr_alb_tg_int.arn
    type             = "forward"
  }
}

output "solr_alb_name_int"{
  value = aws_lb.solr_alb_int.dns_name
}

#Create Solr Launch Template
resource "aws_launch_template" "tf_solr_lt" {
  name          = "${var.prefix_name}${var.solr_lt_name}"
  image_id      = aws_ami_from_instance.tf_solr_ami.id
  instance_type = var.solr_inst_type
  key_name      = var.key_name
  block_device_mappings {
    device_name = var.solr_dev_name
    ebs {
      volume_size = var.solr_volume_size
    }
  }
  network_interfaces {
    associate_public_ip_address = false
    delete_on_termination = true
    device_index = 0
    subnet_id = var.private_subnets[1]
    security_groups = [aws_security_group.ec2_sg.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.prefix_name}${var.solr_inst_name}"
    }
  }
  depends_on = [aws_ami_from_instance.tf_solr_ami]

  user_data = filebase64("${path.module}/solr_start.sh")
}

resource "aws_autoscaling_group" "tf_solr_asg" {
    name                      = "${var.prefix_name}${var.solr_asg_name}"
    min_size                  = var.solr_inst_cnt
    max_size                  = var.solr_inst_cnt
    desired_capacity          = var.solr_inst_cnt
    vpc_zone_identifier       = var.private_subnets
    health_check_grace_period = 10
    wait_for_capacity_timeout = "10m"
    health_check_type         = "EC2"
    default_cooldown          = 10
    target_group_arns         = [aws_lb_target_group.solr_alb_tg_pub.arn,aws_lb_target_group.solr_alb_tg_int.arn]
    depends_on = [aws_launch_template.tf_solr_lt]
    launch_template {
      id      = aws_launch_template.tf_solr_lt.id
      version = "$Latest"
    }
    tag {
      key = "Name"
      value = "${var.prefix_name}${var.solr_inst_name}"
      propagate_at_launch = true
    }
}

### Ranger Setup
###---- Ranger Load Balancer -----
### Configure Security Group for Load Balancer
data "template_file" "ranger_base_ami_tmpl" {
  template = file("${path.module}/ranger_ami.tpl")

  vars = {
    JAVA_VER        = var.java_version
    MYSQL_VER       = var.mysql_version
    MYSQL_PATH      = var.mysql_path
    RANGER_VER      = var.ranger_version
    RANGER_URL      = var.ranger_download_url
    RANGER_DNS      = aws_lb.ranger_alb_int.dns_name
    DB_HOST         = aws_db_instance.ranger_mysql.address
    DB_PORT         = var.rds_port
    SOLR_DNS        = aws_lb.solr_alb_int.dns_name
    SOLR_ALB_PORT   = var.solr_alb_port
    DB_ROOT_USR     = var.db_user
    DB_RANGER_USR   = var.db_ranger_user 
    DB_RANGER_PWD   = var.db_ranger_pwd
    DB_ROOT_PWD     = var.db_pwd
    RANGER_ADM_PATH = var.ranger_admin_path
    
    AUTH_METHOD                 = var.auth_method
    LDAP_USER_DN_PATTERN        = var.ldap_user_dn_pattern
    LDAP_GROUP_SEARCH_FILTER    = var.ldap_group_search_filter
    LDAP_USER_SEARCH_FILTER     = var.ldap_user_search_filter
    LDAP_REFERRAL               = var.ldap_referral

    LDAP_SYNC_INTERVAL          = var.sync_interval
    LDAP_URL                    = var.sync_ldap_url
    SSL_ENABLED                 = var.ssl_enabled
    LDAP_BIND_DN                = var.sync_ldap_bind_dn
    LDAP_BIND_PASSWORD          = var.sync_ldap_bind_password
    LDAP_SEARCH_BASE            = var.sync_ldap_search_base
    LDAP_USER_SEARCH_BASE       = var.sync_ldap_user_search_base
    LDAP_USER_NAME_ATTRIBUTE    = var.sync_ldap_user_name_attribute
    GROUP_SEARCH_ENABLED        = var.sync_group_search_enabled
    GROUP_USER_MAP_SYNC_ENABLED = var.sync_group_user_map_sync_enabled
    GROUP_SEARCH_BASE           = var.sync_group_search_base
    GROUP_OBJECT_CLASS          = var.sync_group_object_class
    GROUP_NAME_ATTRIBUTE        = var.sync_group_name_attribute
    GROUP_MEMBER_ATTRIBUTE_NAME = var.sync_group_member_attribute_name
  }
  depends_on = [aws_lb.solr_alb_int, aws_lb.ranger_alb_int]
}

resource "aws_security_group" "ranger_alb_sg" {
  name        = "${var.prefix_name}${var.ranger_alb_sg_name}"
  description = var.ranger_alb_sg_desc
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.prefix_name}${var.ranger_alb_sg_name}"
  }

  #Allow Ranger traffic
  ingress {
    from_port       = var.ranger_alb_port
    to_port         = var.ranger_alb_port
    protocol        = "tcp"
    cidr_blocks     = [data.aws_vpc.selected.cidr_block]
  }

  ingress {
    from_port       = var.ranger_alb_port
    to_port         = var.ranger_alb_port
    protocol        = "tcp"
    cidr_blocks     = var.access_from_ips
  }

  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Configure target group for Load Balancer Public
resource "aws_lb_target_group" "ranger_alb_tg_pub" {
  name                 = "${var.prefix_name}${var.ranger_alb_tg_name_pub}"
  port                 = var.ranger_port
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  deregistration_delay = 20
  stickiness {
    type = "lb_cookie"
    enabled = true
    cookie_duration = var.cookie_duration
  }

  health_check {    
    healthy_threshold   = 3    
    unhealthy_threshold = 5 
    timeout             = 10
    interval            = 20
    path                = "/login.jsp"    
    port                = var.ranger_port
  }

  tags = {
    Name = "${var.prefix_name}${var.ranger_alb_tg_name_pub}"
  }
}

#Configure Load Balancer Public
resource "aws_lb" "ranger_alb_pub" {
  name                       = "${var.prefix_name}${var.ranger_alb_name_pub}"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.ranger_alb_sg.id]
  subnets                    = var.public_subnets
  enable_deletion_protection = false

  tags = {
    Name = "${var.prefix_name}${var.ranger_alb_name_pub}"
  }
}

#Configure listener for load balancer Public
resource "aws_lb_listener" "ranger_alb_listener_pub" {
  load_balancer_arn = aws_lb.ranger_alb_pub.arn
  port              = var.ranger_alb_port 
  protocol          = "HTTP"
  
  default_action {    
    target_group_arn = aws_lb_target_group.ranger_alb_tg_pub.arn
    type             = "forward"  
  }
}

output "ranger_alb_name_pub"{
  value = aws_lb.ranger_alb_pub.dns_name
}

#Configure target group for Load Balancer Internal
resource "aws_lb_target_group" "ranger_alb_tg_int" {
  name                 = "${var.prefix_name}${var.ranger_alb_tg_name_int}"
  port                 = var.ranger_port
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  deregistration_delay = 20
  stickiness {
    type = "lb_cookie"
    enabled = true
    cookie_duration = var.cookie_duration
  }

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 5
    timeout             = 10
    interval            = 20
    path                = "/login.jsp"
    port                = var.ranger_port
  }

  tags = {
    Name = "${var.prefix_name}${var.ranger_alb_tg_name_int}"
  }
}

#Configure Load Balancer Internal
resource "aws_lb" "ranger_alb_int" {
  name                       = "${var.prefix_name}${var.ranger_alb_name_int}"
  internal                   = true
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.ranger_alb_sg.id]
  subnets                    = var.private_subnets
  enable_deletion_protection = false

  tags = {
    Name = "${var.prefix_name}${var.ranger_alb_name_int}"
  }
}

#Configure listener for load balancer Internal
resource "aws_lb_listener" "ranger_alb_listener_int" {
  load_balancer_arn = aws_lb.ranger_alb_int.arn
  port              = var.ranger_alb_port
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.ranger_alb_tg_int.arn
    type             = "forward"
  }
}

output "ranger_alb_name_int"{
  value = aws_lb.ranger_alb_int.dns_name
}

#Configure EC2 instance for Ranger AMI
resource "aws_instance" "tf_ranger_base_inst" {
  ami                         = var.baseami
  instance_type               = var.ranger_ami_inst_type
  associate_public_ip_address = "true"
  key_name                    = var.key_name
  subnet_id                   = var.public_subnets[0]
  security_groups             = [aws_security_group.ec2_sg.id]
  depends_on                  = [aws_db_instance.ranger_mysql]
  tags = { 
    Name = "${var.prefix_name}${var.ranger_base_inst_name}"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ec2-user"
      host        = aws_instance.tf_ranger_base_inst.public_dns
      private_key = file("${var.key_path}/${var.key_name}.pem")
    }
    script = "setup_file_chk.sh"
  }

  user_data = data.template_file.ranger_base_ami_tmpl.rendered
}

output "ranger_base_inst_id" {
  value = aws_instance.tf_ranger_base_inst.id
}

#Create Ranger AMI 
resource "aws_ami_from_instance" "tf_ranger_ami" {
  name               = "${var.prefix_name}${var.ranger_ami_name}"
  source_instance_id = aws_instance.tf_ranger_base_inst.id
  tags = { 
    Name = "${var.prefix_name}${var.ranger_ami_name}"
  }
}

output "ranger_ami_id" {
  value = aws_ami_from_instance.tf_ranger_ami.id
}

#Create Ranger Launch Template
resource "aws_launch_template" "tf_ranger_lt" {
  name          = "${var.prefix_name}${var.ranger_lt_name}"
  image_id      = aws_ami_from_instance.tf_ranger_ami.id
  instance_type = var.ranger_inst_type
  key_name      =  var.key_name
  depends_on    = [aws_ami_from_instance.tf_ranger_ami]
  block_device_mappings {
    device_name = var.ranger_dev_name
    ebs {
      volume_size = var.ranger_volume_size
    }
  }
  network_interfaces {
    associate_public_ip_address = false
    delete_on_termination = true
    device_index = 0
    subnet_id = var.private_subnets[1]
    security_groups = [aws_security_group.ec2_sg.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.prefix_name}${var.ranger_inst_name}"
    }
  }

  user_data = filebase64("${path.module}/ranger_start.sh")
}

resource "aws_autoscaling_group" "tf_ranger_asg" {
    name                      = "${var.prefix_name}${var.ranger_asg_name}"
    min_size                  = var.def_inst_cnt
    max_size                  = var.def_inst_cnt
    desired_capacity          = var.def_inst_cnt
    vpc_zone_identifier       = var.private_subnets
    health_check_grace_period = 10 
    health_check_type         = "EC2"
    default_cooldown          = 10
    wait_for_capacity_timeout = "10m"
    target_group_arns         = [aws_lb_target_group.ranger_alb_tg_pub.arn, aws_lb_target_group.ranger_alb_tg_int.arn]
    depends_on = [aws_launch_template.tf_ranger_lt]
    launch_template {
      id      = aws_launch_template.tf_ranger_lt.id
      version = "$Latest"
    }
    tag {
      key = "Name"
      value = "${var.prefix_name}${var.ranger_inst_name}"
      propagate_at_launch = true
    }
}

resource "null_resource" "create-default-ranger-policy" {
    depends_on = [aws_autoscaling_group.tf_ranger_asg]
    provisioner "local-exec" {
      command = "sleep 180;python ranger_policy.py ${aws_lb.ranger_alb_pub.dns_name} ${var.def_loc} ${var.service_name} ${var.ranger_alb_port} ${var.qbol_usr_pwd}"
    }
}

##command = <<EOT
            #aws ec2 terminate-instances --profile ${var.profile_name} --instance-ids ${aws_instance.tf_solr_base_inst.id} ${aws_instance.tf_ranger_base_inst.id}
            #aws autoscaling update-auto-scaling-group --profile ${var.profile_name} --auto-scaling-group-name ${aws_autoscaling_group.tf_ranger_asg.name} --min-size ${var.ranger_inst_cnt} --max-size ${var.ranger_inst_cnt}
##    	EOT
resource "null_resource" "update-ranger-asg" {
    depends_on = [aws_autoscaling_group.tf_ranger_asg]
    provisioner "local-exec" {
      command = <<EOT
            export AWS_ACCESS_KEY_ID=${var.access_key}
			export AWS_SECRET_ACCESS_KEY=${var.secret_key}
			export AWS_DEFAULT_REGION=${var.region}

			if [ "${var.aws_session_token}" != "" ]; then
				export AWS_SESSION_TOKEN=${var.aws_session_token}
			fi
			aws ec2 terminate-instances --instance-ids ${aws_instance.tf_solr_base_inst.id} ${aws_instance.tf_ranger_base_inst.id}
            aws autoscaling update-auto-scaling-group --auto-scaling-group-name ${aws_autoscaling_group.tf_ranger_asg.name} --min-size ${var.ranger_inst_cnt} --max-size ${var.ranger_inst_cnt}
      EOT

    }
    triggers = {
      always_run = timestamp()
    }
}
