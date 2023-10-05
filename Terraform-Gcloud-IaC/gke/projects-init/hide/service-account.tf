/********************************************
  Service account
*********************************************/
# resource "google_service_account" "jenkins_cicd_sa" {
#   count        = length(var.projects)
#   project      = "${element(var.projects, count.index)}"
#   account_id   = "jenkins-cicd"
#   display_name = "Jenkins CICD service account"
# }

# resource "google_service_account_key" "jenkins_cicd_sa_key" {
#   service_account_id = "${google_service_account.jenkins_cicd_sa.name}"
# }

# resource "google_project_iam_member" "jenkins_cicd_iam_membership" {
#   count   = "${length(var.roles)}"
#   role    = "${element(var.roles, count.index)}"
#   project = "production-resources-543321"
#   member  = "serviceAccount:${google_service_account.jenkins_cicd_sa.email}"
# }

#locals {
#  sa_list = {
#    for inst in csvdecode(file("sa_list.csv")) :
#    inst["name"] => inst
#  }
#}

#resource "google_service_account" "sa" {
#  for_each     = local.sa_list
#  project      = each.value.project_id
#  account_id   = each.value.account_id
#  display_name = each.value.display_name
#}

#resource "google_project_iam_member" "sa_iam_membership" {
#  for_each = google_service_account.sa
#  roles    = split(" ", "${google_service_account.sa[each.value.roles]}")
#  s = { for sa_role in roles :
#  role => sa_role }
#  project = google_service_account.sa[each.value.display_name]
#  member  = "serviceAccount:${google_service_account.sa[each.email]}"
#}

#jenkins sa in non prod
resource "google_service_account" "jenkins_cicd_sa_nonprod" {
  project      = "nonprod-resources"
  account_id   = "jenkins-cicd"
  display_name = "Jenkins CICD service account"
}

resource "google_project_iam_member" "jenkins_cicd_iam_membership_nonprod" {
  count   = length(var.jenkins_roles)
  role    = element(var.jenkins_roles, count.index)
  project = "nonprod-resources"
  member  = "serviceAccount:${google_service_account.jenkins_cicd_sa_nonprod.email}"
}

resource "google_service_account" "dataworks_sa_nonprod" {
  project      = "nonprod-resources"
  account_id   = "stubhub-dataworks"
  display_name = "for stubhub dataworks"
}

resource "google_project_iam_member" "dataworks_sa_iam_membership_nonprod" {
  count   = length(var.dataworks_sa_roles)
  role    = element(var.dataworks_sa_roles, count.index)
  project = "nonprod-resources"
  member  = "serviceAccount:${google_service_account.dataworks_sa_nonprod.email}"
}

#jenkins sa in prod
resource "google_service_account" "jenkins_cicd_sa_prod" {
  project      = "production-resources-543321"
  account_id   = "jenkins-cicd"
  display_name = "Jenkins CICD service account"
}

resource "google_project_iam_member" "jenkins_cicd_iam_membership_prod" {
  count   = length(var.jenkins_roles)
  role    = element(var.jenkins_roles, count.index)
  project = "production-resources-543321"
  member  = "serviceAccount:${google_service_account.jenkins_cicd_sa_prod.email}"
}