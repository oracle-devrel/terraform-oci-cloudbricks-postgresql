# Copyright (c) 2021 Oracle and/or its affiliates.
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl
# remote.tf
#
# Purpose: The following script remotely executes all the setup scripts on the PostgreSQL compute instances


data "template_file" "postgresql_install_binaries_sh" {
  template = file("scripts/postgresql_install_binaries.sh")

  vars = {
    pg_password       = var.postgresql_password
    pg_version_no_dot = replace(var.postgresql_version, ".", "")
    pg_version        = var.postgresql_version
  }
}

data "template_file" "postgresql_master_initdb_sh" {
  template = file("scripts/postgresql_master_initdb.sh")

  vars = {
    pg_password       = var.postgresql_password
    pg_version_no_dot = replace(var.postgresql_version, ".", "")
    pg_version        = var.postgresql_version
  }
}

data "template_file" "postgresql_master_setup_sql" {
  template = file("scripts/postgresql_master_setup.sql")

  vars = {
    pg_replicat_username = var.postgresql_replicat_username
    pg_replicat_password = var.postgresql_password
  }
}

data "template_file" "postgresql_master_setup_sh" {
  count    = var.postgresql_deploy_hotstandby1 ? 1 : 0
  template = file("scripts/postgresql_master_setup.sh")

  vars = {
    pg_master_ip         = data.oci_core_vnic.postgresql_master_primaryvnic.private_ip_address
    pg_hotstandby_ip     = element(data.oci_core_vnic.postgresql_hotstandby1_primaryvnic.*.private_ip_address, 0)
    pg_password          = var.postgresql_password
    pg_version_no_dot    = replace(var.postgresql_version, ".", "")
    pg_version           = var.postgresql_version
    pg_replicat_username = var.postgresql_replicat_username
  }
}

data "template_file" "postgresql_master_setup2_sh" {
  count    = var.postgresql_deploy_hotstandby2 ? 1 : 0
  template = file("scripts/postgresql_master_setup2.sh")

  vars = {
    pg_master_ip         = data.oci_core_vnic.postgresql_master_primaryvnic.private_ip_address
    pg_hotstandby_ip     = element(data.oci_core_vnic.postgresql_hotstandby2_primaryvnic.*.private_ip_address, 0)
    pg_version           = var.postgresql_version
    pg_replicat_username = var.postgresql_replicat_username
  }
}

data "template_file" "postgresql_standby_setup_sh" {
  count    = var.postgresql_deploy_hotstandby1 ? 1 : 0
  template = file("scripts/postgresql_standby_setup.sh")

  vars = {
    pg_master_ip         = data.oci_core_vnic.postgresql_master_primaryvnic.private_ip_address
    pg_hotstandby_ip     = element(data.oci_core_vnic.postgresql_hotstandby1_primaryvnic.*.private_ip_address, 0)
    pg_password          = var.postgresql_password
    pg_version_no_dot    = replace(var.postgresql_version, ".", "")
    pg_version           = var.postgresql_version
    pg_replicat_username = var.postgresql_replicat_username
    pg_replicat_password = var.postgresql_password
  }
}

resource "null_resource" "postgresql_master_install_binaries" {
  depends_on = [oci_core_instance.postgresql_master,
    null_resource.provisioning_disk_master,
    null_resource.partition_disk_master,
    null_resource.pvcreate_exec_master,
    null_resource.vgcreate_exec_master,
    null_resource.format_disk_exec_master,
    null_resource.mount_disk_exec_master
  ]

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.postgresql_master_primaryvnic.private_ip_address
      private_key = file(var.ssh_private_key)

    }
    inline = [
      "sudo rm -rf ~/postgresql_install_binaries.sh"
    ]
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.postgresql_master_primaryvnic.private_ip_address
      private_key = file(var.ssh_private_key)

    }

    content     = data.template_file.postgresql_install_binaries_sh.rendered
    destination = "~/postgresql_install_binaries.sh"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.postgresql_master_primaryvnic.private_ip_address
      private_key = file(var.ssh_private_key)

    }
    inline = [
      "chmod +x ~/postgresql_install_binaries.sh",
      "sudo ~/postgresql_install_binaries.sh"
    ]
  }
}

