provider "helm" {
  kubernetes {
        config_path = "${pathexpand("~/k8_devops_config.yaml")}"
    }
}
variable "domain_name" {
    default = "localhost"
}
variable "password" {
    default = "password"
}

resource "random_id" "becrypt_password" {
    
    prefix =  "${bcrypt("${var.password}")}"
    
    byte_length = 1
}

resource "helm_release" "mosipjfrog" {
    name      = "jfrog"
    chart     = "../../../helm-charts/jfrog"
    timeout   = "900"

    set {
        name = "artifactory.image.repository"
        value = "docker.bintray.io/jfrog/artifactory-oss"
    }
	set {
        name = "postgresql.enabled"
        value = "false"
    }
    set {
        name = "artifactory.configMapName"
        value = "my-release-bootstrap-config"
    }
    set_string {
        name = "ingress.host"
        value = "${var.domain_name}"
    }

    set_string {
        name = "ingress.tls.hostname"
        value = "${var.domain_name}"
    }
    set_string {
        name = "password.plaintext"
        value= "${var.password}"
    }

    set_string {
        name = "admin.password"
        value = "${substr(random_id.becrypt_password.hex,0,60)}"
    }
}