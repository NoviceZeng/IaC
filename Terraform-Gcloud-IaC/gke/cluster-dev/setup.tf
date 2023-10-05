terraform {
  backend "gcs" {
    prefix = "terraform/resource-manager"
    bucket = "resource-manager-stubhub-gke-bucket"
  }
}

provider "google" {
  alias = "tokengen"
}

variable "sh-resource-manager-email" {
  default = "resource-manager-stubhub-gke@resource-manager-stubhub-gke.iam.gserviceaccount.com"
}

data "google_service_account_access_token" "terraform-sa-token" {
  provider               = google.tokengen
  target_service_account = var.sh-resource-manager-email
  lifetime               = "2400s"
  scopes = [
    "https://www.googleapis.com/auth/cloud-platform",
  ]
}

provider "google" {
  access_token = data.google_service_account_access_token.terraform-sa-token.access_token
}

provider "google-beta" {
  access_token = data.google_service_account_access_token.terraform-sa-token.access_token
}

# provider "kubernetes" {
#  alias                  = "cluster-dev-non-prod"
#  host                   = "https://${google_container_cluster.cluster-a.private_cluster_config[0].public_endpoint}"
#  token                  = data.google_service_account_access_token.terraform-sa-token.access_token
#  cluster_ca_certificate = base64decode(google_container_cluster.cluster-a.master_auth[0].cluster_ca_certificate, )
# }

# provider "kubernetes" {
#   alias = "cluster-stg-non-prod"
#   host  = "https://${google_container_cluster.cluster-na.private_cluster_config[0].public_endpoint}"
#   token = data.google_service_account_access_token.terraform-sa-token.access_token
#   cluster_ca_certificate = base64decode(google_container_cluster.cluster-na.master_auth[0].cluster_ca_certificate,)
# }

variable "org_billing_id" {
  default = "00A9BC-233D69-F312E8"
}

# provider "helm" {
#  kubernetes {
#    host  = "https://${google_container_cluster.cluster-a.private_cluster_config[0].public_endpoint}"
#    token = data.google_service_account_access_token.terraform-sa-token.access_token
#    cluster_ca_certificate = base64decode(
#      google_container_cluster.cluster-a.master_auth[0].cluster_ca_certificate,
#    )
#  }
#}