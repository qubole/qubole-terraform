#!/bin/bash

#JAVA
sudo yum install -y java-1.8.0-openjdk-devel
echo 'export JAVA_HOME=/usr/lib/jvm/java-1.8.0' | sudo tee /etc/profile.d/java.sh
echo 'Defaults env_keep += "JAVA_HOME" ' | sudo tee -a /etc/sudoers
source /etc/profile.d/java.sh


sudo yum install -y git
cd $HOME
git clone https://github.com/apache/incubator-ranger.git
cd incubator-ranger/security-admin/contrib/solr_for_audit_setup
sudo sed -i 's/SOLR_INSTALL=false/SOLR_INSTALL=true/g' install.properties
sudo sed -i 's/SOLR_MAX_MEM=2g/SOLR_MAX_MEM=512m/g' install.properties
sudo sed -i 's~SOLR_DOWNLOAD_URL=~SOLR_DOWNLOAD_URL='${solr_download_url}'~g' install.properties

sudo ./setup.sh
                                                
cd /opt/solr/ranger_audit_server/scripts/
sudo ./start_solr.sh