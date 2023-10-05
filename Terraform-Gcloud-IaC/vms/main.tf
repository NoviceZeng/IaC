/******************************************
  VM Setup
 *****************************************/

locals {
  vm_list = {
    for hostname in csvdecode(file("vm_list.csv")) :
    hostname["hostname"] => hostname
  }
  security_rule_list = {
    for rule in csvdecode(file("security_policy.csv")) :
    rule["priority"] => rule
  }
}

resource "google_compute_instance" "app_dmz_fe" {
  for_each = "${var.vm_app_dmz_fe}"

  project             = "${var.project_id}"
  name                = "${each.value.serverName}"
  machine_type        = "${var.highmem_machine_type}"
  zone                = "${each.value.zone}"
  hostname            = "${each.value.serverName}.${var.project_name}.com"
  deletion_protection = "${var.deletion_protection}"


  tags = ["${var.project_name}", "${var.project_name}dmzfe", "${var.project_name}dmzfeapp"]

  shielded_instance_config {
    enable_secure_boot          = var.enable_secure_boot
    enable_vtpm                 = var.enable_vtpm
    enable_integrity_monitoring = var.enable_integrity_monitoring
  }

  boot_disk {
    initialize_params {
      image = "${var.image_app}"
      size  = "200"
    }
  }

  network_interface {
    subnetwork = "projects/${var.vpchost_project_id}/regions/${each.value.region}/subnetworks/${var.project_name}-dmz-fe"
    network_ip = "${each.value.ipAddress}"
  }

  depends_on = ["google_compute_disk.tu_production_disk"]

  service_account {
    email  = "stackdriver@usep10-28361.iam.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/cloud-platform", ]
  }
}

resource "google_compute_instance" "mxx_dmz_fe" {
  for_each = "${var.vm_mxx_dmz_fe}"

  project             = "${var.project_id}"
  name                = "${each.value.serverName}"
  machine_type        = "${var.highmem_machine_type}"
  zone                = "${each.value.zone}"
  hostname            = "${each.value.serverName}.${var.project_name}.com"
  deletion_protection = "${var.deletion_protection}"

  tags = ["${var.project_name}", "${var.project_name}dmzfe", "${var.project_name}dmzfemxx"]

  shielded_instance_config {
    enable_secure_boot          = var.enable_secure_boot
    enable_vtpm                 = var.enable_vtpm
    enable_integrity_monitoring = var.enable_integrity_monitoring
  }

  boot_disk {
    initialize_params {
      image = "${var.image_mxx}"
      size  = "200"
    }
  }

  network_interface {
    subnetwork = "projects/${var.vpchost_project_id}/regions/${each.value.region}/subnetworks/${var.project_name}-dmz-fe"
    network_ip = "${each.value.ipAddress}"
  }

  depends_on = ["google_compute_disk.tu_production_disk"]

  service_account {
    email  = "stackdriver@usep10-28361.iam.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/cloud-platform", ]
  }

}

resource "google_compute_instance" "sch_dmz_be" {
  for_each = "${var.vm_sch_dmz_be}"

  project             = "${var.project_id}"
  name                = "${each.value.serverName}"
  machine_type        = "${var.highmem_machine_type}"
  zone                = "${each.value.zone}"
  hostname            = "${each.value.serverName}.${var.project_name}.com"
  deletion_protection = "${var.deletion_protection}"

  tags = ["${var.project_name}", "${var.project_name}dmzbe", "${var.project_name}dmzbesch"]

  shielded_instance_config {
    enable_secure_boot          = var.enable_secure_boot
    enable_vtpm                 = var.enable_vtpm
    enable_integrity_monitoring = var.enable_integrity_monitoring
  }

  boot_disk {
    initialize_params {
      image = "${var.image_sch}"
      size  = "200"
    }
  }

  network_interface {
    subnetwork = "projects/${var.vpchost_project_id}/regions/${each.value.region}/subnetworks/${var.project_name}-dmz-be"
    network_ip = "${each.value.ipAddress}"
  }

  depends_on = ["google_compute_disk.tu_production_disk"]

  service_account {
    email  = "stackdriver@usep10-28361.iam.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/cloud-platform", ]
  }

}

