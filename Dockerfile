from ubuntu:16.04
copy bdr-repo.list /etc/apt/sources.list.d/bdr-repo.list.disable
copy maas.sql /maas.sql
run apt-get update && \
    apt-get install libterm-readline-perl-perl wget apt-utils python3-requests curl -y && \
    mv /etc/apt/sources.list.d/bdr-repo.list.disable /etc/apt/sources.list.d/bdr-repo.list && \
    wget --quiet -O - http://packages.2ndquadrant.com/bdr/apt/AA7A6805.asc | apt-key add - && \
    apt-get update && \
    apt-get install postgresql-bdr-9.4-bdr-plugin psmisc -y && \
    touch /.first_run && \
    sed -i 's/^# en_US.UTF-8/en_US.UTF-8/g' /etc/locale.gen && \ 
    locale-gen 
copy entrypoint.sh /entrypoint.sh
copy postgresql.conf /etc/postgresql/9.4/main/postgresql.conf
copy join_node /usr/local/sbin/join_node
copy join_node.sh /usr/local/sbin/join_node.sh
copy create_ext.sh /usr/local/sbin/create_ext.sh
copy create_bdr.sh /usr/local/sbin/create_bdr.sh
copy rancher-listener.py /rancher-listener.py
copy remove_ext.sh /usr/local/sbin/remove_ext.sh
copy clean_up.sh /usr/local/sbin/clean_up.sh
expose 5432
env MAX_CONNECTIONS=100 MAX_WAL_SENDERS=10 MAX_REPLICATION_SLOTS=10 MAX_WORKER_PROCESSES=10 ENABLE_LOGGING=y LOG_ERROR_VERBOSITY=verbose LOG_MIN_MESSAGES=debug1 LOG_LINE_PREFIX='%t [%p-%l] %q%u@%d ' ENABLE_CONFLICT_OPTIONS=y DEFAULT_APPLY_DELAY=2000 LOG_CONFLICTS_TO_TABLE=on DBNAME=maasdb DBUSER=maas DBPASS= DBAPASS=Admin123! DOCKER_IP=172.17.0.1/16 FIRST_NODE=y CLUSTER_CIDR=192.168.122.0/24 IMPORT_DBDATA_LOCATION= IMPORT_DBDATA=n RANCHER_CLEANUP_TIME=60
entrypoint /entrypoint.sh 
