terraform {
  required_version = ">= 0.12.25"

  backend "gcs" {
    prefix      = "tfstate"
    credentials = "tf_state_admin.key.json"
  }
}

provider "google" {
  credentials = "${file("tf_project.key.json")}"
  project     = "${var.project_id}"
  version     = "~> 3.41"
}

provider "google-beta" {
  credentials = "${file("tf_project.key.json")}"
  project     = "${var.project_id}"
  version     = "~> 3.41"
}

provider "external" {
  version = "~> 1.0"
}

provider "null" {
  version = "~> 2.0"
}

provider "random" {
  version = "~> 2.0"
}

provider "tls" {
  version = "~> 2.0"
}