resource "google_compute_instance" "crl_dmz_be" {
  for_each = "${var.vm_crl_dmz_be}"

  project             = "${var.project_id}"
  name                = "${each.value.serverName}"
  machine_type        = "${var.highmem_machine_type}"
  zone                = "${each.value.zone}"
  hostname            = "${each.value.serverName}.${var.project_name}.com"
  deletion_protection = "${var.deletion_protection}"

  tags = ["${var.project_name}", "${var.project_name}dmzbe", "${var.project_name}dmzbecrl"]

  shielded_instance_config {
    enable_secure_boot          = var.enable_secure_boot
    enable_vtpm                 = var.enable_vtpm
    enable_integrity_monitoring = var.enable_integrity_monitoring
  }

  boot_disk {
    initialize_params {
      image = "${var.image_crl}"
      size  = "200"
    }
  }

  network_interface {
    subnetwork = "projects/${var.vpchost_project_id}/regions/${each.value.region}/subnetworks/${var.project_name}-dmz-be"
    network_ip = "${each.value.ipAddress}"
  }

  depends_on = ["google_compute_disk.tu_production_disk"]

  service_account {
    email  = "stackdriver@usep10-28361.iam.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/cloud-platform", ]
  }

}

resource "google_compute_instance" "syn_dmz_be" {
  for_each = "${var.vm_syn_dmz_be}"

  project             = "${var.project_id}"
  name                = "${each.value.serverName}"
  machine_type        = "${var.highmem_machine_type}"
  zone                = "${each.value.zone}"
  hostname            = "${each.value.serverName}.${var.project_name}.com"
  deletion_protection = "${var.deletion_protection}"

  tags = ["${var.project_name}", "${var.project_name}dmzbe", "${var.project_name}dmzbesyn"]

  shielded_instance_config {
    enable_secure_boot          = var.enable_secure_boot
    enable_vtpm                 = var.enable_vtpm
    enable_integrity_monitoring = var.enable_integrity_monitoring
  }

  boot_disk {
    initialize_params {
      image = "${var.image_syn}"
      size  = "200"
    }
  }

  network_interface {
    subnetwork = "projects/${var.vpchost_project_id}/regions/${each.value.region}/subnetworks/${var.project_name}-dmz-be"
    network_ip = "${each.value.ipAddress}"
  }

  depends_on = ["google_compute_disk.tu_production_disk"]

  service_account {
    email  = "stackdriver@usep10-28361.iam.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/cloud-platform", ]
  }

}

resource "google_compute_instance" "sys_dmz_be" {
  for_each = "${var.vm_sys_dmz_be}"

  project             = "${var.project_id}"
  name                = "${each.value.serverName}"
  machine_type        = "${var.highmem_machine_type}"
  zone                = "${each.value.zone}"
  hostname            = "${each.value.serverName}.${var.project_name}.com"
  deletion_protection = "${var.deletion_protection}"

  tags = ["${var.project_name}", "${var.project_name}dmzbe", "${var.project_name}dmzbesys"]

  shielded_instance_config {
    enable_secure_boot          = var.enable_secure_boot
    enable_vtpm                 = var.enable_vtpm
    enable_integrity_monitoring = var.enable_integrity_monitoring
  }

  boot_disk {
    initialize_params {
      image = "${var.image_sys}"
      size  = "200"
    }
  }

  network_interface {
    subnetwork = "projects/${var.vpchost_project_id}/regions/${each.value.region}/subnetworks/${var.project_name}-dmz-be"
    network_ip = "${each.value.ipAddress}"
  }

  depends_on = ["google_compute_disk.tu_production_disk"]

  service_account {
    email  = "stackdriver@usep10-28361.iam.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/cloud-platform", ]
  }

}

