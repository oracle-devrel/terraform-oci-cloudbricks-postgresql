# Copyright (c) 2021 Oracle and/or its affiliates.
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

#!/bin/bash

export pg_version='${pg_version}'
export DATA_DIR="/u01/data"

sudo mkdir -p /u01/data
sudo chown -R postgres:postgres /u01

sudo tee -a /etc/systemd/system/postgresql.service > /dev/null <<'EOF'
.include /usr/lib/systemd/system/postgresql-${pg_version}.service
[Service]
# Location of database directory
Environment=PGDATA=/u01/data
Environment=PGLOG=/u01/data/pgstartup.log
Restart=always
RestartSec=3
EOF

# Optionally initialize the database and enable automatic start:
sudo su - postgres -c  "/usr/pgsql-${pg_version}/bin/initdb -D $DATA_DIR"
sudo semanage fcontext -a -t postgresql_db_t "/u01/data(/.*)?"
sudo restorecon -R -v /u01/data

sudo systemctl enable postgresql
sudo systemctl start postgresql
sudo systemctl status postgresql

sudo -u root bash -c "tail -5 /u01/data/log/postgresql-*.log"
