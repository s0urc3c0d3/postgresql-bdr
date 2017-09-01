#!/bin/bash

if [ -f /run/lock/postgre-bdr.lock ]; then exit ; fi
echo "SELECT bdr.bdr_group_create(local_node_name := '"$2"', node_external_dsn := 'port=5432 dbname="$1" host="$2"'); SELECT bdr.bdr_node_join_wait_for_ready();" | su - postgres -c '/usr/lib/postgresql/9.4/bin/psql -d '$1 
touch /run/lock/postgre-bdr.lock
