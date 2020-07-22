#!/bin/bash

source /etc/profile.d/java.sh
cd /opt/solr/ranger_audit_server/scripts/
sh start_solr.sh | tee -a /tmp/solr_start.txt