resource "google_compute_instance" "fln_dmz_be" {
  for_each = "${var.vm_fln_dmz_be}"

  project             = "${var.project_id}"
  name                = "${each.value.serverName}"
  machine_type        = "${each.value.machineType}"
  zone                = "${each.value.zone}"
  hostname            = "${each.value.serverName}.${var.project_name}.com"
  deletion_protection = "${var.deletion_protection}"

  tags = ["${var.project_name}", "${var.project_name}dmzbe", "${var.project_name}dmzbefln"]

  shielded_instance_config {
    enable_secure_boot          = var.enable_secure_boot
    enable_vtpm                 = var.enable_vtpm
    enable_integrity_monitoring = var.enable_integrity_monitoring
  }

  boot_disk {
    initialize_params {
      image = "${var.image_fln}"
      size  = "200"
    }
  }

  network_interface {
    subnetwork = "projects/${var.vpchost_project_id}/regions/${each.value.region}/subnetworks/${var.project_name}-dmz-be"
    network_ip = "${each.value.ipAddress}"
  }

  attached_disk {
    source = "${each.value.disk}"
  }

  depends_on = ["google_compute_disk.tu_production_disk"]

  service_account {
    email  = "stackdriver@usep10-28361.iam.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/cloud-platform", ]
  }
}

resource "google_compute_instance" "fls_dmz_be" {
  for_each = "${var.vm_fls_dmz_be}"

  project             = "${var.project_id}"
  name                = "${each.value.serverName}"
  machine_type        = "${var.highmem_machine_type}"
  zone                = "${each.value.zone}"
  hostname            = "${each.value.serverName}.${var.project_name}.com"
  deletion_protection = "${var.deletion_protection}"

  tags = ["${var.project_name}", "${var.project_name}dmzbe", "${var.project_name}dmzbefls"]

  shielded_instance_config {
    enable_secure_boot          = var.enable_secure_boot
    enable_vtpm                 = var.enable_vtpm
    enable_integrity_monitoring = var.enable_integrity_monitoring
  }

  boot_disk {
    initialize_params {
      image = "${var.image_fls}"
      size  = "200"
    }
  }

  attached_disk {
    source = "${each.value.disk}"
  }


  network_interface {
    subnetwork = "projects/${var.vpchost_project_id}/regions/${each.value.region}/subnetworks/${var.project_name}-dmz-be"
    network_ip = "${each.value.ipAddress}"
  }

  depends_on = ["google_compute_disk.tu_production_disk"]

  service_account {
    email  = "stackdriver@usep10-28361.iam.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/cloud-platform", ]
  }
}

resource "google_compute_instance" "tts_dmz_be" {
  for_each = "${var.vm_tts_dmz_be}"

  project             = "${var.project_id}"
  name                = "${each.value.serverName}"
  machine_type        = "${var.highmem_machine_type}"
  zone                = "${each.value.zone}"
  hostname            = "${each.value.serverName}.${var.project_name}.com"
  deletion_protection = "${var.deletion_protection}"

  tags = ["${var.project_name}", "${var.project_name}dmzbe", "${var.project_name}dmzbetts"]

  shielded_instance_config {
    enable_secure_boot          = var.enable_secure_boot
    enable_vtpm                 = var.enable_vtpm
    enable_integrity_monitoring = var.enable_integrity_monitoring
  }

  boot_disk {
    initialize_params {
      image = "${var.image_tts}"
      size  = "200"
    }
  }

  network_interface {
    subnetwork = "projects/${var.vpchost_project_id}/regions/${each.value.region}/subnetworks/${var.project_name}-dmz-be"
    network_ip = "${each.value.ipAddress}"
  }

  depends_on = ["google_compute_disk.tu_production_disk"]

  service_account {
    email  = "stackdriver@usep10-28361.iam.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/cloud-platform", ]
  }

}

