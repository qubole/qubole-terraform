#!/bin/bash

set -e

RANGER_ADMIN=ranger-${RANGER_VER}-admin
RANGER_FILE=${RANGER_ADM_PATH}/ranger-${RANGER_VER}/$RANGER_ADMIN.tar.gz

RANGER_USERSYNC=ranger-${RANGER_VER}-usersync
USERSYNC_FILE=${RANGER_ADM_PATH}/ranger-${RANGER_VER}/$RANGER_USERSYNC.tar.gz

echo "PS - $RANGER_FILE" | tee -a /tmp/ranger_log.txt
echo "PS - $USERSYNC_FILE" | tee -a /tmp/ranger_log.txt

#JAVA
yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum install -y ${JAVA_VER}-openjdk-devel mysql bc nc wget xmlstarlet gcc
echo "export JAVA_HOME=/usr/lib/jvm/${JAVA_VER}" | tee /etc/profile.d/java.sh
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

sed -i "s/mysql-connector-java.jar/${MYSQL_VER}.jar/g" install.properties
sed -i "s/db_root_user=root/db_root_user=${DB_ROOT_USR}/g" install.properties
sed -i "s/db_root_password=/db_root_password=${DB_ROOT_PWD}/g" install.properties
sed -i "s/db_password=/db_password=${DB_RANGER_PWD}/g" install.properties
if [[ "${DB_PORT}" -eq "3306" ]]; then
    sed -i "s/db_host=localhost/db_host=${DB_HOST}/g" install.properties
else
    sed -i "s/db_host=localhost/db_host=${DB_HOST}:${DB_PORT}/g" install.properties
fi

if [[ "${SOLR_ALB_PORT}" -eq "80" ]]; then
	sed -i "s~audit_solr_urls=~audit_solr_urls=http://${SOLR_DNS}/solr/ranger_audits~g" install.properties
else
	sed -i "s~audit_solr_urls=~audit_solr_urls=http://${SOLR_DNS}:${SOLR_ALB_PORT}/solr/ranger_audits~g" install.properties
fi

## LDAP Authentication
sed -i "s/authentication_method=NONE/authentication_method=${AUTH_METHOD}/g" install.properties
sed -i "s~xa_ldap_url=~xa_ldap_url=${LDAP_URL}~g" install.properties
sed -i "s/xa_ldap_userDNpattern=/xa_ldap_userDNpattern=${LDAP_USER_DN_PATTERN}/g" install.properties
sed -i "s/xa_ldap_groupSearchBase=/xa_ldap_groupSearchBase=${GROUP_SEARCH_BASE}/g" install.properties
sed -i "s/xa_ldap_groupSearchFilter=/xa_ldap_groupSearchFilter=${LDAP_GROUP_SEARCH_FILTER}/g" install.properties
sed -i "s/xa_ldap_groupRoleAttribute=/xa_ldap_groupRoleAttribute=${GROUP_NAME_ATTRIBUTE}/g" install.properties
sed -i "s/xa_ldap_base_dn=/xa_ldap_base_dn=${LDAP_SEARCH_BASE}/g" install.properties
sed -i "s/xa_ldap_bind_dn=/xa_ldap_bind_dn=${LDAP_BIND_DN}/g" install.properties
sed -i "s/xa_ldap_bind_password=/xa_ldap_bind_password=${LDAP_BIND_PASSWORD}/g" install.properties
sed -i "s/xa_ldap_referral=/xa_ldap_referral=${LDAP_REFERRAL}/g" install.properties
sed -i "s/xa_ldap_userSearchFilter=/xa_ldap_userSearchFilter=${LDAP_USER_SEARCH_FILTER}/g" install.properties

sh setup.sh | tee /tmp/ranger_setup_log.txt

sh set_globals.sh
sh set_globals.sh
cd /usr/bin
ln -sf /usr/local/ranger-admin/ews/start-ranger-admin.sh ranger-admin-start
ln -sf /usr/local/ranger-admin/ews/stop-ranger-admin.sh ranger-admin-stop

service ranger-admin start
service ranger-admin stop

cd /usr/local/ranger-admin
sh setup.sh | tee -a /tmp/ranger_setup_log.txt

