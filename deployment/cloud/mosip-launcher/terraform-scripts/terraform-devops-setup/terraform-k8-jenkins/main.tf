resource "random_uuid" "artifactory_server_random_id" { } 

resource "random_uuid" "scm_credentials_random_id" { }

resource "random_uuid" "docker_registry_credentials_random_id" { }

resource "helm_release" "mosipjenkins" {
  name  = "jenkins"
  chart = "../../../helm-charts/jenkins"
  timeout   = "900"

  set_string {
    name  = "Master.JenkinsUrl"
    value = "${var.master_jenkins_url}"
  }

  set_string {
    name  = "Master.DomainName"
    value = "${var.domain_name}"
  }

  set_string {
    name  = "Scm.username"
    value = "${var.scm_username}"
  }

  set_string {
    name  = "Scm.privatekey"
    value = "${chomp(file(var.key_file))}"
  }

  set_string {
    name  = "Dockerregistry.username"
    value = "${var.docker_registry_username}"
  }

  set_string {
    name  = "Dockerregistry.password"
    value = "${var.docker_registry_password}"
  }

  set_string {
    name  = "Artifactory.url"
    value = "${var.artifactory_url}"
  }
  set_string {
    name  = "Artifactory.username"
    value = "${var.artifactory_username}"
  }
  set_string {
    name  = "Artifactory.password"
    value = "${var.artifactory_password}"
  }
    set_string {
    name  = "Artifactory.serverkey"
    value = "${var.artifactory_server_key}"
  }
  set_string {
    name  = "Artifactory.serverid"
    value = "${random_uuid.artifactory_server_random_id.result}"
  }
  set_string {
    name  = "Docker.registrykey"
    value = "${var.docker_registry_credentials_key}"
  }
  set_string {
    name  = "Docker.registryid"
    value = "${random_uuid.docker_registry_credentials_random_id.result}"
  }
  set_string {
    name  = "Master.AdminPassword"
    value = "${var.jenkins_admin_password}"
  }
  set_string{
    name = "Agent.ImagePullSecret"
    value = "${var.docker_registry_image_pull_secret}"
  }

  set_string{
    name = "Agent.Image"
    value = "${var.jenkins_agent_jnlp_custom_image_name}"
  }

  set_string{
    name = "Agent.ImageTag"
    value = "${var.jenkins_agent_jnlp_custom_image_tag}"
  }

  set_string {
    name  = "scm.branch"
    value = "${var.scm_repo_branch}"
  }

  set_string {
    name  = "Scm.urlkey"
    value = "${var.scm_repo_url_key}"
  }

   set_string {
    name  = "Scm.url"
    value = "${var.scm_repo_url}"
  }

  set_string {
    name  = "Docker.Registry.url"
    value = "${var.docker_registry_url}"
  }

    set_string {
    name  = "Docker.Registry.urlkey"
    value = "${var.docker_registry_url_key}"
  }
 
   set_string {
    name  = "Scm.credentialskey"
    value = "${var.scm_credentials_key}"
  }
   set_string {
    name  = "Scm.credentialsid"
    value = "${random_uuid.scm_credentials_random_id.result}"
  }

}

output "scm_credential_id" {
  value = "${random_uuid.scm_credentials_random_id.result}"
}

