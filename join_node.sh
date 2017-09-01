#!/bin/bash

JOIN_IP=$1
NODE_IP=$2
DBNAME=$3

if [ -f /run/lock/postgre-bdr.lock ]; then exit ; fi
cat > /SQLTMP.sql << EOF
SELECT bdr.bdr_group_join(local_node_name := '$NODE_IP', node_external_dsn := 'port=5432 dbname=$DBNAME host=$NODE_IP', join_using_dsn := 'port=5432 dbname=$DBNAME host=$JOIN_IP');
SELECT bdr.bdr_node_join_wait_for_ready();
EOF

su - postgres -c "/usr/lib/postgresql/9.4/bin/psql -d $DBNAME -f /SQLTMP.sql & " 
touch /run/lock/postgre-bdr.lock
