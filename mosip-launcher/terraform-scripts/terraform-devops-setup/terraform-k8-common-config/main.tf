provider "helm" {
  install_tiller  = true   
  kubernetes {
        config_path = "${pathexpand("~/k8_devops_config.yaml")}"
    }
}

variable "loadbalancer_ip" {
    default = "127.0.0.1"
}
resource "helm_release" "mosip-common" {
    name      = "mosip-common"
    chart     = "../../../helm-charts/common-config"
    namespace = "kube-system"

    set_string {
        name = "Ingress.loadBalancerIP"
        value = "${var.loadbalancer_ip}"
    }
}