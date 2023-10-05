# Resource Manager

This is the setup information for the resource manager project, the resource manager project will configure all the shared resources in the non production and production environments.


## setup

This can be done manually or within another Terraform state. The instructions for Terraform are below.

1. Create the resource manager project at the top level (above the Non Production and Production Folders).

```sh
resource "google_project" "sh-resource-manager-may-2021" {
  name            = "Resource Manager"
  project_id      = "sh-resource-manager-may-2021"
  billing_account = var.org_billing_id
  folder_id  = google_folder.sh-demo-may-2021.name
  auto_create_network = false
}

resource "google_project_service" "sh-may-2021-service-api" {
  for_each = {
     logging      = "logging.googleapis.com"
     sourcerepo   = "sourcerepo.googleapis.com"
     cloudbuild   = "cloudbuild.googleapis.com"
     billing      = "cloudbilling.googleapis.com"
     serviceusage = "serviceusage.googleapis.com"
     rmanager     = "cloudresourcemanager.googleapis.com"
     iam          = "iamcredentials.googleapis.com"
   }

  project = google_project.sh-resource-manager-may-2021.project_id
  service = each.value

  disable_dependent_services = true
}
```

2. Create a new service account, this service account will be the owner of all the shared projects. 

```sh
resource "google_service_account" "sh-resource-manager-sa-may-2021" {
  account_id   = "sh-resource-manager-may-2021"
  project = google_project.sh-resource-manager-may-2021.project_id
  display_name = "SH Resource Manager"
}
```

3. Give the Cloud Build service account in this resource manager project permissions to use this new service account.

```sh
resource "google_service_account_iam_binding" "sh-resource-manager-sa-may-2021-token-creator" {
  service_account_id = google_service_account.sh-resource-manager-sa-may-2021.name
  role               = "roles/iam.serviceAccountTokenCreator"

  members = [
    "serviceAccount:${google_project.sh-resource-manager-may-2021.number}@cloudbuild.gserviceaccount.com",
  ]
}
```

4. Give the resource manager SA, permissions to create folders, projects and be a Shared VPC admin. If this project is a child in a folder you will
   use the [google_folder_iam](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_folder_iam)
   resource, otherwise you will use the [google_organization_iam](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_organization_iam)
   resource. Be careful to choose the correct resource type, binding or members.

For example:

```sh
resource "google_folder_iam_binding" "sh-project-creator" {
  folder  = google_folder.sh-demo-may-2021.name
  role    = "roles/resourcemanager.projectCreator"

  members = [
    "serviceAccount:${google_service_account.sh-resource-manager-sa-may-2021.email}",
  ]
}

resource "google_folder_iam_binding" "sh-folder-creator" {
  folder  = google_folder.sh-demo-may-2021.name
  role    = "roles/resourcemanager.folderCreator"

  members = [
    "serviceAccount:${google_service_account.sh-resource-manager-sa-may-2021.email}",
  ]
}

resource "google_folder_iam_binding" "sh-xpn-admin" {
  folder  = google_folder.sh-demo-may-2021.name
  role               = "roles/compute.xpnAdmin"

  members = [
    "serviceAccount:${google_service_account.sh-resource-manager-sa-may-2021.email}",
  ]
}
```

5. Create the source repository and GCS bucket that the shared resources Terraform state will be in, you will also
   give permission to the team to push Terraform code and give the resource manager SA permission to write to the bucket.

```sh
resource "google_sourcerepo_repository" "sh-terraform-repo" {
  name = "terraform"
  project = google_project.sh-resource-manager-may-2021.project_id
}

resource "google_sourcerepo_repository_iam_binding" "sh-tf-source-repo-writer-binding" {
  project = google_project.sh-resource-manager-may-2021.project_id
  repository = google_sourcerepo_repository.sh-terraform-repo.name
  role = "roles/source.writer"
  members = [
    "group:team@domain.com",
    "user:user@domain.com",
  ]
}

resource "google_storage_bucket" "sh-iac-bucket-may-2021" {
  name          = "sh-iac-bucket-may-2021"
  location      = "ASIA"
  force_destroy = false
  project = google_project.sh-resource-manager-may-2021.project_id
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_iam_binding" "sh-resource-manager-sa-iac-bucket-writer" {
  bucket = google_storage_bucket.sh-iac-bucket-may-2021.name
  role = "roles/storage.objectAdmin"
  members = [
    "serviceAccount:${google_service_account.sh-resource-manager-sa-may-2021.email}",
  ]
}
```

6. Create a cloud build trigger that will run everytime your terraform is updated, in this case I've created a projects folder. (Just like this repository).

```sh
resource "google_cloudbuild_trigger" "sh-resource-manager-tf-trigger" {
  project = google_project.sh-resource-manager-may-2021.project_id
  name = "sh-terraform-apply"
  description = "Terraform updates for the sh group."
  trigger_template {
    branch_name = "master"
    repo_name   = google_sourcerepo_repository.sh-terraform-repo.name
  }
  included_files = ["projects/*"]
  filename = "projects/cloudbuild.yaml"
}
```


7. Add the necessary edit/viewing access to your resource manager project, so the team can view this project. You may also want to
   give editing permission for the Cloud Build so you can trigger and re run builds manually. For example:

```sh
resource "google_folder_iam_binding" "build-editor-sh-demo-folder" {
  folder  = google_folder.sh-demo-may-2021.name
  role    = "roles/cloudbuild.builds.editor"

  members = [
    "user:user@domain",
  ]
}
```

8.  Once all is applied you will need to push the resource manager terraform to the new empty repository. See next section.


## Setting up TF

### Base Structure

The example setup is in this current directory, you will need to add the `projects/cloudbuild.yaml`, `projects/setup.tf` and `projects/folders.tf`.
Be sure to update:
1. `cloudbuild.yaml` if you don't use the projects folder structure in this example.
2. Update your billing id and your resource manager service account in the `setup.tf`. The provider will generate a short lived access token
   and use that token to authenticate when creating resources.
3. The `folders.tf` is mirroring option A that we discussed earlier, feel free to change it but please also update our shared document so we know.
4. Push to your empty repository. I find gcloud to be the easiest option when cloning repositories.
5. Give project viewing access to your non prod folder so the everyone can view all the projects by default. For example:

```sh
resource "google_folder_iam_binding" "sh-viewer-folder-access" {
  folder  = google_folder.sh-non-prod-may-2021.name
  role    = "roles/viewer"

  members = [
    "group:team@domain.com",
  ]
}

resource "google_folder_iam_binding" "sh-folder-viewer-folder-access" {
  folder  = google_folder.sh-non-prod-may-2021.name
  role    = "roles/resourcemanager.folderViewer"

  members = [
    "group:team@domain.com",
  ]
}
```

### Testing

Check if the Cloud Build trigger has successfully initiated and planned your current Terraform code. There shouldn't be any resources to apply just yet.