resource "null_resource" "postgresql_master_initdb" {
  depends_on = [null_resource.postgresql_master_install_binaries]

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.postgresql_master_primaryvnic.private_ip_address
      private_key = file(var.ssh_private_key)

    }
    inline = [
      "sudo rm -rf ~/postgresql_master_initdb.sh"
    ]
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.postgresql_master_primaryvnic.private_ip_address
      private_key = file(var.ssh_private_key)

    }

    content     = data.template_file.postgresql_master_initdb_sh.rendered
    destination = "~/postgresql_master_initdb.sh"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.postgresql_master_primaryvnic.private_ip_address
      private_key = file(var.ssh_private_key)

    }
    inline = [
      "chmod +x ~/postgresql_master_initdb.sh",
      "sudo ~/postgresql_master_initdb.sh"
    ]
  }
}

resource "null_resource" "postgresql_hotstandby1_install_binaries" {
  count = var.postgresql_deploy_hotstandby1 ? 1 : 0
  depends_on = [oci_core_instance.postgresql_master,
    oci_core_instance.postgresql_hotstandby1,
    null_resource.provisioning_disk_hotstandby1,
    null_resource.partition_disk_hotstandby1,
    null_resource.pvcreate_exec_hotstandby1,
    null_resource.vgcreate_exec_hotstandby1,
    null_resource.format_disk_exec_hotstandby1,
    null_resource.mount_disk_exec_hotstandby1
  ]

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.postgresql_hotstandby1_primaryvnic[count.index].private_ip_address
      private_key = file(var.ssh_private_key)

    }
    inline = [
      "sudo rm -rf ~/postgresql_install_binaries.sh"
    ]
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.postgresql_hotstandby1_primaryvnic[count.index].private_ip_address
      private_key = file(var.ssh_private_key)

    }

    content     = data.template_file.postgresql_install_binaries_sh.rendered
    destination = "~/postgresql_install_binaries.sh"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.postgresql_hotstandby1_primaryvnic[count.index].private_ip_address
      private_key = file(var.ssh_private_key)

    }
    inline = [
      "chmod +x ~/postgresql_install_binaries.sh",
      "sudo ~/postgresql_install_binaries.sh"
    ]
  }
}

resource "null_resource" "postgresql_hotstandby2_install_binaries" {
  count = var.postgresql_deploy_hotstandby2 ? 1 : 0
  depends_on = [oci_core_instance.postgresql_master,
    oci_core_instance.postgresql_hotstandby2,
    null_resource.provisioning_disk_hotstandby2,
    null_resource.partition_disk_hotstandby2,
    null_resource.pvcreate_exec_hotstandby2,
    null_resource.vgcreate_exec_hotstandby2,
    null_resource.format_disk_exec_hotstandby2,
    null_resource.mount_disk_exec_hotstandby2
  ]

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.postgresql_hotstandby2_primaryvnic[count.index].private_ip_address
      private_key = file(var.ssh_private_key)

    }
    inline = [
      "sudo rm -rf ~/postgresql_install_binaries.sh"
    ]
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.postgresql_hotstandby2_primaryvnic[count.index].private_ip_address
      private_key = file(var.ssh_private_key)

    }

    content     = data.template_file.postgresql_install_binaries_sh.rendered
    destination = "~/postgresql_install_binaries.sh"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.postgresql_hotstandby2_primaryvnic[count.index].private_ip_address
      private_key = file(var.ssh_private_key)

    }
    inline = [
      "chmod +x ~/postgresql_install_binaries.sh",
      "sudo ~/postgresql_install_binaries.sh"
    ]
  }
}


