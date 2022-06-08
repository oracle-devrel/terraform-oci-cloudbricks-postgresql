# Copyright (c) 2021 Oracle and/or its affiliates.
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

#!/bin/bash

export pg_version='${pg_version}'
export DATA_DIR="/u01/data"

# Setting firewall rules
sudo systemctl stop firewalld
sudo systemctl disable firewalld
sudo systemctl mask --now firewalld

# Update the content of pg_hba to include standby host for replication
sudo -u root bash -c "echo 'host replication ${pg_replicat_username} ${pg_hotstandby_ip}/32 md5' | sudo tee -a $DATA_DIR/pg_hba.conf" 
sudo -u root bash -c "echo 'host all all ${pg_hotstandby_ip}/32 md5' | sudo tee -a $DATA_DIR/pg_hba.conf" 
sudo -u root bash -c "chown postgres $DATA_DIR/pg_hba.conf" 

# Restart of PostrgreSQL service
sudo systemctl stop postgresql
sudo systemctl start postgresql
sudo systemctl status postgresql
