#! /bin/bash

sudo yum install -y java-1.8.0-openjdk-devel
echo 'export JAVA_HOME=/usr/lib/jvm/java-1.8.0' | sudo tee /etc/profile.d/java.sh
echo 'Defaults env_keep += "JAVA_HOME" ' | sudo tee -a /etc/sudoers
source /etc/profile.d/java.sh

sudo yum install -y wget

cd /usr/local
sudo wget https://s3.amazonaws.com/paid-qubole/ranger-1.1.0/ranger-1.1.0-usersync.tar.gz
sudo tar zxf ./ranger-1.1.0-usersync.tar.gz
sudo ln -sf /usr/local/ranger-1.1.0-usersync ranger-usersync
sudo rm ranger-1.1.0-usersync.tar.gz 
sudo mkdir -p /var/log/ranger/usersync

cd ranger-usersync 
sudo sed -i 's~POLICY_MGR_URL =~POLICY_MGR_URL='${ranger_url}'~g' install.properties 
sudo sed -i 's/SYNC_SOURCE = unix/SYNC_SOURCE=ldap/g' install.properties
sudo sed -i 's~CRED_KEYSTORE_FILENAME=/etc/ranger/usersync/conf/rangerusersync.jceks~CRED_KEYSTORE_FILENAME=/usr/lib/ranger/ranger-1.1.0-usersync/conf/rangerusersync.jceks~g' install.properties
sudo sed -i 's~SYNC_LDAP_URL =~SYNC_LDAP_URL='${ldap_url}'~g' install.properties
sudo sed -i 's/SYNC_INTERVAL =/SYNC_INTERVAL='${ldap_sync_interval}'/g' install.properties
sudo sed -i 's~logdir=logs~logdir=/var/log/ranger/usersync~g' install.properties

sudo sed -i 's/SYNC_LDAP_BIND_DN =/SYNC_LDAP_BIND_DN='${ldap_users_dn}'/g' install.properties
sudo sed -i 's/SYNC_LDAP_BIND_PASSWORD =/SYNC_LDAP_BIND_PASSWORD='${ldap_bind_password}'/g' install.properties
sudo sed -i 's/SYNC_LDAP_SEARCH_BASE =/SYNC_LDAP_SEARCH_BASE='${ldap_base_dn}'/g' install.properties
#sudo sed -i 's/SYNC_LDAP_USER_SEARCH_BASE =/SYNC_LDAP_USER_SEARCH_BASE='${ldap_base_dn}'/g' install.properties
sudo sed -i 's/SYNC_LDAP_USER_SEARCH_FILTER =/SYNC_LDAP_USER_SEARCH_FILTER='${ldap_search_filter}'/g' install.properties
sudo sed -i 's/SYNC_LDAP_USER_NAME_ATTRIBUTE = cn/SYNC_LDAP_USER_NAME_ATTRIBUTE='${ldap_user_name_attribute}'/g' install.properties

sudo sed -i 's/SYNC_GROUP_SEARCH_ENABLED=/SYNC_GROUP_SEARCH_ENABLED='${ldap_group_search_enabled}'/g' install.properties
sudo sed -i 's/SYNC_GROUP_NAME_ATTRIBUTE=/SYNC_GROUP_NAME_ATTRIBUTE='${ldap_group_name_attribute}'/g' install.properties
sudo sed -i 's/SYNC_GROUP_OBJECT_CLASS=/SYNC_GROUP_OBJECT_CLASS='${ldap_group_object_class}'/g' install.properties
sudo sed -i 's/SYNC_GROUP_MEMBER_ATTRIBUTE_NAME=/SYNC_GROUP_MEMBER_ATTRIBUTE_NAME='${ldap_group_member_attribute_name}'/g' install.properties

sudo ./setup.sh | sudo tee /tmp/setup_log.txt

cd /usr/bin
sudo ln -sf /usr/local/ranger-usersync/start.sh ranger-usersync-start
sudo ln -sf /usr/local/ranger-admin/ews/stop.sh ranger-usersync-stop
#sudo ln -sf /usr/local/ranger-1.1.0-usersync ranger-usersync 
sudo ranger-usersync start

