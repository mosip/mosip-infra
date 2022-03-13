provider "helm" { 
    kubernetes {
        config_path = "${pathexpand("~/k8_devops_config.yaml")}"
    }
}

variable "domain_name" {
    default = "localhost/docker-registry"
}
variable "docker_registry_image_pull_secret_name" {
    default = "mysecret"
}

variable "docker_registry_password" {
    default = "mypassword"
}
variable "docker_registry_username" {
    default = "myuser"
}
variable "secrets_htpasswd_file" {
    default = "hi"
}
resource "helm_release" "docker_registry" {
    name      = "docker-registry"
    chart     = "../../../helm-charts/docker-registry"
	timeout   = "900"
	
	set {
        name = "secrets.htpasswd"
        value = "${file("${var.secrets_htpasswd_file}")}"
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
        name = "Docker.Registry.Url"
        value = "${var.domain_name}"
    }
    set_string {
        name = "Docker.Registry.Username"
        value = "${var.docker_registry_username}"
    }
    set_string {
        name = "Docker.Registry.Password"
        value = "${var.docker_registry_password}"
    }
    set_string {
        name = "Docker.Registry.ImagePullSecrets"
        value = "${var.docker_registry_image_pull_secret_name}"
    }

    set_string {
        name = "ingress.path"
        value = "/docker-registry"
    }
}