resource "google_compute_instance" "mts_dmz_be" {
  for_each = "${var.vm_mts_dmz_be}"

  project             = "${var.project_id}"
  name                = "${each.value.serverName}"
  machine_type        = "${var.highmem_machine_type}"
  zone                = "${each.value.zone}"
  hostname            = "${each.value.serverName}.${var.project_name}.com"
  deletion_protection = "${var.deletion_protection}"

  tags = ["${var.project_name}", "${var.project_name}dmzbe", "${var.project_name}dmzbemts"]

  shielded_instance_config {
    enable_secure_boot          = var.enable_secure_boot
    enable_vtpm                 = var.enable_vtpm
    enable_integrity_monitoring = var.enable_integrity_monitoring
  }

  boot_disk {
    initialize_params {
      image = "${var.image_mts}"
      size  = "200"
    }
  }

  network_interface {
    subnetwork = "projects/${var.vpchost_project_id}/regions/${each.value.region}/subnetworks/${var.project_name}-dmz-be"
    network_ip = "${each.value.ipAddress}"
  }

  depends_on = ["google_compute_disk.tu_production_disk"]

  service_account {
    email  = "stackdriver@usep10-28361.iam.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/cloud-platform", ]
  }

}

resource "google_compute_instance" "aut_dmz_be" {
  for_each = "${var.vm_aut_dmz_be}"

  project             = "${var.project_id}"
  name                = "${each.value.serverName}"
  machine_type        = "${var.highmem_machine_type}"
  zone                = "${each.value.zone}"
  hostname            = "${each.value.serverName}.${var.project_name}.com"
  deletion_protection = "${var.deletion_protection}"

  tags = ["${var.project_name}", "${var.project_name}dmzbe", "${var.project_name}dmzbeaut"]

  shielded_instance_config {
    enable_secure_boot          = var.enable_secure_boot
    enable_vtpm                 = var.enable_vtpm
    enable_integrity_monitoring = var.enable_integrity_monitoring
  }

  boot_disk {
    initialize_params {
      image = "${var.image_aut}"
      size  = "200"
    }
  }

  network_interface {
    subnetwork = "projects/${var.vpchost_project_id}/regions/${each.value.region}/subnetworks/${var.project_name}-dmz-be"
    network_ip = "${each.value.ipAddress}"
  }

  depends_on = ["google_compute_disk.tu_production_disk"]

  service_account {
    email  = "stackdriver@usep10-28361.iam.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/cloud-platform", ]
  }

}

resource "google_compute_instance" "aum_dmz_be" {
  for_each = "${var.vm_aum_dmz_be}"

  project             = "${var.project_id}"
  name                = "${each.value.serverName}"
  machine_type        = "${var.highmem_machine_type}"
  zone                = "${each.value.zone}"
  hostname            = "${each.value.serverName}.${var.project_name}.com"
  deletion_protection = "${var.deletion_protection}"

  tags = ["${var.project_name}", "${var.project_name}dmzbe", "${var.project_name}dmzbeaum"]

  shielded_instance_config {
    enable_secure_boot          = var.enable_secure_boot
    enable_vtpm                 = var.enable_vtpm
    enable_integrity_monitoring = var.enable_integrity_monitoring
  }

  boot_disk {
    initialize_params {
      image = "${var.image_aum}"
      size  = "200"
    }
  }

  network_interface {
    subnetwork = "projects/${var.vpchost_project_id}/regions/${each.value.region}/subnetworks/${var.project_name}-dmz-be"
    network_ip = "${each.value.ipAddress}"
  }

  depends_on = ["google_compute_disk.tu_production_disk"]

  service_account {
    email  = "stackdriver@usep10-28361.iam.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/cloud-platform", ]
  }

}

