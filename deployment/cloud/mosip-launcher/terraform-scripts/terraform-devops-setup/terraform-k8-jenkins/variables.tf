variable "master_jenkins_url" {
  default = "localhost/jenkins"
}

variable "jenkins_admin_password" {
  default = "myPassword"
}


variable "docker_registry_image_pull_secret" {
  default = "mySecret"
}

variable "jenkins_agent_jnlp_custom_image_name" {
   default = "myImage"
}

variable "jenkins_agent_jnlp_custom_image_tag" {

  default = "v1"
  
}
variable "domain_name" {
  default = "localhost"
}

variable "scm_username" {
  default = "username"
}

variable "key_file" {
  default = "~/.ssh/id_rsa"
}

variable "scm_privatekey" {
  default = "asdfgp"
}

variable "scm_repo_url" {
  default = "localhost"
}

variable "docker_registry_url" {
   default= "localhost"
}


variable "scm_repo_branch" {
  default = "master"
}

variable "docker_registry_username" {
  default = "username"
}


variable "docker_registry_password" {
  default = "password"
}
variable "scm_credentials_key" {
  default = "scmRepoCredentials"
}
variable "scm_credentials_id" {
  default = "scm_creds"
}
variable "artifactory_server_key" {
  default = "artifactoryServerId"
}

variable "scm_repo_url_key" {
  default = "scmURL"
}

variable "docker_registry_url_key" {
  default = "dockerRegistryUrl"
}


variable "artifactory_server_id" {
  default = "artifactory_server_id"
}

variable "docker_registry_credentials_key" {
  default = "dockerRegistryCredentials"
}

variable "docker_registry_credentials_id" {
  default = "docker_registry_creds"
}


variable "artifactory_url"{
    default = "localhost/artifactory"
}

variable "artifactory_username"{
    default = "username"
}

variable "artifactory_password"{
    default = "password"
}