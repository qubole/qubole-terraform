import requests
import json, sys

#This script takes 4 arguments.
#Loadbalancer Endpoint.
#Defloc Location.
#Service Name to be Created.
#Loadbalancer Port
#Usage: python ranger_policy.py LB-IP pritish-qubole hive_policy 80

host = sys.argv[1]
defloc_loc =  sys.argv[2] 
service_name = sys.argv[3]
port = sys.argv[4]

#host = "ps-cvs-ranger-asg-alb-1733501465.us-east-1.elb.amazonaws.com"
#defloc_loc =  "pritish-qubole" 
#service_name = "hivedev"
#port = 80

if port != 80:
    ranger_url= 'http://' + host + ':' + str(port) + '/service'
else:
    ranger_url= 'http://' + host + '/service'

user_url = ranger_url + '/xusers/'
policy_url = ranger_url + '/public'

groups_url = ranger_url + '/xusers/secure/groups'
qbl_usr = 'qbol_user'

hdrs={'content-type':'application/json','accept':'application/json'}
per_page_records = '1000000'

def get_req_data(url, json_data):
    if json_data is None:
        json_data = {"page":"1", "per_page": per_page_records}
    response = requests.get(url, json=json_data, auth=('admin','admin'), headers=hdrs)
    return(response)

def post_req_data(url, json_data):
    response = requests.post(url,json=json_data, auth=('admin','admin'), headers=hdrs)
    return(response)

def put_req_data(url, json_data):
    response = requests.put(url,json=json_data, auth=('admin','admin'),headers=hdrs)
    return(response)

def delete_req_data(url):
    response = requests.delete(url, auth=('admin','admin'),headers=hdrs)
    return(response)

# Create Service
def create_service():
    service_policy_url = policy_url + '/v2/api/service'
    config_data = {"password":"dummy","jdbc.driverClassName":"org.apache.hive.jdbc.HiveDriver",
               "jdbc.url":"none","username":"dummyuser"}

    json_data = {"name": service_name, "description": "Hive Qds Policy","type": "hive",
            "configs": config_data, "isEnabled": True}
#    print(service_policy_url)
#    print(json_data)
    res = post_req_data(service_policy_url, json_data)
    res_data = json.loads(res.text)
    if(res.status_code == 200):
        print('Created service successfully: ' + service_name )
    else:
        print('Failed creating Ranger Repository: ' + str(res_data))
        sys.exit(1)

# Create qbol_user
def create_qbl_usr(qbl_user):
    qbol_user_json = {"name": qbl_user,"firstName": qbl_user,"password":"Ranger123","userRoleList":["ROLE_ADMIN_AUDITOR"]} 
    usr_url = user_url + 'secure/users'
    res = post_req_data(usr_url, qbol_user_json)
    res_data = json.loads(res.text)
    if(res.status_code == 200):
        print('Qubole health check user created Successfully: qbl_user')
    else:
        print('Failed creating Qubole health check user: ' + str(res_data))
        sys.exit(1)

# Create qubole_health_check Policy
def health_check_policy():
    health_json = {"policyName": "qubole_health_check","databases": "default","tables": "dummy",
                   "columns": "*","description": "Hive Policy","repositoryName": service_name,
                   "repositoryType": "hive","tableType": "Inclusion","columnType": "Inclusion",
                   "isEnabled": True,"isAuditEnabled": True,
                   "permMapList": [{"userList": ["qbol_user"],"groupList":[],"permList": ["Read"]}]} 
    
    health_policy_url = policy_url + '/api/policy'
    res = post_req_data(health_policy_url, health_json)
    res_data = json.loads(res.text)
    if(res.status_code == 200):
        print('Qubole_Health_Check policy created successfully:')
    else:
        print('Failed creating Qubole_health_check policy: ' + str(res_data))
        sys.exit(1)

def create_defloc_policy(defloc_loc):
    defloc_json = {"name": "defloc", "description": "Defloc Policy",
                "service": service_name, "isEnabled": True,"isAuditEnabled": True, 
                "resources":{"url":{"values":[defloc_loc],"isExcludes":False,"isRecursive":True}},
                "policyItems":[{"accesses":[{"type":"write","isAllowed":True}],
                "users":['qbol_user'],"groups":[],"conditions":[],"delegateAdmin":False}]
                }
    defloc_url = policy_url + '/v2/api/policy'
    res = post_req_data(defloc_url, defloc_json)
    res_data = json.loads(res.text)
    if(res.status_code == 200):
        print('Qubole defloc policy created successfully:')
    else:
        print('Failed creating defloc policy: ' + str(res_data))
        sys.exit(1)

# Check if Service exists
if service_name == "":
    print('Service Name Required')
    sys.exit(1)
    
service_policy_url = policy_url + '/v2/api/service/name/' + service_name
res = get_req_data(service_policy_url, None)
if res.status_code == 404:
    create_service()
elif res.status_code == 200:
    print('Qubole Service ' + service_name + ' exists')
else:
    print('Error getting ' + service_name + ' service: ' + str(res.text))
                 
# Check if Qbol user Exists
get_usr_url = user_url + 'users/userName/' + qbl_usr
res = get_req_data(get_usr_url, None)
res_data = json.loads(res.text)
if res.status_code == 400:
    create_qbl_usr(qbl_usr)
elif res.status_code == 200:
    print('Qubole health check user ' + qbl_usr + ' exists')
else:
    print('Error getting qbol_user: ' + str(res_data))

# Check if qubole_health_check policy exists
qbl_policy_url = policy_url + '/v2/api/service/' + service_name + '/policy/qubole_health_check'
res = get_req_data(qbl_policy_url, None)
if res.status_code == 404:
    health_check_policy()
elif res.status_code == 200:
    print('Qubole health_check_policy Exists')
else:
    print('Error getting health_check_policy: ' + str(res.text))
 
# Check if Default Policy exists
if defloc_loc != '':
    defloc_loc = "*/" + defloc_loc + "/*"
    def_policy_url = policy_url + '/v2/api/service/' + service_name + '/policy/defloc'
    res = get_req_data(def_policy_url, None)
    if res.status_code == 404:
        create_defloc_policy(defloc_loc)
    elif res.status_code == 200:
        print('Qubole defloc policy exists')
    else:
        print('Error getting defloc policy: ' + str(res.text))
