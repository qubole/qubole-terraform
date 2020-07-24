#!/bin/bash

set -e

SOLR_INSTALL=/opt/solr_install

SOLR_DWNLD_URL=${SOLR_URL}/${SOLR_VER}/solr-${SOLR_VER}.tgz

#JAVA
yum install -y ${JAVA_VER}-openjdk-devel
echo 'export JAVA_HOME=/usr/lib/jvm/${JAVA_VER}' | sudo tee /etc/profile.d/java.sh
echo 'Defaults env_keep += "JAVA_HOME" ' | sudo tee -a /etc/sudoers
source /etc/profile.d/java.sh

mkdir -p $SOLR_INSTALL
cd $SOLR_INSTALL

wget https://dist.apache.org/repos/dist/release/ranger/${RANGER_VER}/apache-ranger-${RANGER_VER}.tar.gz
tar -zxf apache-ranger-${RANGER_VER}.tar.gz
rm apache-ranger-${RANGER_VER}.tar.gz
cd apache-ranger-${RANGER_VER}/security-admin/contrib/solr_for_audit_setup

sed -i 's/SOLR_INSTALL=false/SOLR_INSTALL=true/g' install.properties
sed -i 's/SOLR_MAX_MEM=2g/SOLR_MAX_MEM=${SOLR_MEM}/g' install.properties
sed -i 's~SOLR_DOWNLOAD_URL=~SOLR_DOWNLOAD_URL='$SOLR_DWNLD_URL'~g' install.properties

chmod +x setup.sh

sh setup.sh | tee -a /tmp/solr_log.txt

echo 'echo "Starting Solr Instance:" | tee -a /tmp/solr_log.txt' >> /etc/rc.local
echo "date '+%F %T' | tee -a /tmp/solr_log.txt" >> /etc/rc.local
echo "sh /opt/solr/ranger_audit_server/scripts/start_solr.sh | tee -a /tmp/solr_log.txt" >> /etc/rc.local

chmod +x /etc/rc.d/rc.local

touch /tmp/setup-done
