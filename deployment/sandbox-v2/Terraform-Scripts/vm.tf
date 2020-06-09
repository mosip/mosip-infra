resource "azurerm_linux_virtual_machine" "myterraformvm" {
  #    count              = 2
  name                = "console"
  location            = "southindia"
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  #    network_interface_ids = [element(azurerm_network_interface.myterraformnic.*.id, count.index)]
  network_interface_ids = [azurerm_network_interface.myterraformnic.id]

  #network_interface_ids = azurerm_network_interface.myterraformnic[count.index]
  size           = "Basic_A2"
  computer_name  = "console"
  admin_username = "mosipuser"
  admin_password = "Null"

  provisioner "file" {
    source      = "./script-for-console.sh"
    destination = "/tmp/script-for-console.sh"

    connection {
      type     = "ssh"
      user     = "mosipuser"
      password = "Null"
      host     = "test-machine.southindia.cloudapp.azure.com"
    }
  } 
  
   provisioner "remote-exec" {
    inline = [
       "chmod +x /tmp/script-for-console.sh",
       "/tmp/script-for-console.sh args",
   ]
    connection {
      type     = "ssh"
      user     = "mosipuser"
      password = "Null"
      host     = "test-machine.southindia.cloudapp.azure.com"
    }
  }
 
   os_disk {
    name                 = "console-OsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
   }

  source_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7.7"
    version   = "latest"
  }

  disable_password_authentication = false

  admin_ssh_key {
    username   = "mosipuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  tags = {
    environment = "testing"
  }


}

#---

