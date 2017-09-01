#!/bin/bash -x

export LC_ALL=en_US.UTF-8


#If this is first run then we need to configure postgres options

#tail -f /dev/null
if [ -f /.first_run ]
then
	# do nothing if we have no password variable
	if [ -z ${DBPASS+x} ]; then exit 1; fi

	# id we have no name and IP addr then there is no sense to live

	echo "host   all             postgres         $DOCKER_IP               md5" >> /etc/postgresql/9.4/main/pg_hba.conf
	echo "host   all             postgres         $CLUSTER_CIDR               md5" >> /etc/postgresql/9.4/main/pg_hba.conf
	echo "host   $DBNAME         $DBUSER          $CLUSTER_CIDR               md5" >> /etc/postgresql/9.4/main/pg_hba.conf
	echo "host   replication     postgres         $CLUSTER_CIDR               md5" >> /etc/postgresql/9.4/main/pg_hba.conf

	sed -i 's/MAX_CONNECTIONS/'$MAX_CONNECTIONS'/g' /etc/postgresql/9.4/main/postgresql.conf
	sed -i 's/MAX_WAL_SENDERS/'$MAX_WAL_SENDERS'/g' /etc/postgresql/9.4/main/postgresql.conf
	sed -i 's/MAX_REPLICATION_SLOTS/'$MAX_REPLICATION_SLOTS'/g' /etc/postgresql/9.4/main/postgresql.conf
	sed -i 's/MAX_WORKER_PROCESSES/'$MAX_WORKER_PROCESSES'/g' /etc/postgresql/9.4/main/postgresql.conf
	if [ "y"$ENABLE_LOGGING == "yy" ] 
	then 
		sed -i 's/^#log_error_verbosity/log_error_werbosity/g' /etc/postgresql/9.4/main/postgresql.conf
		sed -i 's/^#log_min_messages/log_min_messages/g' /etc/postgresql/9.4/main/postgresql.conf
		sed -i 's/^#log_line_prefix/log_line_prefix/g' /etc/postgresql/9.4/main/postgresql.conf
	fi
	sed -i 's/LOG_ERROR_VERBOSITY/'$LOG_ERROR_VERBOSITY'/g' /etc/postgresql/9.4/main/postgresql.conf
	sed -i 's/LOG_MIN_MESSAGES/'$LOG_MIN_MESSAGES'/g' /etc/postgresql/9.4/main/postgresql.conf
	sed -i 's/LOG_LINE_PREFIX/'"$LOG_LINE_PREFIX"'/g' /etc/postgresql/9.4/main/postgresql.conf
	if [ "y"$ENABLE_CONFLICT_OPTIONS == "yy" ]
	then
		sed -i 's/^#bdr.default_apply_delay/bdr.default_apply_delay/g' /etc/postgresql/9.4/main/postgresql.conf
		sed -i 's/^#bdr.log_conflicts_to_table/bdr.log_conflicts_to_table/g' /etc/postgresql/9.4/main/postgresql.conf
	fi
	sed -i 's/DEFAULT_APPLY_DELAY/'$DEFAULT_APPLY_DELAY'/g' /etc/postgresql/9.4/main/postgresql.conf
	sed -i 's/LOG_CONFLICTS_TO_TABLE/'$LOG_CONFLICTS_TO_TABLE'/g' /etc/postgresql/9.4/main/postgresql.conf

	su - postgres -c '/usr/lib/postgresql/9.4/bin/pg_resetxlog -s /var/lib/postgresql/9.4/main/'

	mkdir -p /var/run/postgresql/9.4-main.pg_stat_tmp/
	chown postgres:postgres -R /var/run/postgresql/9.4-main.pg_stat_tmp/

	su - postgres -c 'export LC_ALL=en_US.UTF-8 ; /usr/lib/postgresql/9.4/bin/postgres -D /var/lib/postgresql/9.4/main -c config_file=/etc/postgresql/9.4/main/postgresql.conf' &

	sleep 30

	#initialize database, users, passwords and pg_hba.conf


	cat > /SQLTMP.sql << EOF
CREATE USER $DBUSER WITH PASSWORD '$DBPASS';
ALTER USER postgres WITH PASSWORD '$DBAPASS';
GRANT ALL PRIVILEGES ON DATABASE $DBNAME to $DBUSER;
EOF

	su - postgres -c "/usr/lib/postgresql/9.4/bin/createdb $DBNAME"
	su - postgres -c '/usr/lib/postgresql/9.4/bin/psql < /SQLTMP.sql '
	if [ "y"$IMPORT_DBDATA == "yy" ]
	then
        	su - postgres -c '/usr/lib/postgresql/9.4/bin/psql -d maasdb < '$IMPORT_DBDATA_LOCATION
	fi
	su - postgres -c "echo '*':5432:$DBNAME:postgres:$DBAPASS > ~/.pgpass ; chmod 0600 .pgpass"


	# if this container is launched on rancher. We need different non-flat approach. If not then go with standard env-based launch
	if [ "x"$RANCHER_ENABLED == "x1" ];
	then
		#launch simple script that will use rancher metadata to modify how this container works
		/rancher-listener.py &
	else

		# if so enable bdr on database
		cat > /SQLTMP.sql << EOF
CREATE EXTENSION btree_gist; CREATE EXTENSION bdr;
EOF

		if [ "y"$FIRST_NODE == "yy" ]
		then
			cat >> /SQLTMP.sql << EOF
SELECT bdr.bdr_group_create(local_node_name := '$NODE_IP', node_external_dsn := 'port=5432 dbname=$DBNAME host=$NODE_IP');
SELECT bdr.bdr_node_join_wait_for_ready();
EOF
		fi
		su - postgres -c "/usr/lib/postgresql/9.4/bin/psql -d $DBNAME -f /SQLTMP.sql & " 
	fi

	rm -f /.first_run
	tail -f /dev/null
fi

# start postgres

su - postgres -c 'export LC_ALL=en_US.UTF-8 ; /usr/lib/postgresql/9.4/bin/postgres -D /var/lib/postgresql/9.4/main -c config_file=/etc/postgresql/9.4/main/postgresql.conf' &

sleep 30

if [ "x"$RANCHER_ENABLED == "x1" ];
then
	/rancher-listener.py
fi

tail -f /dev/null
