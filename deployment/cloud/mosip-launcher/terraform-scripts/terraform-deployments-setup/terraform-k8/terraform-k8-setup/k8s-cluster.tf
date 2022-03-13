provider "azurerm" {
    version = "~>1.4"
}
resource "azurerm_kubernetes_cluster" "k8s" {
  name                = "${var.cluster_name}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
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
    vnet_subnet_id  = "${var.vnet_subnet_id}"
  }
    network_profile {
    network_plugin     = "azure"
    service_cidr       = "11.0.0.0/16"
    dns_service_ip     = "11.0.0.10"
    docker_bridge_cidr = "172.17.0.1/16"
  }

  service_principal {
    client_id     = "${var.client_id}"
    client_secret = "${var.client_secret}"
  }


  tags {
    Environment = "${var.environment}"
  }
}

resource "local_file" "k8_deployment_config" {
    content     = "${azurerm_kubernetes_cluster.k8s.kube_config_raw}"
    filename = "${pathexpand("${format("~/k8_deployment_config_%s.yaml", var.environment)}")}"
}
resource "local_file" "k8_deployment_node_resource_group" {
    content     = "${azurerm_kubernetes_cluster.k8s.node_resource_group}"
    filename = "${pathexpand("${format("~/k8_deployment_node_resource_group_%s.txt", var.environment)}")}"
    
}