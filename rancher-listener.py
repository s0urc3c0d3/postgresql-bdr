#!/usr/bin/python3

import requests
import time
import subprocess
import os

r = requests.get('http://rancher-metadata.rancher.internal/latest/self/stack/name')

if (r.status_code == 200):
  stack_name = r.text
else:
  exit(1)

r = requests.get('http://rancher-metadata.rancher.internal/2015-12-19/self/service/name')

if (r.status_code == 200):
  service_name = r.text
else:
  exit(1)

r = requests.get('http://rancher-metadata.rancher.internal/latest/self/container/ips/0')
if (r.status_code == 200):
  my_ip = r.text


while(True):


  r = requests.get('http://rancher-metadata.rancher.internal/latest/stacks/'+stack_name+'/services/'+service_name+'/containers')
  if (r.status_code == 200):
    container_count = len(r.text.split('\n'))-1

  if (container_count > 1):
    #check if I should be cluster creator
    r = requests.get('http://rancher-metadata.rancher.internal/2015-12-19/stacks/'+stack_name+'/services/'+service_name+'/containers/0/name')
    if (r.status_code == 200):
      leader = r.text
    r = requests.get('http://rancher-metadata.rancher.internal/latest/self/container/name')
    if (r.status_code == 200):
      my_name = r.text

    subprocess.call(["/usr/local/sbin/create_ext.sh", os.environ['DBNAME']])

    # check if we have less containers than node in BDR
    subprocess.call(["/usr/local/sbin/clean_up.sh",os.environ['DBNAME']]) 

    if (my_name == leader):
     #we are the leader
      subprocess.call(["/usr/local/sbin/create_bdr.sh",os.environ['DBNAME'],my_ip])

    else:
      #we need to join the leader
      r = requests.get('http://rancher-metadata.rancher.internal/latest/stacks/'+stack_name+'/services/'+service_name+'/containers/'+leader+'/primary_ip')

      if (r.status_code == 200):
        leader_ip = r.text

      subprocess.call(["/usr/local/sbin/join_node.sh",leader_ip,my_ip,os.environ['DBNAME']])
  else:
    subprocess.call(["/usr/local/sbin/remove_ext.sh", os.environ['DBNAME'], my_ip]) 

  time.sleep(int(os.environ['RANCHER_CLEANUP_TIME']))

#print(container_count,leader,my_name)
