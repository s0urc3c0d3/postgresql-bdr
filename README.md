# postgresql-bdr

Docker container of PostgreSQL BDR 9.4

It can be used standalone or with rancher

How it will be runned can be determined via ENV variables. This are taken from BDR docs:
MAX_CONNECTIONS=100 
MAX_WAL_SENDERS=10 
MAX_REPLICATION_SLOTS=10 
MAX_WORKER_PROCESSES=10 
ENABLE_LOGGING=y 
LOG_ERROR_VERBOSITY=verbose 
LOG_MIN_MESSAGES=debug1 
LOG_LINE_PREFIX='%t [%p-%l] %q%u@%d ' 
ENABLE_CONFLICT_OPTIONS=y 
DEFAULT_APPLY_DELAY=2000 
LOG_CONFLICTS_TO_TABLE=on 

Go to BDR and postgre docs to find their meaning

You will need to provide name for new database, user for that database, his password and DBA password
DBNAME=maasdb 
DBUSER=maas 
DBPASS= 
DBAPASS=Admin123! 

Docker deamon IP on docker bridge (It will be removed on future releases)
DOCKER_IP=172.17.0.1/16 

If this container is first in cluster. This will tell the container to create group

FIRST_NODE=y 

All the containers should have shared network. Provide CIDR of this network - it will be added to pg_hba

CLUSTER_CIDR=192.168.122.0/24 

If you wish to import data to your database provide local path (container local path) you should use docker volumes to allow container load this file
IMPORT_DBDATA_LOCATION= 
IMPORT_DBDATA=n 

Do we use run in rancher? Do not use this options outside of rancher. When you will use rancher please use proper catalog what will take care of all ENV variables

RANCHER_ENABLE=0
RANCHER_CLEANUP_TIME=60
