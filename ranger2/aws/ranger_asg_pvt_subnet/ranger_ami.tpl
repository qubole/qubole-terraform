#!/bin/bash

set -e

RANGER_ADMIN=ranger-${RANGER_VER}-admin
RANGER_FILE=${RANGER_ADM_PATH}/$RANGER_ADMIN.tar.gz

echo "PS - $RANGER_FILE" | tee -a /tmp/ranger_log.txt

#JAVA
yum install -y ${JAVA_VER}-openjdk-devel mysql bc nc
echo 'export JAVA_HOME=/usr/lib/jvm/${JAVA_VER}' | tee /etc/profile.d/java.sh
echo 'Defaults env_keep += "JAVA_HOME" ' | tee -a /etc/sudoers
source /etc/profile.d/java.sh

#MySQL JDBC JAR
wget ${MYSQL_PATH}/${MYSQL_VER}.tar.gz
tar -zxf ${MYSQL_VER}.tar.gz
cp ${MYSQL_VER}/${MYSQL_VER}.jar /usr/share/java/
rm ${MYSQL_VER}.tar.gz
rm -R ${MYSQL_VER}

#MySQL
echo "mysql -h ${DB_HOST} -P ${DB_PORT} -u${DB_ROOT_USR} -p${DB_ROOT_PWD}" | tee -a /tmp/ranger_log.txt 
echo "CREATE USER IF NOT EXISTS '${DB_RANGER_USR}' IDENTIFIED BY '${DB_RANGER_PWD}';GRANT ALL PRIVILEGES ON ranger.* TO '${DB_RANGER_USR}'@'%' WITH GRANT OPTION;" | tee -a /tmp/ranger_log.txt

mysql -h ${DB_HOST} -P ${DB_PORT} -u${DB_ROOT_USR} -p${DB_ROOT_PWD} -e "CREATE USER IF NOT EXISTS '${DB_RANGER_USR}' IDENTIFIED BY '${DB_RANGER_PWD}';GRANT ALL PRIVILEGES ON ranger.* TO '${DB_RANGER_USR}'@'%' WITH GRANT OPTION;"

#Ranger Admin
cd /usr/local
wget $RANGER_FILE
tar -zxf $RANGER_ADMIN.tar.gz 
ln -s $RANGER_ADMIN ranger-admin 
rm $RANGER_ADMIN.tar.gz 

cd ranger-admin 

sed -i 's/mysql-connector-java.jar/${MYSQL_VER}.jar/g' install.properties
sed -i 's/db_root_user=root/db_root_user=${DB_ROOT_USR}/g' install.properties 
sed -i 's/db_root_password=/db_root_password=${DB_ROOT_PWD}/g' install.properties  
sed -i 's/db_password=/db_password=${DB_RANGER_PWD}/g' install.properties 
if [[ "${DB_PORT}" -eq "3306" ]]; then
    sed -i 's/db_host=localhost/db_host=${DB_HOST}/g' install.properties
else 
    sed -i 's/db_host=localhost/db_host=${DB_HOST}:${DB_PORT}/g' install.properties 
fi

if [[ "${SOLR_ALB_PORT}" -eq "80" ]]; then
	sed -i 's~audit_solr_urls=~audit_solr_urls=http://${SOLR_DNS}/solr/ranger_audits~g' install.properties
else
	sed -i 's~audit_solr_urls=~audit_solr_urls=http://${SOLR_DNS}:${SOLR_ALB_PORT}/solr/ranger_audits~g' install.properties
fi

sh setup.sh | tee /tmp/setup_log.txt

sh set_globals.sh 
sh set_globals.sh
cd /usr/bin 
ln -sf /usr/local/ranger-admin/ews/start-ranger-admin.sh ranger-admin-start 
ln -sf /usr/local/ranger-admin/ews/stop-ranger-admin.sh ranger-admin-stop

service ranger-admin start
service ranger-admin stop

cd /usr/local/ranger-admin
sh setup.sh | tee -a /tmp/setup_log.txt

touch /tmp/setup-done


 
