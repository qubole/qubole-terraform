# Sample Hive Cluster Bootstrap
#Usage for any Hive Cluster: install_ranger -h "RangerDNS/LB" -p Port -S "SolrDNS/LB" -P port

# Add below code in Qubole Hive cluster bootstrap to Install Ranger Plugin 
# by changing RangerDNS, SolrDNS and ports as configured

source /usr/lib/qubole/bootstrap-functions/hive/ranger-client.sh
install_ranger -h RangerDNS -p 80 -S SolrDNS -P 80
