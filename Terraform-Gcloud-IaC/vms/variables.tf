variable "project_id" {
  description = "ID of the GCP project"
}

variable "deletion_protection" {
  description = "Enable Secure deletion_protection in Shielded VM"
  default     = true
}

variable "project_name" {
  description = "Name of the GCP project"
}

/******************************************
  Network and Subnetwork
*****************************************/
variable "vpchost_project_id" {
  description = "ID of the GCP project VPC"
}

/*****************************************
  Subnet
*****************************************/
variable "disk_tu" {
  description = "The disk used in the project"
  type        = "map"
}
variable "vm_app_dmz_fe" {
  description = "The definition of the VM used in the project"
  type        = "map"
}

variable "vm_mxx_dmz_fe" {
  description = "The definition of the VM used in the project"
  type        = "map"
}

variable "vm_sch_dmz_be" {
  description = "The definition of the VM used in the project"
  type        = "map"
}

variable "vm_crl_dmz_be" {
  description = "The definition of the VM used in the project"
  type        = "map"
}

variable "vm_syn_dmz_be" {
  description = "The definition of the VM used in the project"
  type        = "map"
}

variable "vm_sys_dmz_be" {
  description = "The definition of the VM used in the project"
  type        = "map"
}

variable "vm_fln_dmz_be" {
  description = "The definition of the VM used in the project"
  type        = "map"
}

variable "vm_fls_dmz_be" {
  description = "The definition of the VM used in the project"
  type        = "map"
}

variable "vm_tts_dmz_be" {
  description = "The definition of the VM used in the project"
  type        = "map"
}

variable "vm_mts_dmz_be" {
  description = "The definition of the VM used in the project"
  type        = "map"
}

variable "vm_aut_dmz_be" {
  description = "The definition of the VM used in the project"
  type        = "map"
}

variable "vm_aum_dmz_be" {
  description = "The definition of the VM used in the project"
  type        = "map"
}

variable "vm_sql_db" {
  description = "The definition of the VM used in the project"
  type        = "map"
}

variable "vm_sql_db_bk" {
  description = "The definition of the VM used in the project"
  type        = "map"
}

variable "vm_cbq_db" {
  description = "The definition of the VM used in the project"
  type        = "map"
}

variable "vm_cbn_db" {
  description = "The definition of the VM used in the project"
  type        = "map"
}

variable "vm_ngx_lba" {
  description = "The definition of the VM used in the project"
  type        = "map"
}

variable "vm_dcs_mgt" {
  description = "The definition of the VM used in the project"
  type        = "map"
}

variable "vm_mgt_mgt" {
  description = "The definition of the VM used in the project"
  type        = "map"
}

variable "vm_rss_mgt" {
  description = "The definition of the VM used in the project"
  type        = "map"
}

variable "vm_utl_mgt" {
  description = "The definition of the VM used in the project"
  type        = "map"
}




/*****************************************
  VM Image
*****************************************/

variable "image_app" {
  description = "APP role VM image used by Ticket Util"
}

variable "image_mxx" {
  description = "SCH role VM image used by Ticket Util"
}

variable "image_sch" {
  description = "MGT role VM image used by Ticket Util"
}

variable "image_crl" {
  description = "SCH role VM image used by Ticket Util"
}

variable "image_syn" {
  description = "MGT role VM image used by Ticket Util"
}

variable "image_sys" {
  description = "SCH role VM image used by Ticket Util"
}

variable "image_fln" {
  description = "MGT role VM image used by Ticket Util"
}

variable "image_fls" {
  description = "SCH role VM image used by Ticket Util"
}

variable "image_tts" {
  description = "MGT role VM image used by Ticket Util"
}

variable "image_mts" {
  description = "SCH role VM image used by Ticket Util"
}

variable "image_aut" {
  description = "MGT role VM image used by Ticket Util"
}

variable "image_aum" {
  description = "SCH role VM image used by Ticket Util"
}

variable "image_sql" {
  description = "MGT role VM image used by Ticket Util"
}

variable "image_cbq" {
  description = "SCH role VM image used by Ticket Util"
}

variable "image_cbn" {
  description = "MGT role VM image used by Ticket Util"
}

variable "image_mgt" {
  description = "SCH role VM image used by Ticket Util"
}

variable "image_utl" {
  description = "MGT role VM image used by Ticket Util"
}

variable "image_ngx" {
  description = "NGX role VM image used by Ticket Util"
}

variable "image_dcs" {
  description = "NGX role VM image used by Ticket Util"
}

variable "image_rss" {
  description = "rss role VM image for scanner"
}

variable "highmem_machine_type" {
  description = "MGT role VM image used by Ticket Util"
}

variable "custom_sql_standard_type" {
  description = "MGT role VM image used by Ticket Util"
}

variable "custom_sql_backup_type" {
  description = "MGT role VM image used by Ticket Util"
}

variable "standard_machine_type" {
  description = "MGT role VM image used by Ticket Util"
}

variable "standard_machine_type_4" {
  description = "MGT role VM image used by Ticket Util"
}

variable "enable_secure_boot" {
  description = "Enable Secure Boot feature in Shielded VM?"
  default     = true
}

variable "enable_vtpm" {
  description = "Enable Virtual TPM feature in Shielded VM?"
  default     = true
}

variable "enable_integrity_monitoring" {
  description = "Enable Integrity Monitoring feature in Shielded VM?"
  default     = true
}

variable "dev_roles" {
  description = "roles list for the TU developers"
  type        = list
  default = [
    "roles/viewer",
    "roles/compute.instanceAdmin",
    "roles/monitoring.editor",
    "roles/iap.tunnelResourceAccessor"
  ]
}

variable "tu_owners_dl" {
  type        = "string"
  description = "DL for TU Owners"
  default     = "dl-sh-tuowners@stubmain.cloud"
}

variable "tu_developers_dl" {
  type        = "string"
  description = "DL for TU Developers"
  default     = "dl-sh-tudevelopers@stubmain.cloud"
}

variable "hosted_master_cidr" {
  description = "TU GKE Master CIDR"
}
