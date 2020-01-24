#!/usr/bin/env bash

cd ~
mkdir cloudsql
mkdir cloudsqldir
cd cloudsql
wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O cloud_sql_proxy
chmod +x cloud_sql_proxy

cloud_sql_instance_name=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/cloud_sql_instance -H "Metadata-Flavor: Google")
credentials_json=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/credentials_data -H "Metadata-Flavor: Google")

project_name=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/project_name -H "Metadata-Flavor: Google")
region=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/region -H "Metadata-Flavor: Google")

echo ${credentials_json} > credentials.json

cloud_sql_instance_name="${project_name}:${region}:${cloud_sql_instance_name}"

./cloud_sql_proxy -credential_file=credentials.json -ip_address_types=PRIVATE -instances=${cloud_sql_instance_name}=tcp:0.0.0.0:3306 &>/dev/null &

echo ">>>> Terraform does not support the CloudSQL operation REST API that allows automatic import of SQL into a DB. Hence we initialize the Hive Metastore ourselves"

sudo apt-get install -y mysql-client

echo ">>>> Proceeding with Hive Metastore init"
echo ">>>> Downloading required SQL from Github"

wget https://raw.githubusercontent.com/apache/hive/master/metastore/scripts/upgrade/mysql/hive-schema-2.1.0.mysql.sql
wget https://raw.githubusercontent.com/apache/hive/master/metastore/scripts/upgrade/mysql/hive-txn-schema-2.1.0.mysql.sql

echo ">>>> Checking if Hive is already initialized"
hive_user=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/hive_user -H "Metadata-Flavor: Google")
hive_user_password=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/hive_user_password -H "Metadata-Flavor: Google")
hive_db=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/hive_db -H "Metadata-Flavor: Google")
if [ $(mysql -N -s -u${hive_user} -p${hive_user_password} -h127.0.0.1 -e "select count(*) from information_schema.tables where table_schema='${hive_db}' and table_name='DBS';") -eq 1 ]; then
        echo "Hive is initialized. Nothing to do!";
else
        echo "Hive is not initialized, proceeding with init..."
        mysql -u${hive_user} -p${hive_user_password} -h127.0.0.1 ${hive_db} < hive-schema-2.1.0.mysql.sql
fi