resource "google_compute_instance" "sql_db" {
  for_each = "${var.vm_sql_db}"

  project             = "${var.project_id}"
  name                = "${each.value.serverName}"
  machine_type        = "${each.value.machineType}"
  zone                = "${each.value.zone}"
  hostname            = "${each.value.serverName}.${var.project_name}.com"
  deletion_protection = "${var.deletion_protection}"

  tags = ["${var.project_name}", "${var.project_name}db", "${var.project_name}dbsql"]

  shielded_instance_config {
    enable_secure_boot          = var.enable_secure_boot
    enable_vtpm                 = var.enable_vtpm
    enable_integrity_monitoring = var.enable_integrity_monitoring
  }

  boot_disk {
    initialize_params {
      image = "${var.image_sql}"
      size  = "200"
    }
  }

  network_interface {
    subnetwork = "projects/${var.vpchost_project_id}/regions/${each.value.region}/subnetworks/${var.project_name}-db"
    network_ip = "${each.value.ipAddress}"
  }

  attached_disk {
    source = "${each.value.disk_data}"
  }

  attached_disk {
    source = "${each.value.disk_temp}"
  }

  attached_disk {
    source = "${each.value.disk_log}"
  }

  depends_on = ["google_compute_disk.tu_production_disk"]

  service_account {
    email  = "stackdriver@usep10-28361.iam.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/cloud-platform", ]
  }

  allow_stopping_for_update = true

}

/*
resource "google_compute_instance" "sql_db_backup" {
  for_each = "${var.vm_sql_db_bk}"

  project             = "${var.project_id}"
  name                = "${each.value.serverName}"
  machine_type        = "${each.value.machineType}"
  zone                = "${each.value.zone}"
  hostname            = "${each.value.serverName}.${var.project_name}.com"
  deletion_protection = "${var.deletion_protection}"

  tags = ["${var.project_name}", "${var.project_name}db", "${var.project_name}dbsql"]

  shielded_instance_config {
    enable_secure_boot          = var.enable_secure_boot
    enable_vtpm                 = var.enable_vtpm
    enable_integrity_monitoring = var.enable_integrity_monitoring
  }

  boot_disk {
    initialize_params {
      image = "${var.image_sql}"
      size  = "200"
    }
  }

  network_interface {
    subnetwork = "projects/${var.vpchost_project_id}/regions/${each.value.region}/subnetworks/${var.project_name}-db"
    network_ip = "${each.value.ipAddress}"
  }

  attached_disk {
    source = "${each.value.disk_data}"
  }

  depends_on = ["google_compute_disk.tu_production_disk"]

  service_account {
    email  = "stackdriver@usep10-28361.iam.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/cloud-platform", ]
  }

  allow_stopping_for_update = true

}
*/

resource "google_compute_instance" "cbq_db" {
  for_each = "${var.vm_cbq_db}"

  project             = "${var.project_id}"
  name                = "${each.value.serverName}"
  machine_type        = "${var.standard_machine_type}"
  zone                = "${each.value.zone}"
  hostname            = "${each.value.serverName}.${var.project_name}.com"
  deletion_protection = "${var.deletion_protection}"

  tags = ["${var.project_name}", "${var.project_name}db", "${var.project_name}dbcbq"]

  shielded_instance_config {
    enable_secure_boot          = var.enable_secure_boot
    enable_vtpm                 = var.enable_vtpm
    enable_integrity_monitoring = var.enable_integrity_monitoring
  }

  boot_disk {
    initialize_params {
      image = "${var.image_cbq}"
      size  = "200"
    }
  }

  attached_disk {
    source = "${each.value.disk_data}"
  }

  network_interface {
    subnetwork = "projects/${var.vpchost_project_id}/regions/${each.value.region}/subnetworks/${var.project_name}-db"
    network_ip = "${each.value.ipAddress}"
  }

  depends_on = ["google_compute_disk.tu_production_disk"]

  service_account {
    email  = "stackdriver@usep10-28361.iam.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/cloud-platform", ]
  }

}

