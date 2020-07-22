Pre-requisites: Python and aws-cli required on host machine where Terraform scripts will be executed.

Terraform script to build infrastructure for RangerAdmin-2 with Autoscaling Groups. 
Following resources will be provisioned.

. Ranger DB
. Security Groups
. Application Load Balancer for Solr and Ranger
. Base AMI for Ranger and Solr
. Launch templates for Ranger and Solr Instances
. Auto scaling groups for Ranger and Solr
. Ranger Hive Service and Default qbol_user and qubole_health_check policy

# Changes required only in terraform.tfvar file.
# Running the script: 
terraform init
terraform plan
terraform apply --auto-approve
terraform refresh
 

