# Build Ranger Infrastructure with Terraform
Terraform is an infrastructure as code software by HashiCorp. It is a server provisioning tool. It provisions and manages infrastructure across multiple providers such as AWS, GCP,Azure and OCI. Infrastructure is defined in a HCL Terraform syntax or JSON format.

Terraform can be downloaded from here.

Used version : Terraform v0.11.10 or https://www.terraform.io/downloads.html

Below is the architectural diagram of the ranger infrastructure.

![Ranger Architecture](https://github.com/qubole/qubole-terraform/blob/master/ranger/images/ranger_architecture.png)

Terraform script has been developed to build this infrastructure. Following resources will be provisioned.

Ranger DB\
Ranger Admin Instances\
Application Load Balancer\
Solr Instance

Note: UserSyncis not part of this terraform script as of now.

# Pre-requisites for AWS: #
Create a VPC.\
Create two public subnets in different Availability Zones to be used for load balancer.\
Create two private subnets in different Availability Zones to be used for RDS (db subnet group).

# Pre-requisites for GCP: #
Create a service account.\
Download service account key in a JSON file.\
Create a VPC network and subnet.

Most of the resource properties are parameterized. User has to change only terraform.tfvars as per the requirement.

providers.tf: In terraform, providers are interfaces to the services that maintain our resources.This file has details about AWS/GCP provider.\
main.tf: This file contains all the resource configurations(rds/ec2/load balancer/security groups etc..).\
variables.tf: It has all input variable declarations.\
terraform.tfvars: This is the file where user can pass the desired values for all variables.Terraform will automatically load input variable values from any file named terraform.tfvars or ending in .auto.tfvars.\
ranger_install.tpl: This template file has all the steps to install ranger admin in ec2 instance.\
solr_install.tpl: This template file has all the steps to install solr.

How to run terraform commands:

terraform init

terraform plan

terraform apply

terraform init command will automatically download and install any provider binary for the providers in use within the configuration, which in this case aws and mysql providers.

terraform plan command is used to see the execution plan.

terraform apply command is used to apply the changes required to reach the desired state of the configuration,

After 10-15 minutes, entire ranger infrastructure would be ready.

To access the ranger admin ui: get the public dns of the ranger admin instance which is launched in public subnet.

6080 is the default port for ranger admin instance.

eg:- ec2-3-87-227-154.compute-1.amazonaws.com:6080

Default credential : admin/admin