resource "google_compute_instance" "cbn_db" {
  for_each = "${var.vm_cbn_db}"

  project             = "${var.project_id}"
  name                = "${each.value.serverName}"
  machine_type        = "${var.standard_machine_type}"
  zone                = "${each.value.zone}"
  hostname            = "${each.value.serverName}.${var.project_name}.com"
  deletion_protection = "${var.deletion_protection}"

  tags = ["${var.project_name}", "${var.project_name}db", "${var.project_name}dbcbn"]

  shielded_instance_config {
    enable_secure_boot          = var.enable_secure_boot
    enable_vtpm                 = var.enable_vtpm
    enable_integrity_monitoring = var.enable_integrity_monitoring
  }

  boot_disk {
    initialize_params {
      image = "${var.image_cbn}"
      size  = "200"
    }
  }

  attached_disk {
    source = "${each.value.disk_data}"
  }

  network_interface {
    subnetwork = "projects/${var.vpchost_project_id}/regions/${each.value.region}/subnetworks/${var.project_name}-db"
    network_ip = "${each.value.ipAddress}"
  }

  depends_on = ["google_compute_disk.tu_production_disk"]

  service_account {
    email  = "stackdriver@usep10-28361.iam.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/cloud-platform", ]
  }

}

resource "google_compute_instance" "ngx_lba" {
  for_each = "${var.vm_ngx_lba}"

  project                   = "${var.project_id}"
  name                      = "${each.value.serverName}"
  machine_type              = "${var.standard_machine_type}"
  zone                      = "${each.value.zone}"
  hostname                  = "${each.value.serverName}.${var.project_name}.com"
  deletion_protection       = "${var.deletion_protection}"
  allow_stopping_for_update = true

  tags = ["${var.project_name}", "${var.project_name}lba", "${var.project_name}lbangx"]

  shielded_instance_config {
    enable_secure_boot          = var.enable_secure_boot
    enable_vtpm                 = var.enable_vtpm
    enable_integrity_monitoring = var.enable_integrity_monitoring
  }

  boot_disk {
    initialize_params {
      image = "${var.image_ngx}"
      size  = "100"
    }
  }

  network_interface {
    subnetwork = "projects/${var.vpchost_project_id}/regions/${each.value.region}/subnetworks/${var.project_name}-lba"
    network_ip = "${each.value.ipAddress}"
  }

  depends_on = ["google_compute_disk.tu_production_disk"]

  service_account {
    email  = "stackdriver@usep10-28361.iam.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/cloud-platform", ]
  }

}

resource "google_compute_instance" "dcs_mgt" {
  for_each = "${var.vm_dcs_mgt}"

  project             = "${var.project_id}"
  name                = "${each.value.serverName}"
  machine_type        = "${var.standard_machine_type_4}"
  zone                = "${each.value.zone}"
  hostname            = "${each.value.serverName}.${var.project_name}.com"
  deletion_protection = "${var.deletion_protection}"

  tags = ["${var.project_name}", "${var.project_name}mgt", "${var.project_name}mgtdcs"]

  shielded_instance_config {
    enable_secure_boot          = var.enable_secure_boot
    enable_vtpm                 = var.enable_vtpm
    enable_integrity_monitoring = var.enable_integrity_monitoring
  }

  boot_disk {
    initialize_params {
      image = "${var.image_dcs}"
      size  = "50"
    }
  }

  network_interface {
    subnetwork = "projects/${var.vpchost_project_id}/regions/${each.value.region}/subnetworks/${var.project_name}-mgt"
    network_ip = "${each.value.ipAddress}"
  }

  depends_on = ["google_compute_disk.tu_production_disk"]

  service_account {
    email  = "stackdriver@usep10-28361.iam.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/cloud-platform", ]
  }

}

