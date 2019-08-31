provider "helm" {
    kubernetes {
        config_path = "${pathexpand("~/k8_devops_config.yaml")}"
    }
}