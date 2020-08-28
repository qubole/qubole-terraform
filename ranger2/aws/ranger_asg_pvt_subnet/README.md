Pre-requisites: Terraform 0.12, Python and aws-cli, Private Key to ssh.

Terraform script to build infrastructure for RangerAdmin-2 with Autoscaling Groups in Private Subnet.
Private Key should placed in the same directory as tf scripts.
It also creates Ranger Hive Service, Default qbol_user and qubole_health_check policy.

# Following resources will be provisioned.
1. Ranger DB
2. Security Groups
3. ALB Internet Facing for Solr and Ranger for UI Access
4. ALB Internal Facing for Solr and Ranger for Cluster Access
4. Base AMI for Ranger and Solr
5. Launch templates for Ranger and Solr Instances
6. Auto scaling groups for Ranger and Solr

# Changes required only in terraform.tfvar.
Copy ssh key in same location as tf scripts.
# Running the script: 
1. terraform init
2. terraform plan
3. terraform apply --auto-approve
4. terraform refresh
 

