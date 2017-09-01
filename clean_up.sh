#!/bin/bash

echo "Starting Cleanup of removed containers from BDR cluster"
service_name=$(curl http://rancher-metadata.rancher.internal/latest/self/service/name)

IP_count=0

for i in $(curl http://rancher-metadata.rancher.internal/latest/self/stack/services/${service_name}/containers/ | awk -F= '{print $1}')
do
	IPS="$IPS $(curl http://rancher-metadata.rancher.internal/latest/self/stack/services/${service_name}/containers/$i/primary_ip)"
	IP_count=$((IP_count+1))
done

BDR_count=0
for i in $(su - postgres -c 'echo "select node_name from bdr.bdr_nodes where node_status not like '\'k\'';" | /usr/lib/postgresql/9.4/bin/psql -d '$1 | awk '{if (NR > 2 && NF == 1) { print $0 } }')
do
	BDR_IPS="$BDR_IPS $i"
	BDR_count=$(($BDR_count+1))
done

if [ $BDR_count -gt $IP_count ]
then
	for i in $IPS
	do
		BDR_IPS=$(echo "$i $BDR_IPS" | awk '{for (i=2;i<NF+1;i++) {if ($i != $1) {printf ("%s ",$i)}}}')
	done
	for i in $BDR_IPS
	do
		echo "SELECT bdr.bdr_part_by_node_names(ARRAY['"$i"']);" | su - postgres -c '/usr/lib/postgresql/9.4/bin/psql -d '$1
	done
fi
echo "Cleanup finished"
