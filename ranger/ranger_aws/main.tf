
#------MySQL Ranger RDS---------

#Create DB subnet groups
resource "aws_db_subnet_group" "rds_db_subnet_grp" {
  name       = "${var.db_subnet_group_name}"
  subnet_ids = "${var.private_subnets}"

  tags = {
    Name = "${var.db_subnet_group_name}"
  }
}
#Configure security group for RDS
resource "aws_security_group" "rds_sg" {
  name        = "${var.rds_sg_name}"
  description = "${var.rds_sg_desc}"
  vpc_id      = "${var.vpc_id}"

  #Allow mysql traffic
  ingress {
    from_port       = "${var.rds_port}"
    to_port         = "${var.rds_port}"
    protocol        = "tcp"
    cidr_blocks = ["${data.aws_vpc.selected.cidr_block}"]
  }
  
  #Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "${var.rds_sg_name}"
  }
}

#Configure MYSQL RDS instance
resource "aws_db_instance" "ranger_mysql" {
  identifier                = "${var.db_instance_identifier}"
  engine                    = "${var.db_engine}"
  engine_version            = "${var.db_engine_version}"
  instance_class            = "${var.db_instance_type}"
  allocated_storage         = "${var.db_allocated_storage}"
  name                      = "${var.db_name}"
  username                  = "${var.db_user}"
  password                  = "${var.db_pwd}"
  db_subnet_group_name      = "${var.db_subnet_group_name}"
  vpc_security_group_ids    = ["${aws_security_group.rds_sg.id}"]
  skip_final_snapshot       = true
  final_snapshot_identifier = "Ignore"
  publicly_accessible       = false
}
provider "mysql" {
  endpoint = "${aws_db_instance.ranger_mysql.endpoint}"
  username = "${aws_db_instance.ranger_mysql.username}"
  password = "${aws_db_instance.ranger_mysql.password}"
}


#------EC2 Ranger Admin-----

#Configure Security Group for EC2
resource "aws_security_group" "ec2_sg" {
  name        = "${var.ranger_admin_sg_name}"
  description = "${var.ranger_admin_sg_desc}"
  vpc_id      = "${var.vpc_id}"

  #Allow ranger admin
  ingress {
    from_port       = "${var.ranger_port}"
    to_port         = "${var.ranger_port}"
    protocol        = "tcp"
    cidr_blocks = ["${var.local_ips}"]
  }

  ingress {
    from_port       = "${var.ranger_port}"
    to_port         = "${var.ranger_port}"
    protocol        = "tcp"
    cidr_blocks = ["${data.aws_vpc.selected.cidr_block}"]
  }
  #allow solr
  ingress {
    from_port       = "${var.solr_port}"
    to_port         = "${var.solr_port}"
    protocol        = "tcp"
    cidr_blocks = ["${var.local_ips}"]
  }

  ingress {
    from_port       = "${var.solr_port}"
    to_port         = "${var.solr_port}"
    protocol        = "tcp"
    cidr_blocks = ["${data.aws_vpc.selected.cidr_block}"]
  }
  
  ingress {
    from_port       = "${var.ssh_port}"
    to_port         = "${var.ssh_port}"
    protocol        = "tcp"
    cidr_blocks = ["${var.local_ips}"]
  }

  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "${var.ranger_admin_sg_name}"
  }
}

#Declare the data source
data "aws_availability_zones" "available" {}

data "aws_subnet_ids" "private" {
  vpc_id = "${var.vpc_id}"
}

data "aws_vpc" "selected" {
  id = "${var.vpc_id}"
}

data "template_file" "ranger_tmpl" {
  template = "${file("ranger_install.sh.tpl")}"

  vars {
    db_host = "${aws_db_instance.ranger_mysql.address}"
    db_root_user = "${var.db_user}" 
    db_ranger_user = "${var.db_ranger_user}" 
    db_ranger_passwod = "${var.db_ranger_pwd}"
    db_root_password = "${var.db_pwd}"
    solr_url = "${aws_instance.tf_ranger_solr.private_dns}"
    aws_access_key = "${var.access_key}"
    aws_secret_key = "${var.secret_key}"
    aws_log_location = "${var.log_location}"
  }
}

