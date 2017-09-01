#!/bin/bash

if ! [ -f /run/lock/postgre-bdr.lock ]; then exit ; fi
if ! [ -f /run/lock/postgre-ext.lock ]; then exit ; fi
for i in $(su - postgres -c 'echo "select node_name from bdr.bdr_nodes;" | /usr/lib/postgresql/9.4/bin/psql -d maasdb' |awk '{if (NR > 2 && NF == 1) { print $0 } }' | grep -v $2)
do
	echo "SELECT bdr.bdr_part_by_node_names(ARRAY['"$i"']);" | su - postgres -c '/usr/lib/postgresql/9.4/bin/psql -d '$1 
	echo "select bdr.remove_bdr_from_local_node(true, true); drop extension bdr;" | su - postgres -c '/usr/lib/postgresql/9.4/bin/psql -d '$1 
done
rm /run/lock/postgre-bdr.lock
rm /run/lock/postgre-ext.lock
rm -f /var/lib/postgresql/9.4/main/postmaster.pid
rm -f /run/postgresql/9.4-main.pid
killall su
sleep 20
killall tail
