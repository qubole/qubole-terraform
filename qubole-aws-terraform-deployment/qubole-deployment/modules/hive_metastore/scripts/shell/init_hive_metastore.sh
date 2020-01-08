#!/usr/bin/env bash

sudo yum install -y mysql

echo ">>>> Proceeding with Hive Metastore init"
echo ">>>> Downloading required SQL from Github"

wget https://raw.githubusercontent.com/apache/hive/master/metastore/scripts/upgrade/mysql/hive-schema-2.1.0.mysql.sql
wget https://raw.githubusercontent.com/apache/hive/master/metastore/scripts/upgrade/mysql/hive-txn-schema-2.1.0.mysql.sql

echo ">>>> Checking if Hive is already initialized"
if [ $(mysql -N -s -u${hive_user_name} -p${hive_user_pass} -h${hive_db_host} -e "select count(*) from information_schema.tables where table_schema='${hive_db_name}' and table_name='DBS';") -eq 1 ]; then
        echo "Hive is initialized. Nothing to do!";
else
        echo "Hive is not initialized, proceeding with init..."
        mysql -u${hive_user_name} -p${hive_user_pass} -h${hive_db_host} ${hive_db_name} < hive-schema-2.1.0.mysql.sql
fi