resource "null_resource" "postgresql_master_setup" {
  count      = var.postgresql_deploy_hotstandby1 ? 1 : 0
  depends_on = [null_resource.postgresql_master_initdb, null_resource.postgresql_hotstandby1_install_binaries]

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.postgresql_master_primaryvnic.private_ip_address
      private_key = file(var.ssh_private_key)

    }
    inline = [
      "sudo rm -rf ~/postgresql_master_setup.sh",
      "sudo rm -rf /tmp/postgresql_master_setup_sql",
    ]
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.postgresql_master_primaryvnic.private_ip_address
      private_key = file(var.ssh_private_key)

    }

    content     = element(data.template_file.postgresql_master_setup_sh.*.rendered, 0)
    destination = "~/postgresql_master_setup.sh"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.postgresql_master_primaryvnic.private_ip_address
      private_key = file(var.ssh_private_key)

    }

    content     = element(data.template_file.postgresql_master_setup_sql.*.rendered, 0)
    destination = "/tmp/postgresql_master_setup.sql"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.postgresql_master_primaryvnic.private_ip_address
      private_key = file(var.ssh_private_key)

    }
    inline = [
      "chmod +x ~/postgresql_master_setup.sh",
      "sudo ~/postgresql_master_setup.sh"
    ]
  }
}

resource "null_resource" "postgresql_master_setup2" {
  count      = var.postgresql_deploy_hotstandby2 ? 1 : 0
  depends_on = [null_resource.postgresql_master_initdb, null_resource.postgresql_hotstandby2_install_binaries]

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.postgresql_master_primaryvnic.private_ip_address
      private_key = file(var.ssh_private_key)

    }
    inline = [
      "sudo rm -rf ~/postgresql_master_setup2.sh",
    ]
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.postgresql_master_primaryvnic.private_ip_address
      private_key = file(var.ssh_private_key)

    }

    content     = element(data.template_file.postgresql_master_setup2_sh.*.rendered, 0)
    destination = "~/postgresql_master_setup2.sh"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.postgresql_master_primaryvnic.private_ip_address
      private_key = file(var.ssh_private_key)

    }
    inline = [
      "chmod +x ~/postgresql_master_setup2.sh",
      "sudo ~/postgresql_master_setup2.sh"
    ]
  }
}


resource "null_resource" "postgresql_hotstandby1_setup" {
  count      = var.postgresql_deploy_hotstandby1 ? 1 : 0
  depends_on = [null_resource.postgresql_master_setup, null_resource.postgresql_hotstandby1_install_binaries]

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.postgresql_hotstandby1_primaryvnic[count.index].private_ip_address
      private_key = file(var.ssh_private_key)

    }
    inline = [
      "sudo rm -rf ~/postgresql_standby_setup.sh",
    ]
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.postgresql_hotstandby1_primaryvnic[count.index].private_ip_address
      private_key = file(var.ssh_private_key)

    }

    content     = element(data.template_file.postgresql_standby_setup_sh.*.rendered, 0)
    destination = "~/postgresql_standby_setup.sh"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.postgresql_hotstandby1_primaryvnic[count.index].private_ip_address
      private_key = file(var.ssh_private_key)

    }
    inline = [
      "chmod +x ~/postgresql_standby_setup.sh",
      "sudo ~/postgresql_standby_setup.sh"
    ]
  }
}

resource "null_resource" "postgresql_hotstandby2_setup" {
  count      = var.postgresql_deploy_hotstandby2 ? 1 : 0
  depends_on = [null_resource.postgresql_master_setup2, null_resource.postgresql_hotstandby1_setup, null_resource.postgresql_hotstandby2_install_binaries]

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.postgresql_hotstandby2_primaryvnic[count.index].private_ip_address
      private_key = file(var.ssh_private_key)

    }
    inline = [
      "sudo rm -rf ~/postgresql_standby_setup.sh",
    ]
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.postgresql_hotstandby2_primaryvnic[count.index].private_ip_address
      private_key = file(var.ssh_private_key)

    }

    content     = element(data.template_file.postgresql_standby_setup_sh.*.rendered, 0)
    destination = "~/postgresql_standby_setup.sh"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_core_vnic.postgresql_hotstandby2_primaryvnic[count.index].private_ip_address
      private_key = file(var.ssh_private_key)

    }
    inline = [
      "chmod +x ~/postgresql_standby_setup.sh",
      "sudo ~/postgresql_standby_setup.sh"
    ]
  }
}