data "template_file" "solr_tmpl" {
  template = "${file("solr_install.sh.tpl")}"

  vars {
    solr_download_url = "${var.solr_download_url}"
  }
}

#Configure EC2 instance for Solr
resource "aws_instance" "tf_ranger_solr" {
  ami = "${var.ami}"
  instance_type = "${var.solr_instance_type}"
  associate_public_ip_address = "true"
  key_name = "${var.key_name}"
  subnet_id = "${var.public_subnets[0]}"
  security_groups = ["${aws_security_group.ec2_sg.id}"] 
  
  tags { 
    Name = "${var.ranger_solr_name}"
  }

  user_data = "${data.template_file.solr_tmpl.rendered}" 
}

#Configure EC2 instance for Ranger Admin
resource "aws_instance" "tf_ranger_admin" {
  count="${var.instance_count}"
  ami = "${var.ami}"
  instance_type = "${var.ranger_instance_type}"
  associate_public_ip_address = "true"
  key_name = "${var.key_name}"
  subnet_id = "${var.public_subnets[count.index]}"
  security_groups = ["${aws_security_group.ec2_sg.id}"] 
  depends_on = ["aws_db_instance.ranger_mysql"]

  tags { 
    Name="${format("${var.ranger_admin_name}-%01d",count.index+1)}" 
  }

  user_data = "${data.template_file.ranger_tmpl.rendered}" 
}

#---- Ranger Load Balancer -----
#Configure Security Group for Load Balancer
resource "aws_security_group" "lb_sg" {
  name        = "${var.ranger_lb_sg_name}"
  description = "${var.ranger_lb_sg_desc}"
  vpc_id      = "${var.vpc_id}"

  #Allow Ranger traffic
  ingress {
    from_port       = "${var.ranger_port}"
    to_port         = "${var.ranger_port}"
    protocol        = "tcp"
    cidr_blocks = ["${data.aws_vpc.selected.cidr_block}"]
  }

  ingress {
    from_port       = "${var.ranger_port}"
    to_port         = "${var.ranger_port}"
    protocol        = "tcp"
    cidr_blocks = ["${var.local_ips}"]
  }

  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "${var.ranger_lb_sg_name}"
  }
}

#Configure target for Load Balancer
resource "aws_lb_target_group" "ranger_target" {
  name     = "${var.ranger_target_name}"
  port     = "${var.ranger_port}"
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"

  stickiness {
    type = "lb_cookie"
    enabled = true
    cookie_duration = "${var.cookie_duration}"
  }

  health_check {    
    healthy_threshold   = 3    
    unhealthy_threshold = 10    
    timeout             = 5    
    interval            = 10    
    path                = "/login.jsp"    
    port                = "${var.ranger_port}" 
  }
}

#Configure Load Balancer
resource "aws_lb" "ranger_lb" {
  name               = "${var.ranger_lb_name}"
  internal           = true
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.lb_sg.id}"]
  subnets = "${var.public_subnets}"


  enable_deletion_protection = false

  tags = {
    Environment = "${var.ranger_lb_name}"
  }
}

#Configure listener for load balancer
resource "aws_lb_listener" "lb_listener" {  
  load_balancer_arn = "${aws_lb.ranger_lb.arn}"  
  port              = "${var.ranger_port}"  
  protocol          = "HTTP"
  
  default_action {    
    target_group_arn = "${aws_lb_target_group.ranger_target.arn}"
    type             = "forward"  
  }
}

#Instance Attachment
resource "aws_lb_target_group_attachment" "tg_attachment" {
  target_group_arn = "${aws_lb_target_group.ranger_target.arn}"
  target_id        = "${element(aws_instance.tf_ranger_admin.*.id,count.index)}" 
  port             = "${var.ranger_port}"
}


