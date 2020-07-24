Pre-requisites: Terraform 0.12, Python and aws-cli, Private Key to ssh.

Terraform script to build infrastructure for RangerAdmin-2 with Autoscaling Groups in Public Subnet.
It also creates Ranger Hive Service, Default qbol_user and qubole_health_check policy.

# Following resources will be provisioned.
1. Ranger DB
2. Security Groups
3. Application Load Balancer for Solr and Ranger
4. Base AMI for Ranger and Solr
5. Launch templates for Ranger and Solr Instances
6. Auto scaling groups for Ranger and Solr

# Changes required only in terraform.tfvar file.
# Running the script: 
terraform init
terraform plan
terraform apply --auto-approve
terraform refresh
 

