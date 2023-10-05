variable "jenkins_roles" {
  description = "List of roles"
  type        = list(any)
}

variable "dataworks_sa_roles" {
  description = "List of roles for dataworks sa"
  type        = list(any)
}

variable "projects" {
  description = "List of projects"
  type        = list(any)
}

variable "networks" {
  description = "List of cluster"
  type        = list(any)
}
