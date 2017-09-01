#!/bin/bash

if [ -f /run/lock/postgre-ext.lock ]; then exit ; fi
echo "CREATE EXTENSION btree_gist; CREATE EXTENSION bdr" | su - postgres -c '/usr/lib/postgresql/9.4/bin/psql -d '$1
touch /run/lock/postgre-ext.lock