resource "google_compute_instance" "mgt_mgt" {
  for_each = "${var.vm_mgt_mgt}"

  project             = "${var.project_id}"
  name                = "${each.value.serverName}"
  machine_type        = "${var.standard_machine_type_4}"
  zone                = "${each.value.zone}"
  hostname            = "${each.value.serverName}.${var.project_name}.com"
  deletion_protection = "${var.deletion_protection}"

  tags = ["${var.project_name}", "${var.project_name}mgt", "${var.project_name}mgtmgt"]

  shielded_instance_config {
    enable_secure_boot          = var.enable_secure_boot
    enable_vtpm                 = var.enable_vtpm
    enable_integrity_monitoring = var.enable_integrity_monitoring
  }

  boot_disk {
    initialize_params {
      image = "${var.image_mgt}"
      size  = "100"
    }
  }

  attached_disk {
    source = "${each.value.disk}"
  }

  network_interface {
    subnetwork = "projects/${var.vpchost_project_id}/regions/${each.value.region}/subnetworks/${var.project_name}-mgt"
    network_ip = "${each.value.ipAddress}"
  }

  depends_on = ["google_compute_disk.tu_production_disk"]

  service_account {
    email  = "stackdriver@usep10-28361.iam.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/cloud-platform", ]
  }
}

resource "google_compute_instance" "utl_mgt" {
  for_each = "${var.vm_utl_mgt}"

  project             = "${var.project_id}"
  name                = "${each.value.serverName}"
  machine_type        = "${var.standard_machine_type_4}"
  zone                = "${each.value.zone}"
  hostname            = "${each.value.serverName}.${var.project_name}.com"
  deletion_protection = "${var.deletion_protection}"

  tags = ["${var.project_name}", "${var.project_name}mgt", "${var.project_name}mgtutl"]

  shielded_instance_config {
    enable_secure_boot          = var.enable_secure_boot
    enable_vtpm                 = var.enable_vtpm
    enable_integrity_monitoring = var.enable_integrity_monitoring
  }

  boot_disk {
    initialize_params {
      image = "${var.image_utl}"
      size  = "150"
    }
  }

  attached_disk {
    source = "${each.value.disk}"
  }

  network_interface {
    subnetwork = "projects/${var.vpchost_project_id}/regions/${each.value.region}/subnetworks/${var.project_name}-mgt"
    network_ip = "${each.value.ipAddress}"
  }

  depends_on = ["google_compute_disk.tu_production_disk"]

  service_account {
    email  = "stackdriver@usep10-28361.iam.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/cloud-platform", ]
  }

}

/*****************************************
  Disk Setup
 *****************************************/

resource "google_compute_disk" "tu_production_disk" {
  for_each = "${var.disk_tu}"

  name = "${each.value.name}"
  type = "${each.value.type}"
  zone = "${each.value.zone}"
  size = "${each.value.size}"
}

/*****************
customed roles
*****************/

resource "google_project_iam_member" "tu-owners" {
  project = "${var.project_id}"
  role    = "roles/owner"
  member  = "group:${var.tu_owners_dl}"
}

resource "google_project_iam_member" "tu-developers" {
  count   = "${length(var.dev_roles)}"
  role    = "${element(var.dev_roles, count.index)}"
  project = "${var.project_id}"
  member  = "group:${var.tu_developers_dl}"
}

resource "google_compute_instance" "rss_mgt" {
  for_each = "${var.vm_rss_mgt}"

  project             = "${var.project_id}"
  name                = "${each.value.serverName}"
  machine_type        = "${var.standard_machine_type_4}"
  zone                = "${each.value.zone}"
  hostname            = "${each.value.serverName}.${var.project_name}.com"
  deletion_protection = "${var.deletion_protection}"

  tags = ["${var.project_name}", "${var.project_name}mgt", "${var.project_name}mgtrss"]

  boot_disk {
    initialize_params {
      image = "${var.image_rss}"
      size  = "200"
    }
  }

  network_interface {
    subnetwork = "projects/${var.vpchost_project_id}/regions/${each.value.region}/subnetworks/${var.project_name}-mgt"
    network_ip = "${each.value.ipAddress}"
  }

}

