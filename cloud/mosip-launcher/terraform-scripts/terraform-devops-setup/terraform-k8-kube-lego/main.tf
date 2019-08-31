provider "helm" {
    kubernetes {
        config_path = "${pathexpand("~/k8_devops_config.yaml")}"
    }
}
resource "helm_release" "mosip-kube-lego-for-letsencrypt" {
    name      = "mosip-kube-lego-for-letsencrypt"
    chart     = "../../../helm-charts/kube-lego"
	namespace = "kube-system"
    
	set {
        name = "config.LEGO_EMAIL"
        value = "skp7663@gmail.com"
    }
    set {
        name = "config.LEGO_URL"
        value = "https://acme-v01.api.letsencrypt.org/directory"
    }
}