## Usersync
cd /usr/local
wget $USERSYNC_FILE
tar -zxf $RANGER_USERSYNC.tar.gz
ln -s $RANGER_USERSYNC ranger-usersync
rm $RANGER_USERSYNC.tar.gz

mkdir -p /var/log/ranger/usersync
cd ranger-usersync
xmlstarlet ed -L -P -u "//property[name='ranger.usersync.cookie.enabled']/child::value" -v "false" conf.dist/ranger-ugsync-default.xml

sed -i "s~ranger_base_dir = /etc/ranger~ranger_base_dir="/etc/ranger"~g" install.properties
sed -i "s~logdir=logs~logdir=/var/log/ranger/usersync~g" install.properties

sed -i "s/SYNC_SOURCE = unix/SYNC_SOURCE=ldap/g" install.properties
sed -i "s/SYNC_INTERVAL =/SYNC_INTERVAL=${LDAP_SYNC_INTERVAL}/g" install.properties
sed -i "s~POLICY_MGR_URL =~POLICY_MGR_URL=http://${RANGER_DNS}~g" install.properties
sed -i "s/AUTH_SSL_ENABLED=false/AUTH_SSL_ENABLED=true/g" install.properties
sed -i "s~CRED_KEYSTORE_FILENAME=/etc/ranger/usersync/conf/rangerusersync.jceks~CRED_KEYSTORE_FILENAME=/usr/lib/ranger/ranger-2.1.0-usersync/conf/rangerusersync.jceks~g" install.properties

sed -i "s~SYNC_LDAP_URL =~SYNC_LDAP_URL=${LDAP_URL}~g" install.properties
sed -i "s/SYNC_LDAP_BIND_DN =/SYNC_LDAP_BIND_DN=${LDAP_BIND_DN}/g" install.properties
sed -i "s/SYNC_LDAP_BIND_PASSWORD =/SYNC_LDAP_BIND_PASSWORD=${LDAP_BIND_PASSWORD}/g" install.properties
sed -i "s/SYNC_LDAP_SEARCH_BASE =/SYNC_LDAP_SEARCH_BASE=${LDAP_SEARCH_BASE}/g" install.properties
sed -i "s/SYNC_LDAP_USER_SEARCH_BASE =/SYNC_LDAP_USER_SEARCH_BASE=${LDAP_USER_SEARCH_BASE}/g" install.properties
sed -i "s/SYNC_LDAP_USER_NAME_ATTRIBUTE = cn/SYNC_LDAP_USER_NAME_ATTRIBUTE=${LDAP_USER_NAME_ATTRIBUTE}/g" install.properties

sed -i "s/SYNC_GROUP_SEARCH_ENABLED=/SYNC_GROUP_SEARCH_ENABLED=${GROUP_SEARCH_ENABLED}/g" install.properties
sed -i "s/SYNC_GROUP_USER_MAP_SYNC_ENABLED=/SYNC_GROUP_USER_MAP_SYNC_ENABLED=${GROUP_USER_MAP_SYNC_ENABLED}/g" install.properties
sed -i "s/SYNC_GROUP_SEARCH_BASE=/SYNC_GROUP_SEARCH_BASE=${GROUP_SEARCH_BASE}/g" install.properties
sed -i "s/SYNC_GROUP_OBJECT_CLASS=/SYNC_GROUP_OBJECT_CLASS=${GROUP_OBJECT_CLASS}/g" install.properties
sed -i "s/SYNC_GROUP_NAME_ATTRIBUTE=/SYNC_GROUP_NAME_ATTRIBUTE=${GROUP_NAME_ATTRIBUTE}/g" install.properties
sed -i "s/SYNC_GROUP_MEMBER_ATTRIBUTE_NAME=/SYNC_GROUP_MEMBER_ATTRIBUTE_NAME=${GROUP_MEMBER_ATTRIBUTE_NAME}/g" install.properties

sh setup.sh | tee /tmp/usersync_setup_log.txt
#cd /usr/bin
#ln -sf /usr/local/ranger-usersync/start.sh ranger-usersync-start
#ln -sf /usr/local/ranger-usersync/stop.sh ranger-usersync-stop

touch /tmp/setup-done
