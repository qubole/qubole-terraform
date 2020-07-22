source /usr/lib/qubole/bootstrap-functions/hive/ranger-client.sh

#Usage for any Hive Cluster: install_ranger -h "RangerDNS/LB" -p Port -S "SolrDNS/LB" -P port
install_ranger -h xxxx-ranger-alb-xxxxxx.us-east-1.elb.amazonaws.com -p 80 -S xxx-solr-alb-xxxx.us-east-1.elb.amazonaws.com -P 80
