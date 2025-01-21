# OCI Cloud Bricks: PostgreSQL

[![License: UPL](https://img.shields.io/badge/license-UPL-green)](https://img.shields.io/badge/license-UPL-green) [![Quality gate](https://sonarcloud.io/api/project_badges/quality_gate?project=oracle-devrel_terraform-oci-cloudbricks-postgresql)](https://sonarcloud.io/dashboard?id=oracle-devrel_terraform-oci-cloudbricks-postgresql)

## Introduction
The following brick contains the logic to provision a PostgreSQL database in a highly available architecture. This architecture makes use of up to 3 instance in a master and standby configuration with streaming replication.

This brick is only supported on Oracle Linux for the time being.

## Reference Architecture
The following is the reference architecture associated to this brick

![Reference Architecture](./images/Bricks_Architectures-postgresql.jpg)

### Prerequisites
- Pre-baked Artifact and Network Compartments
- Pre-baked VCN

# Sample tfvar file

If using hotstandby instances and fixed shapes.

```shell
######################################## COMMON VARIABLES ######################################
region           = "re-region-1"
tenancy_ocid     = "ocid1.tenancy.oc1..aaaaaaaabcedfghijklmonoprstuvwxyz"
user_ocid        = "ocid1.tenancy.oc1..aaaaaaaabcedfghijklmonoprstuvwxyz"
fingerprint      = "fo:oo:ba:ar:ba:ar"
private_key_path = "/absolute/path/to/api/key/your_api_key.pem"
######################################## COMMON VARIABLES ######################################
######################################## ARTIFACT SPECIFIC VARIABLES ######################################
ssh_public_key                          = "/absolute/path/to/api/key/your_ssh_public_key.pub"
ssh_private_key                         = "/absolute/path/to/api/key/your_ssh_private_key"
compute_nsg_name                        = "MY_NSG"
linux_compute_instance_compartment_name = "MY_ARTIFACT_COMPARTMENT"
linux_compute_network_compartment_name  = "MY_NETWORK_COMPARTMENT"
private_network_subnet_name             = "MY_PRIVATE_SUBNET"
vcn_display_name                        = "MY_VCN"

postgresql_replicat_username = "replicator"
postgresql_password          = "MY_DATABASE_PASSWORD"
postgresql_version           = "14"
database_size_in_gb          = "50"
database_vpus_per_gb         = "10"
database_backup_policy_level = "gold"
instance_backup_policy_level = "bronze"

postgresql_master_name          = "MY_MASTER_INSTANCE_NAME"
postgresql_master_ad            = "aBCD:RE-REGION-1-AD-1"
postgresql_master_fd            = "FAULT-DOMAIN-1"
postgresql_master_shape         = "VM.Standard2.2"

postgresql_hotstandby_is_flex_shape = false
postgresql_hotstandby_shape         = "VM.Standard2.1"

postgresql_deploy_hotstandby1 = true
postgresql_standyby1_name     = "MY_HOTSTANDBY1_INSTANCE_NAME"
postgresql_hotstandby1_ad     = "aBCD:RE-REGION-1-AD-2"
postgresql_hotstandby1_fd     = "FAULT-DOMAIN-1"

postgresql_deploy_hotstandby2 = true
postgresql_standyby2_name     = "MY_HOTSTANDBY2_INSTANCE_NAME"
postgresql_hotstandby2_ad     = "aBCD:RE-REGION-1-AD-3"
postgresql_hotstandby2_fd     = "FAULT-DOMAIN-1"
######################################## ARTIFACT SPECIFIC VARIABLES ######################################
```

If using hotstandby instances and flex shapes.

```shell
######################################## COMMON VARIABLES ######################################
region           = "re-region-1"
tenancy_ocid     = "ocid1.tenancy.oc1..aaaaaaaabcedfghijklmonoprstuvwxyz"
user_ocid        = "ocid1.tenancy.oc1..aaaaaaaabcedfghijklmonoprstuvwxyz"
fingerprint      = "fo:oo:ba:ar:ba:ar"
private_key_path = "/absolute/path/to/api/key/your_api_key.pem"
######################################## COMMON VARIABLES ######################################
######################################## ARTIFACT SPECIFIC VARIABLES ######################################
ssh_public_key                          = "/absolute/path/to/api/key/your_ssh_public_key.pub"
ssh_private_key                         = "/absolute/path/to/api/key/your_ssh_private_key"
compute_nsg_name                        = "MY_NSG"
linux_compute_instance_compartment_name = "MY_ARTIFACT_COMPARTMENT"
linux_compute_network_compartment_name  = "MY_NETWORK_COMPARTMENT"
private_network_subnet_name             = "MY_PRIVATE_SUBNET"
vcn_display_name                        = "MY_VCN"

postgresql_replicat_username = "replicator"
postgresql_password          = "MY_DATABASE_PASSWORD"
postgresql_version           = "14"
database_size_in_gb          = "50"
database_vpus_per_gb         = "10"
database_backup_policy_level = "gold"
instance_backup_policy_level = "bronze"

postgresql_master_name          = "MY_MASTER_INSTANCE_NAME"
postgresql_master_ad            = "aBCD:RE-REGION-1-AD-1"
postgresql_master_fd            = "FAULT-DOMAIN-1"
postgresql_master_is_flex_shape = true
postgresql_master_shape         = "VM.Standard.E3.Flex"
postgresql_master_ocpus         = "2"
postgresql_master_memory_in_gb  = "32"

postgresql_hotstandby_is_flex_shape = true
postgresql_hotstandby_shape         = "VM.Standard.E3.Flex"
postgresql_hotstandby_ocpus         = "1"
postgresql_hotstandby_memory_in_gb  = "16"

postgresql_deploy_hotstandby1 = true
postgresql_standyby1_name     = "MY_HOTSTANDBY1_INSTANCE_NAME"
postgresql_hotstandby1_ad     = "aBCD:RE-REGION-1-AD-2"
postgresql_hotstandby1_fd     = "FAULT-DOMAIN-1"

postgresql_deploy_hotstandby2 = true
postgresql_standyby2_name     = "MY_HOTSTANDBY2_INSTANCE_NAME"
postgresql_hotstandby2_ad     = "aBCD:RE-REGION-1-AD-3"
postgresql_hotstandby2_fd     = "FAULT-DOMAIN-1"
######################################## ARTIFACT SPECIFIC VARIABLES ######################################
```

If using just a master instance and fixed shapes.

```shell
######################################## COMMON VARIABLES ######################################
region           = "re-region-1"
tenancy_ocid     = "ocid1.tenancy.oc1..aaaaaaaabcedfghijklmonoprstuvwxyz"
user_ocid        = "ocid1.tenancy.oc1..aaaaaaaabcedfghijklmonoprstuvwxyz"
fingerprint      = "fo:oo:ba:ar:ba:ar"
private_key_path = "/absolute/path/to/api/key/your_api_key.pem"
######################################## COMMON VARIABLES ######################################
######################################## ARTIFACT SPECIFIC VARIABLES ######################################
ssh_public_key                          = "/absolute/path/to/api/key/your_ssh_public_key.pub"
ssh_private_key                         = "/absolute/path/to/api/key/your_ssh_private_key"
compute_nsg_name                        = "MY_NSG"
linux_compute_instance_compartment_name = "MY_ARTIFACT_COMPARTMENT"
linux_compute_network_compartment_name  = "MY_NETWORK_COMPARTMENT"
private_network_subnet_name             = "MY_PRIVATE_SUBNET"
vcn_display_name                        = "MY_VCN"

postgresql_password          = "MY_DATABASE_PASSWORD"
postgresql_version           = "14"
database_size_in_gb          = "50"
database_vpus_per_gb         = "10"
database_backup_policy_level = "gold"
instance_backup_policy_level = "bronze"

postgresql_master_name          = "MY_MASTER_INSTANCE_NAME"
postgresql_master_ad            = "aBCD:RE-REGION-1-AD-1"
postgresql_master_fd            = "FAULT-DOMAIN-1"
postgresql_master_shape         = "VM.Standard2.2"
######################################## ARTIFACT SPECIFIC VARIABLES ######################################
```

If using just a master instance and a flex shape.

```shell
######################################## COMMON VARIABLES ######################################
region           = "re-region-1"
tenancy_ocid     = "ocid1.tenancy.oc1..aaaaaaaabcedfghijklmonoprstuvwxyz"
user_ocid        = "ocid1.tenancy.oc1..aaaaaaaabcedfghijklmonoprstuvwxyz"
fingerprint      = "fo:oo:ba:ar:ba:ar"
private_key_path = "/absolute/path/to/api/key/your_api_key.pem"
######################################## COMMON VARIABLES ######################################
######################################## ARTIFACT SPECIFIC VARIABLES ######################################
ssh_public_key                          = "/absolute/path/to/api/key/your_ssh_public_key.pub"
ssh_private_key                         = "/absolute/path/to/api/key/your_ssh_private_key"
compute_nsg_name                        = "MY_NSG"
linux_compute_instance_compartment_name = "MY_ARTIFACT_COMPARTMENT"
linux_compute_network_compartment_name  = "MY_NETWORK_COMPARTMENT"
private_network_subnet_name             = "MY_PRIVATE_SUBNET"
vcn_display_name                        = "MY_VCN"

postgresql_password          = "MY_DATABASE_PASSWORD"
postgresql_version           = "14"
database_size_in_gb          = "50"
database_vpus_per_gb         = "10"
database_backup_policy_level = "gold"
instance_backup_policy_level = "bronze"

postgresql_master_name          = "MY_MASTER_INSTANCE_NAME"
postgresql_master_ad            = "aBCD:RE-REGION-1-AD-1"
postgresql_master_fd            = "FAULT-DOMAIN-1"
postgresql_master_is_flex_shape = true
postgresql_master_shape         = "VM.Standard.E3.Flex"
postgresql_master_ocpus         = "2"
postgresql_master_memory_in_gb  = "32"
######################################## ARTIFACT SPECIFIC VARIABLES ######################################
```

### Variable Specific Conisderions
- Compute ssh keys to later log into instances. Paths to the keys should be provided in variables `ssh_public_key` and `ssh_private_key`.
- Variable `compute_nsg_name` is an optional network security group that can be attached.
- Variable `postgresql_replicat_username` is used as a login name to setup replication. This doesn't need to be supplied in a master only configuration.
- Variable `postgresql_version` can be any of the supported version of PostgreSQL at the time of making this brick (`11`, `12`, `13` and `14`).
- Variable `database_size_in_gb` is the size of the attached ISCSI disks to store the PostgreSQL database on. This can be between `50` and `32768`.
- Variable `database_vpus_per_gb` is the number of volume performance units to be applied to the attached ISCSI disks. The value must be between `0` and `120` and be multiple of 10.
- Variable `database_backup_policy_level` specifies the name of the backup policy used on the attached database ISCSI disks.
- Variable `instance_backup_policy_level` specifies the name of the backup policy used on the instance boot volumes.
- Flex Shapes:
  - Variable `postgresql_master_is_flex_shape` should be defined as true when the master instance is a flex shape. The variables `postgresql_master_ocpus` and `postgresql_master_memory_in_gb` should then also be defined. Do not use any of these variables at all when using a standard shape as they are not needed and assume sensible defaults.
  - Variable `postgresql_hotstandby_is_flex_shape` should be defined as true when the standby instances are a flex shape. The variables `postgresql_hotstandby_ocpus` and `postgresql_hotstandby_memory_in_gb` should then also be defined. Do not use any of these variables at all when using a standard shape as they are not needed and assume sensible defaults.
- Standby Instances:
  - Variable `postgresql_deploy_hotstandby1` should be defined as true when a hotstandby1 is needed. The variables `postgresql_standyby1_name`, `postgresql_hotstandby1_ad` and `postgresql_hotstandby1_fd` then should also be defined.
  - Variable `postgresql_deploy_hotstandby2` should be defined as true when a hotstandby2 is needed. The variables `postgresql_standyby2_name`, `postgresql_hotstandby2_ad` and `postgresql_hotstandby2_fd` then should also be defined.

### Sample provider
The following is the base provider definition to be used with this module

```shell
terraform {
  required_version = ">= 0.13.5"
}
provider "oci" {
  region       = var.region
  tenancy_ocid = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  disable_auto_retries = "true"
}

provider "oci" {
  alias        = "home"
  region       = data.oci_identity_region_subscriptions.home_region_subscriptions.region_subscriptions[0].region_name
  tenancy_ocid = var.tenancy_ocid  
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  disable_auto_retries = "true"
}
```

## Variable documentation

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_null"></a> [null](#provider\_null) | 3.1.0 |
| <a name="provider_oci"></a> [oci](#provider\_oci) | 4.46.0 |
| <a name="provider_template"></a> [template](#provider\_template) | 2.2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [null_resource.format_disk_exec_hotstandby1](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.format_disk_exec_hotstandby2](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.format_disk_exec_master](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.mount_disk_exec_hotstandby1](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.mount_disk_exec_hotstandby2](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.mount_disk_exec_master](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.partition_disk_hotstandby1](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.partition_disk_hotstandby2](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.partition_disk_master](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.postgresql_hotstandby1_install_binaries](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.postgresql_hotstandby1_setup](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.postgresql_hotstandby2_install_binaries](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.postgresql_hotstandby2_setup](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.postgresql_master_initdb](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.postgresql_master_install_binaries](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.postgresql_master_setup](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.postgresql_master_setup2](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.provisioning_disk_hotstandby1](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.provisioning_disk_hotstandby2](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.provisioning_disk_master](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.pvcreate_exec_hotstandby1](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.pvcreate_exec_hotstandby2](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.pvcreate_exec_master](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.vgcreate_exec_hotstandby1](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.vgcreate_exec_hotstandby2](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.vgcreate_exec_master](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [oci_core_instance.postgresql_hotstandby1](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_instance) | resource |
| [oci_core_instance.postgresql_hotstandby2](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_instance) | resource |
| [oci_core_instance.postgresql_master](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_instance) | resource |
| [oci_core_volume.ISCSIDisk_hotstandby1](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_volume) | resource |
| [oci_core_volume.ISCSIDisk_hotstandby2](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_volume) | resource |
| [oci_core_volume.ISCSIDisk_master](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_volume) | resource |
| [oci_core_volume_attachment.ISCSIDiskAttachment_hotstandby1](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_volume_attachment) | resource |
| [oci_core_volume_attachment.ISCSIDiskAttachment_hotstandby2](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_volume_attachment) | resource |
| [oci_core_volume_attachment.ISCSIDiskAttachment_master](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_volume_attachment) | resource |
| [oci_core_volume_backup_policy_assignment.backup_policy_assignment_ISCSI_Disk_hotstandby1](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_volume_backup_policy_assignment) | resource |
| [oci_core_volume_backup_policy_assignment.backup_policy_assignment_ISCSI_Disk_hotstandby2](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_volume_backup_policy_assignment) | resource |
| [oci_core_volume_backup_policy_assignment.backup_policy_assignment_ISCSI_Disk_master](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_volume_backup_policy_assignment) | resource |
| [oci_core_volume_backup_policy_assignment.backup_policy_assignment_postgresql_hotstandby1](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_volume_backup_policy_assignment) | resource |
| [oci_core_volume_backup_policy_assignment.backup_policy_assignment_postgresql_hotstandby2](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_volume_backup_policy_assignment) | resource |
| [oci_core_volume_backup_policy_assignment.backup_policy_assignment_postgresql_master](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_volume_backup_policy_assignment) | resource |
| [oci_core_images.ORACLELINUX](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/data-sources/core_images) | data source |
| [oci_core_network_security_groups.NSG](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/data-sources/core_network_security_groups) | data source |
| [oci_core_subnets.PRIVATESUBNET](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/data-sources/core_subnets) | data source |
| [oci_core_vcns.VCN](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/data-sources/core_vcns) | data source |
| [oci_core_volume_backup_policies.DATABASEBACKUPPOLICY](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/data-sources/core_volume_backup_policies) | data source |
| [oci_core_volume_backup_policies.INSTANCEBACKUPPOLICY](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/data-sources/core_volume_backup_policies) | data source |
| [oci_identity_compartments.COMPARTMENTS](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/data-sources/identity_compartments) | data source |
| [oci_identity_compartments.NWCOMPARTMENTS](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/data-sources/identity_compartments) | data source |
| [template_file.postgresql_install_binaries_sh](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.postgresql_master_initdb_sh](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.postgresql_master_setup2_sh](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.postgresql_master_setup_sh](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.postgresql_master_setup_sql](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.postgresql_standby_setup_sh](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_compute_nsg_name"></a> [compute\_nsg\_name](#input\_compute\_nsg\_name) | Name of the NSG associated to the compute | `string` | `""` | no |
| <a name="input_database_backup_policy_level"></a> [database\_backup\_policy\_level](#input\_database\_backup\_policy\_level) | Backup policy level for Database ISCSI disks | `any` | n/a | yes |
| <a name="input_database_size_in_gb"></a> [database\_size\_in\_gb](#input\_database\_size\_in\_gb) | Disk Capacity for Database | `any` | n/a | yes |
| <a name="input_database_vpus_per_gb"></a> [database\_vpus\_per\_gb](#input\_database\_vpus\_per\_gb) | Disk VPUS for the Database | `any` | n/a | yes |
| <a name="input_fingerprint"></a> [fingerprint](#input\_fingerprint) | API Key Fingerprint for user\_ocid derived from public API Key imported in OCI User config | `any` | n/a | yes |
| <a name="input_instance_backup_policy_level"></a> [instance\_backup\_policy\_level](#input\_instance\_backup\_policy\_level) | Backup policy level for instance boot volume disks | `any` | n/a | yes |
| <a name="input_instance_os"></a> [instance\_os](#input\_instance\_os) | Operating system for compute instances | `string` | `"Oracle Linux"` | no |
| <a name="input_linux_compute_instance_compartment_name"></a> [linux\_compute\_instance\_compartment\_name](#input\_linux\_compute\_instance\_compartment\_name) | Defines the compartment name where the infrastructure will be created | `any` | n/a | yes |
| <a name="input_linux_compute_network_compartment_name"></a> [linux\_compute\_network\_compartment\_name](#input\_linux\_compute\_network\_compartment\_name) | Defines the compartment where the Network is currently located | `any` | n/a | yes |
| <a name="input_linux_os_version"></a> [linux\_os\_version](#input\_linux\_os\_version) | Operating system version for all Linux instances | `string` | `"7.9"` | no |
| <a name="input_postgresql_deploy_hotstandby1"></a> [postgresql\_deploy\_hotstandby1](#input\_postgresql\_deploy\_hotstandby1) | Boolean to determine if to provision hotstandby1 | `bool` | `false` | no |
| <a name="input_postgresql_deploy_hotstandby2"></a> [postgresql\_deploy\_hotstandby2](#input\_postgresql\_deploy\_hotstandby2) | Boolean to determine if to provision hotstandby2 | `bool` | `false` | no |
| <a name="input_postgresql_hotstandby1_ad"></a> [postgresql\_hotstandby1\_ad](#input\_postgresql\_hotstandby1\_ad) | The availability domain to provision the hoststandby1 instance in | `string` | `""` | no |
| <a name="input_postgresql_hotstandby1_fd"></a> [postgresql\_hotstandby1\_fd](#input\_postgresql\_hotstandby1\_fd) | The fault domain to provision the hoststandby1 instance in | `string` | `""` | no |
| <a name="input_postgresql_hotstandby2_ad"></a> [postgresql\_hotstandby2\_ad](#input\_postgresql\_hotstandby2\_ad) | The availability domain to provision the hoststandby2 instance in | `string` | `""` | no |
| <a name="input_postgresql_hotstandby2_fd"></a> [postgresql\_hotstandby2\_fd](#input\_postgresql\_hotstandby2\_fd) | The fault domain to provision the hoststandby2 instance in | `string` | `""` | no |
| <a name="input_postgresql_hotstandby_is_flex_shape"></a> [postgresql\_hotstandby\_is\_flex\_shape](#input\_postgresql\_hotstandby\_is\_flex\_shape) | Boolean to determine if the standy instances are flex or not | `bool` | `false` | no |
| <a name="input_postgresql_hotstandby_memory_in_gb"></a> [postgresql\_hotstandby\_memory\_in\_gb](#input\_postgresql\_hotstandby\_memory\_in\_gb) | The amount of memory in GB for the standby instances to use when flex shape is enabled | `string` | `""` | no |
| <a name="input_postgresql_hotstandby_ocpus"></a> [postgresql\_hotstandby\_ocpus](#input\_postgresql\_hotstandby\_ocpus) | The number of OCPUS for the flex instances to use when flex shape is enabled | `string` | `""` | no |
| <a name="input_postgresql_hotstandby_shape"></a> [postgresql\_hotstandby\_shape](#input\_postgresql\_hotstandby\_shape) | The shape for the hotstandby instances to use | `string` | `""` | no |
| <a name="input_postgresql_master_ad"></a> [postgresql\_master\_ad](#input\_postgresql\_master\_ad) | The availability domain to provision the master instance in | `any` | n/a | yes |
| <a name="input_postgresql_master_fd"></a> [postgresql\_master\_fd](#input\_postgresql\_master\_fd) | The fault domain to provision the master instance in | `any` | n/a | yes |
| <a name="input_postgresql_master_is_flex_shape"></a> [postgresql\_master\_is\_flex\_shape](#input\_postgresql\_master\_is\_flex\_shape) | Boolean to determine if the master instance is flex or not | `bool` | `false` | no |
| <a name="input_postgresql_master_memory_in_gb"></a> [postgresql\_master\_memory\_in\_gb](#input\_postgresql\_master\_memory\_in\_gb) | The amount of memory in GB for the master instance to use when flex shape is enabled | `string` | `""` | no |
| <a name="input_postgresql_master_name"></a> [postgresql\_master\_name](#input\_postgresql\_master\_name) | The name given to the master instance | `any` | n/a | yes |
| <a name="input_postgresql_master_ocpus"></a> [postgresql\_master\_ocpus](#input\_postgresql\_master\_ocpus) | The number of OCPUS for the master instance to use when flex shape is enabled | `string` | `""` | no |
| <a name="input_postgresql_master_shape"></a> [postgresql\_master\_shape](#input\_postgresql\_master\_shape) | The shape for the master instance to use | `any` | n/a | yes |
| <a name="input_postgresql_password"></a> [postgresql\_password](#input\_postgresql\_password) | The password used in setup of the PostgreSQL database | `any` | n/a | yes |
| <a name="input_postgresql_replicat_username"></a> [postgresql\_replicat\_username](#input\_postgresql\_replicat\_username) | The username used in setup of PostgreSQL replication | `string` | `"replicator"` | no |
| <a name="input_postgresql_standyby1_name"></a> [postgresql\_standyby1\_name](#input\_postgresql\_standyby1\_name) | The name given to the standby1 instance | `string` | `""` | no |
| <a name="input_postgresql_standyby2_name"></a> [postgresql\_standyby2\_name](#input\_postgresql\_standyby2\_name) | The name given to the standby2 instance | `string` | `""` | no |
| <a name="input_postgresql_version"></a> [postgresql\_version](#input\_postgresql\_version) | The version of PostgreSQL used in the setup | `any` | n/a | yes |
| <a name="input_private_key_path"></a> [private\_key\_path](#input\_private\_key\_path) | Private Key Absolute path location where terraform is executed | `any` | n/a | yes |
| <a name="input_private_network_subnet_name"></a> [private\_network\_subnet\_name](#input\_private\_network\_subnet\_name) | Defines the subnet display name where this resource will be created at | `any` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Target region where artifacts are going to be created | `any` | n/a | yes |
| <a name="input_ssh_private_key"></a> [ssh\_private\_key](#input\_ssh\_private\_key) | Defines SSH Private Key to be used in order to remotely connect to compute instances | `any` | n/a | yes |
| <a name="input_ssh_public_key"></a> [ssh\_public\_key](#input\_ssh\_public\_key) | Defines SSH Public Key to be used in order to remotely connect to compute instances | `any` | n/a | yes |
| <a name="input_tenancy_ocid"></a> [tenancy\_ocid](#input\_tenancy\_ocid) | OCID of tenancy | `any` | n/a | yes |
| <a name="input_user_ocid"></a> [user\_ocid](#input\_user\_ocid) | User OCID in tenancy. Currently hardcoded to user denny.alquinta@oracle.com | `any` | n/a | yes |
| <a name="input_vcn_display_name"></a> [vcn\_display\_name](#input\_vcn\_display\_name) | VCN Display name to execute lookup | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_PostgreSQL_Master"></a> [PostgreSQL\_Master](#output\_PostgreSQL\_Master) | PostgreSQL Master Instance |
| <a name="output_PostgreSQL_Username"></a> [PostgreSQL\_Username](#output\_PostgreSQL\_Username) | n/a |

## Contributing
This project is open source.  Please submit your contributions by forking this repository and submitting a pull request!  Oracle appreciates any contributions that are made by the open source community.

## License
Copyright (c) 2024 Oracle and/or its affiliates.

Licensed under the Universal Permissive License (UPL), Version 1.0.

See [LICENSE](LICENSE.txt) for more details.
