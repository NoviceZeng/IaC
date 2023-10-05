variable "jenkins_roles" {
  description = "List of roles"
  type        = list(any)
}

variable "dataworks_sa_roles" {
  description = "List of roles for dataworks sa"
  type        = list(any)
}

variable "non_project_id" {
  description = "project id of the non-production GCP project"
}

variable "project_id" {
  description = "project id of the production GCP project"
}