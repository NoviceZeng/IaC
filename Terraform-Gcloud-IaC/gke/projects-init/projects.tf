
resource "google_folder" "non-prod" {
  display_name = "Non-Prod"
  parent       = "folders/388931406562"
}

resource "google_project" "nonprod-resources" {
  name                = "nonprod-resources"
  project_id          = "nonprod-resources-432234"
  billing_account     = var.org_billing_id
  folder_id           = google_folder.non-prod.name
  auto_create_network = false
}

resource "google_project_service" "nonprod-resources-api" {
  for_each = {
    compute              = "compute.googleapis.com"
    gke                  = "container.googleapis.com"
    logging              = "logging.googleapis.com"
    monitoring           = "monitoring.googleapis.com"
    svcnetwork           = "servicenetworking.googleapis.com"
    vpcaccess            = "vpcaccess.googleapis.com"
    iamCreds             = "iamcredentials.googleapis.com"
    iam                  = "iam.googleapis.com"
    meshca               = "meshca.googleapis.com"
    stackdriver          = "stackdriver.googleapis.com"
    cloudresourcemanager = "cloudresourcemanager.googleapis.com"
    gkehub               = "gkehub.googleapis.com"
    gkeconnect           = "gkeconnect.googleapis.com"
    meshconfig           = "meshconfig.googleapis.com"
    meshtelemetry        = "meshtelemetry.googleapis.com"
    cloudtrace           = "cloudtrace.googleapis.com"
  }

  project                    = google_project.nonprod-resources.project_id
  service                    = each.value
  disable_dependent_services = true
}

resource "google_folder" "production" {
  display_name = "Prod"
  parent       = "folders/388931406562"
}

resource "google_project" "production-resources" {
  name                = "production-resources"
  project_id          = "production-resources-989843"
  billing_account     = var.org_billing_id
  folder_id           = google_folder.production.name
  auto_create_network = false
}

resource "google_project_service" "production-resources-api" {
  for_each = {
    compute              = "compute.googleapis.com"
    gke                  = "container.googleapis.com"
    logging              = "logging.googleapis.com"
    monitoring           = "monitoring.googleapis.com"
    svcnetwork           = "servicenetworking.googleapis.com"
    vpcaccess            = "vpcaccess.googleapis.com"
    iamCreds             = "iamcredentials.googleapis.com"
    iam                  = "iam.googleapis.com"
    meshca               = "meshca.googleapis.com"
    stackdriver          = "stackdriver.googleapis.com"
    cloudresourcemanager = "cloudresourcemanager.googleapis.com"
    gkehub               = "gkehub.googleapis.com"
    gkeconnect           = "gkeconnect.googleapis.com"
    meshconfig           = "meshconfig.googleapis.com"
    meshtelemetry        = "meshtelemetry.googleapis.com"
    cloudtrace           = "cloudtrace.googleapis.com"
  }

  project                    = google_project.production-resources.project_id
  service                    = each.value
  disable_dependent_services = true
}