resource "azurerm_linux_virtual_machine" "myterraformvm1" {
  #    count              = 2
  name                = "mzmaster"
  location            = "southindia"
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  #    network_interface_ids = [element(azurerm_network_interface.myterraformnic.*.id, count.index)]
  network_interface_ids = [azurerm_network_interface.myterraformnic1.id]

  #network_interface_ids = azurerm_network_interface.myterraformnic[count.index]
  size           = "Basic_A2"
  computer_name  = "mzmaster"
  admin_username = "mosipuser"
  admin_password = "Null"

  provisioner "file" {
    source      = "./script-for-master-nodes.sh"
    destination = "/tmp/script-for-master-nodes.sh"

    connection {
      type     = "ssh"
      user     = "mosipuser"
      password = "Null"
      host     = "mzmaster.southindia.cloudapp.azure.com"
    }
  }

   provisioner "remote-exec" {
    inline = [
       "chmod +x /tmp/script-for-master-nodes.sh",
       "/tmp/script-for-master-nodes.sh args",
   ]
    connection {
      type     = "ssh"
      user     = "mosipuser"
      password = "Null"
      host     = "mzmaster.southindia.cloudapp.azure.com"
    }
  }

  os_disk {
    name                 = "mzmaster-OsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7.7"
    version   = "latest"
  }

  disable_password_authentication = false

  admin_ssh_key {
    username   = "mosipuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  #    boot_diagnostics {
  #       storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
  #  }
  #     count = var.confignode_count

  tags = {
    environment = "testing"
  }
}

#---

resource "azurerm_linux_virtual_machine" "myterraformvm2" {
  #    count              = 2
  name                = "dmzmaster"
  location            = "southindia"
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  #    network_interface_ids = [element(azurerm_network_interface.myterraformnic.*.id, count.index)]
  network_interface_ids = [azurerm_network_interface.myterraformnic2.id]

  #network_interface_ids = azurerm_network_interface.myterraformnic[count.index]
  size           = "Basic_A2"
  computer_name  = "dmzmaster"
  admin_username = "mosipuser"
  admin_password = "Null"

  provisioner "file" {
    source      = "./script-for-master-nodes.sh"
    destination = "/tmp/script-for-master-nodes.sh"

    connection {
      type     = "ssh"
      user     = "mosipuser"
      password = "Null"
      host     = "dmzmaster.southindia.cloudapp.azure.com"
    }
  }

   provisioner "remote-exec" {
    inline = [
       "chmod +x /tmp/script-for-master-nodes.sh",
       "/tmp/script-for-master-nodes.sh args",
   ]
    connection {
      type     = "ssh"
      user     = "mosipuser"
      password = "Null"
      host     = "dmzmaster.southindia.cloudapp.azure.com"
    }
  }


  os_disk {
    name                 = "dmzmaster-OsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7.7"
    version   = "latest"
  }

  disable_password_authentication = false

  admin_ssh_key {
    username   = "mosipuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  #    boot_diagnostics {
  #       storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
  #  }
  #     count = var.confignode_count

  tags = {
    environment = "testing"
  }
}

#---
resource "azurerm_linux_virtual_machine" "myterraformvm3" {
  #    count              = 2
  name                = "dmzworker0"
  location            = "southindia"
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  #    network_interface_ids = [element(azurerm_network_interface.myterraformnic.*.id, count.index)]
  network_interface_ids = [azurerm_network_interface.myterraformnic3.id]

  #network_interface_ids = azurerm_network_interface.myterraformnic[count.index]
  size           = "Standard_D4_v3"
  computer_name  = "dmzworker0"
  admin_username = "mosipuser"
  admin_password = "Null"

  provisioner "file" {
    source      = "./script-for-master-nodes.sh"
    destination = "/tmp/script-for-master-nodes.sh"

    connection {
      type     = "ssh"
      user     = "mosipuser"
      password = "Null"
      host     = "dmzworker0.southindia.cloudapp.azure.com"
    }
  }

   provisioner "remote-exec" {
    inline = [
       "chmod +x /tmp/script-for-master-nodes.sh",
       "/tmp/script-for-master-nodes.sh args",
   ]
    connection {
      type     = "ssh"
      user     = "mosipuser"
      password = "Null"
      host     = "dmzworker0.southindia.cloudapp.azure.com"
    }
  }


  os_disk {
    name                 = "dmzworker0-OsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7.7"
    version   = "latest"
  }

  disable_password_authentication = false

  admin_ssh_key {
    username   = "mosipuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  #    boot_diagnostics {
  #       storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
  #  }
  #     count = var.confignode_count

  tags = {
    environment = "testing"
  }
}

#---

resource "azurerm_linux_virtual_machine" "myterraformvm4" {
  #    count              = 2
  name                = "mzworker0"
  location            = "southindia"
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  #    network_interface_ids = [element(azurerm_network_interface.myterraformnic.*.id, count.index)]
  network_interface_ids = [azurerm_network_interface.myterraformnic4.id]

  #network_interface_ids = azurerm_network_interface.myterraformnic[count.index]
  size           = "Standard_D4_v3"
  computer_name  = "mzworker0"
  admin_username = "mosipuser"
  admin_password = "Null"

  provisioner "file" {
    source      = "./script-for-master-nodes.sh"
    destination = "/tmp/script-for-master-nodes.sh"

    connection {
      type     = "ssh"
      user     = "mosipuser"
      password = "Null"
      host     = "mzworker0.southindia.cloudapp.azure.com"
    }
  }

   provisioner "remote-exec" {
    inline = [
       "chmod +x /tmp/script-for-master-nodes.sh",
       "/tmp/script-for-master-nodes.sh args",
   ]
    connection {
      type     = "ssh"
      user     = "mosipuser"
      password = "Null"
      host     = "mzworker0.southindia.cloudapp.azure.com"

    }
  }


  os_disk {
    name                 = "mzworker0-OsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7.7"
    version   = "latest"
  }

  disable_password_authentication = false

  admin_ssh_key {
    username   = "mosipuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  #    boot_diagnostics {
  #       storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
  #  }
  #     count = var.confignode_count

  tags = {
    environment = "testing"
  }
}

#------

resource "azurerm_linux_virtual_machine" "myterraformvm5" {
  #    count              = 2
  name                = "mzworker1"
  location            = "southindia"
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  #    network_interface_ids = [element(azurerm_network_interface.myterraformnic.*.id, count.index)]
  network_interface_ids = [azurerm_network_interface.myterraformnic5.id]

  #network_interface_ids = azurerm_network_interface.myterraformnic[count.index]
  size           = "Standard_D4_v3"
  computer_name  = "mzworker1"
  admin_username = "mosipuser"
  admin_password = "Null"

  provisioner "file" {
    source      = "./script-for-master-nodes.sh"
    destination = "/tmp/script-for-master-nodes.sh"

    connection {
      type     = "ssh"
      user     = "mosipuser"
      password = "Null"
      host     = "mzworker1.southindia.cloudapp.azure.com"
    }
  }

   provisioner "remote-exec" {
    inline = [
       "chmod +x /tmp/script-for-master-nodes.sh",
       "/tmp/script-for-master-nodes.sh args",
   ]
    connection {
      type     = "ssh"
      user     = "mosipuser"
      password = "Null"
      host     = "mzworker1.southindia.cloudapp.azure.com"

    }
  }


  os_disk {
    name                 = "mzworker1-OsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7.7"
    version   = "latest"
  }

  disable_password_authentication = false

  admin_ssh_key {
    username   = "mosipuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  #    boot_diagnostics {
  #       storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
  #  }
  #     count = var.confignode_count

  tags = {
    environment = "testing"
  }
}

#---

resource "azurerm_linux_virtual_machine" "myterraformvm6" {
  #    count              = 2
  name                = "mzworker2"
  location            = "southindia"
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  #    network_interface_ids = [element(azurerm_network_interface.myterraformnic.*.id, count.index)]
  network_interface_ids = [azurerm_network_interface.myterraformnic6.id]

  #network_interface_ids = azurerm_network_interface.myterraformnic[count.index]
  size           = "Standard_D4_v3"
  computer_name  = "mzworker2"
  admin_username = "mosipuser"
  admin_password = "Null"

  provisioner "file" {
    source      = "./script-for-master-nodes.sh"
    destination = "/tmp/script-for-master-nodes.sh"

    connection {
      type     = "ssh"
      user     = "mosipuser"
      password = "Null"
      host     = "mzworker3.southindia.cloudapp.azure.com"
    }
  }

   provisioner "remote-exec" {
    inline = [
       "chmod +x /tmp/script-for-master-nodes.sh",
       "/tmp/script-for-master-nodes.sh args",
   ]
    connection {
      type     = "ssh"
      user     = "mosipuser"
      password = "Null"
      host     = "mzworker3.southindia.cloudapp.azure.com"

    }
  }


  os_disk {
    name                 = "mzworker2-OsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7.7"
    version   = "latest"
  }

  disable_password_authentication = false

  admin_ssh_key {
    username   = "mosipuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  #    boot_diagnostics {
  #       storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
  #  }
  #     count = var.confignode_count

  tags = {
    environment = "testing"
  }
}