/***********************************************
VM Creation
*********************************************/
resource "google_compute_instance" "vm" {

  for_each = local.vm_list

  project                   = "${var.project_id}"
  name                      = "${var.project_name}${each.value.name}"
  machine_type              = each.value.machine_type
  zone                      = each.value.zone
  hostname                  = "${each.value.hostname}"
  allow_stopping_for_update = true
  deletion_protection       = true

  tags = split(" ", "${each.value.tag}")

  boot_disk {
    initialize_params {
      image = each.value.bootimage
      size  = each.value.bootdisksize
    }
  }
  network_interface {
    subnetwork = "projects/${var.vpchost_project_id}/regions/${each.value.region}/subnetworks/${each.value.subnetname}"
    network_ip = each.value.ip
  }

  dynamic attached_disk {
    for_each = compact([each.value.disk])
    content {
      source = attached_disk.value
    }
  }

  #metadata = {
  #  "serial-port-enable" = true
  #}

}

/*************************
GKE Setup
*************************/

# Service Account for the GKE
resource "google_service_account" "gke_node_default" {
  account_id   = "gke-node-default"
  display_name = "GKE Node Default Pool Service Account"
  project      = var.project_id
}

module "tu-mod" {
  source                     = "terraform-google-modules/kubernetes-engine/google//modules/beta-private-cluster"
  version                    = "12.3.0"
  project_id                 = "${var.project_id}"
  kubernetes_version         = "1.17.13-gke.2001"
  name                       = "tu-mod"
  region                     = "us-east4"
  zones                      = ["us-east4-a", "us-east4-b"]
  network_project_id         = "${var.vpchost_project_id}"
  network                    = "sh-network-prod-vpc"
  subnetwork                 = "usep10-dmz-be"
  ip_range_pods              = "usep10-dmz-be-1"
  ip_range_services          = "usep10-dmz-be-2"
  http_load_balancing        = true
  horizontal_pod_autoscaling = true
  network_policy             = true
  enable_private_endpoint    = true
  enable_private_nodes       = true
  master_ipv4_cidr_block     = "${var.hosted_master_cidr}"
  istio                      = false
  cloudrun                   = false
  create_service_account     = true
  default_max_pods_per_node  = 30
  master_authorized_networks = [
    { cidr_block = "10.171.20.0/24", display_name = "master-auth-net" }
  ]

  node_pools = [
    {
      name               = "default-node-pool"
      machine_type       = "n1-standard-8"
      node_locations     = "us-east4-a,us-east4-b"
      min_count          = 2
      max_count          = 4
      local_ssd_count    = 0
      disk_size_gb       = 100
      disk_type          = "pd-ssd"
      image_type         = "COS"
      auto_repair        = true
      auto_upgrade       = false
      service_account    = google_service_account.gke_node_default.email
      preemptible        = false
      initial_node_count = 2
    },
  ]

  node_pools_oauth_scopes = {
    all = []

    default-node-pool = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/userinfo.email",
    ]
  }

  node_pools_labels = {
    all = {}

    default-node-pool = {
      default-node-pool = true
    }
  }

  node_pools_metadata = {
    all = {}
  }

  node_pools_taints = {
    all = []

    default-node-pool = [
      {
        key    = "default-node-pool"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
  }

  node_pools_tags = {
    all = []

    default-node-pool = [
      "default-node-pool",
    ]
  }
}

##########################################
#Security Policy for Cloud Armor
##########################################

resource "google_compute_security_policy" "policy" {

  name = "tu-policy"

  dynamic rule {
    for_each = local.security_rule_list
    content {
      action   = rule.value.action
      priority = rule.value.priority
      match {
        versioned_expr = "SRC_IPS_V1"
        config {
          src_ip_ranges = [rule.value.src_ip_ranges]
        }
      }
      description = rule.value.description
    }
  }
}

/* DEVOPS-960 */

/* update akaima fw */

/* trigger */