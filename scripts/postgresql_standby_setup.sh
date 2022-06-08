# Copyright (c) 2021 Oracle and/or its affiliates.
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

#!/bin/bash

export pg_version='${pg_version}'
export DATA_DIR="/u01/data"

sudo mkdir -p /u01/data
sudo chown -R postgres:postgres /u01

sudo tee /etc/systemd/system/postgresql.service > /dev/null <<'EOF'
.include /usr/lib/systemd/system/postgresql-${pg_version}.service
[Service]
# Location of database directory
Environment=PGDATA=/u01/data
Environment=PGLOG=/u01/data/pgstartup.log
Restart=always
RestartSec=3
EOF

# Change password of postgres user
sudo -u root bash -c "echo postgres:${pg_replicat_password} | chpasswd"

# Setting firewall rules
sudo systemctl stop firewalld
sudo systemctl disable firewalld
sudo systemctl mask --now firewalld

# Take initial backup of database
sudo -u root bash -c "rm -rf $DATA_DIR/*"

sudo su - postgres -c "export PGPASSWORD=${pg_replicat_password}; /usr/pgsql-${pg_version}/bin/pg_basebackup -D $DATA_DIR/ -h ${pg_master_ip} -X stream -c fast -U ${pg_replicat_username}"



# Update the content of recovery.conf
if [[ $pg_version == "13" || $pg_version == "14" ]]; then 
	touch $DATA_DIR/standby.signal
	touch $DATA_DIR/recovery.signal
	sudo -u root bash -c "echo 'primary_conninfo  = '\''host=${pg_master_ip} port=5432 user=${pg_replicat_username} password=${pg_replicat_password}'\'' ' | sudo tee -a $DATA_DIR/postgresql.conf"
    sudo -u root bash -c "echo 'recovery_target_timeline = '\''latest'\'' ' | sudo tee -a $DATA_DIR/postgresql.conf"
    sudo -u root bash -c "chown postgres $DATA_DIR/postgresql.conf"
elif [[ $pg_version == "12"  ]]; then
	touch $DATA_DIR/standby.signal
	touch $DATA_DIR/recovery.signal
	sudo -u root bash -c "echo 'primary_conninfo  = '\''host=${pg_master_ip} port=5432 user=${pg_replicat_username} password=${pg_replicat_password}'\'' ' | sudo tee -a $DATA_DIR/postgresql.conf"
    sudo -u root bash -c "echo 'recovery_target_timeline = '\''latest'\'' ' | sudo tee -a $DATA_DIR/postgresql.conf"
    sudo -u root bash -c "chown postgres $DATA_DIR/postgresql.conf"
else
	sudo -u root bash -c "echo 'standby_mode = '\''on'\'' ' | sudo tee -a $DATA_DIR/recovery.conf" 
    sudo -u root bash -c "echo 'primary_conninfo  = '\''host=${pg_master_ip} port=5432 user=${pg_replicat_username} password=${pg_replicat_password}'\'' ' | sudo tee -a $DATA_DIR/recovery.conf"
    sudo -u root bash -c "echo 'recovery_target_timeline = '\''latest'\'' ' | sudo tee -a $DATA_DIR/recovery.conf"
    sudo -u root bash -c "chown postgres $DATA_DIR/recovery.conf"
fi

if [[ $pg_version == "13" || $pg_version == "14" ]]; then 
  sudo chmod -R 750 /u01
else 
  sudo chmod -R 700 /u01
fi

# Restart of PostrgreSQL service
sudo systemctl enable postgresql
sudo systemctl stop postgresql
sudo systemctl start postgresql
sudo systemctl status postgresql
