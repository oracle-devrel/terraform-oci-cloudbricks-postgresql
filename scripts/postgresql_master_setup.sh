# Copyright (c) 2021 Oracle and/or its affiliates.
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

#!/bin/bash

export pg_version='${pg_version}'
export DATA_DIR="/u01/data"

sudo systemctl status postgresql

# Change password of postgres user
echo "postgres:${pg_password}" | chpasswd

# Setting firewall rules
sudo systemctl stop firewalld
sudo systemctl disable firewalld
sudo systemctl mask --now firewalld

# Update the content of postgresql.conf to support WAL
sudo -u root bash -c "echo 'wal_level = replica' | sudo tee -a $DATA_DIR/postgresql.conf"
sudo -u root bash -c "echo 'archive_mode = on' | sudo tee -a $DATA_DIR/postgresql.conf"
sudo -u root bash -c "echo 'wal_log_hints = on' | sudo tee -a $DATA_DIR/postgresql.conf"
sudo -u root bash -c "echo 'max_wal_senders = 3' | sudo tee -a $DATA_DIR/postgresql.conf"
if [[ $pg_version == "13" || $pg_version == "14" ]]; then 
	sudo -u root bash -c "echo 'wal_keep_size = 16MB' | sudo tee -a $DATA_DIR/postgresql.conf"
else
	sudo -u root bash -c "echo 'wal_keep_segments = 8' | sudo tee -a $DATA_DIR/postgresql.conf"
fi
sudo -u root bash -c "echo 'hot_standby = on' | sudo tee -a $DATA_DIR/postgresql.conf"
sudo -u root bash -c "echo 'listen_addresses = '\''0.0.0.0'\'' ' | sudo tee -a $DATA_DIR/postgresql.conf"
sudo -u root bash -c "chown postgres $DATA_DIR/postgresql.conf"

# Update the content of pg_hba to include standby host for replication
sudo -u root bash -c "echo 'host replication ${pg_replicat_username} ${pg_hotstandby_ip}/32 md5' | sudo tee -a $DATA_DIR/pg_hba.conf" 
sudo -u root bash -c "echo 'host replication ${pg_replicat_username} ${pg_master_ip}/32 md5' | sudo tee -a $DATA_DIR/pg_hba.conf" 
sudo -u root bash -c "echo 'host all all ${pg_hotstandby_ip}/32 md5' | sudo tee -a $DATA_DIR/pg_hba.conf" 
sudo -u root bash -c "echo 'host all all ${pg_master_ip}/32 md5' | sudo tee -a $DATA_DIR/pg_hba.conf" 

sudo -u root bash -c "chown postgres $DATA_DIR/pg_hba.conf" 

# Restart of PostrgreSQL service
sudo systemctl stop postgresql
sudo systemctl start postgresql
sudo systemctl status postgresql

# Create replication user
chown postgres /tmp/postgresql_master_setup.sql
sudo -u postgres bash -c "psql -d template1 -f /tmp/postgresql_master_setup.sql"
