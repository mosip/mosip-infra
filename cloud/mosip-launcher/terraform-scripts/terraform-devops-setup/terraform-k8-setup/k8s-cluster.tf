provider "azurerm" {
    version = "~>1.4"
}
resource "azurerm_kubernetes_cluster" "k8s" {
  name                = "${var.cluster_name}"
  location            = "${azurerm_resource_group.k8s.location}"
  resource_group_name = "${azurerm_resource_group.k8s.name}"
  dns_prefix          = "${var.dns_prefix}"

  linux_profile {
    admin_username = "${var.admin_username}"

    ssh_key {
      key_data = "${file("${var.ssh_public_key}")}"
    }
  }

  agent_pool_profile {
    name            = "default"
    count           = "${var.agent_count}"
    vm_size         = "${var.vm_size}"
    os_type         = "${var.os_type}"
    os_disk_size_gb = "${var.os_disk_size_gb}"
  }

  service_principal {
    client_id     = "${var.client_id}"
    client_secret = "${var.client_secret}"
  }

  tags {
    Environment = "${var.environment}"
  }
}

resource "local_file" "k8_devops_config" {
    content     = "${azurerm_kubernetes_cluster.k8s.kube_config_raw}"
    filename = "${pathexpand("~/k8_devops_config.yaml")}"
}
resource "local_file" "k8_devops_node_resource_group" {
    content     = "${azurerm_kubernetes_cluster.k8s.node_resource_group}"
    filename = "${pathexpand("~/k8_devops_node_resource_group.txt")}"
}