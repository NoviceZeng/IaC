project_id = "usep10-28361"

project_name = "usep10"

vpchost_project_id = "sh-network-prod-45166"

/********************************
Machine Type
*********************************/

highmem_machine_type     = "e2-highmem-4"
custom_sql_standard_type = "e2-highmem-8"
custom_sql_backup_type   = "e2-highmem-8"
standard_machine_type    = "e2-standard-8"
standard_machine_type_4  = "e2-standard-4"

/********************************
Image Template
*********************************/

# image_mxx = "projects/usee05-28473/global/machineImages/e05-win2k12r2-initial"
# image_crl = "projects/usee05-28473/global/machineImages/e05-win2k12r2-initial"
# image_syn = "projects/usee05-28473/global/machineImages/e05-win2k12r2-initial"
# image_sys = "projects/usee05-28473/global/machineImages/e05-win2k12r2-initial"


image_mxx = "windows-cloud/windows-2012-r2"
image_crl = "windows-cloud/windows-2012-r2"
image_syn = "windows-cloud/windows-2012-r2"
image_sys = "windows-cloud/windows-2012-r2"
image_mts = "windows-cloud/windows-2012-r2"
image_fls = "windows-cloud/windows-2012-r2"
image_app = "projects/usep10-28361/global/images/usep10app"
image_sch = "projects/usep10-28361/global/images/usep10sch"
image_mgt = "centos-cloud/centos-8-v20200618"
image_ngx = "centos-cloud/centos-8-v20200618"
image_dcs = "windows-cloud/windows-2016"
image_rss = "usee01-56343/image-3"


/********************************
Frontend ZONE
*********************************/

vm_app_dmz_fe = {
  vm0 = {
    serverName = "usep10app001",
    ipAddress  = "10.171.16.16",
    region     = "us-east4",
    zone       = "us-east4-a",
    subnet     = "usep10-dmz-fe",
  }

  vm1 = {
    serverName = "usep10app002",
    ipAddress  = "10.171.16.17",
    region     = "us-east4",
    zone       = "us-east4-a",
    subnet     = "usep10-dmz-fe",
  }

  vm2 = {
    serverName = "usep10app003",
    ipAddress  = "10.171.16.18",
    region     = "us-east4",
    zone       = "us-east4-a",
    subnet     = "usep10-dmz-fe",
  }

  vm1 = {
    serverName  = "usep10fln002",
    ipAddress   = "10.171.18.61",
    region      = "us-east4",
    zone        = "us-east4-b",
    subnet      = "usep10-dmz-be",
    disk        = "fln002-disk-data",
    machineType = "e2-custom-6-32768"
  }
}
  vm1 = {
    serverName = "usep10dmz002",
    ipAddress  = "10.171.18.81",
    region     = "us-east4",
    zone       = "us-east4-b",
    subnet     = "usep10-dmz-be",
  }
}

vm_aut_dmz_be = {
  vm0 = {
    serverName = "usep10aut001",
    ipAddress  = "10.171.18.85",
    region     = "us-east4",
    zone       = "us-east4-a",
    subnet     = "usep10-dmz-be",
  }
}

/********************************
DB ZONE
*********************************/

vm_sql_db = {
  vm0 = {
    serverName  = "usep10sql011",
    ipAddress   = "10.171.25.16",
    machineType = "n1-highmem-64",
    region      = "us-east4",
    zone        = "us-east4-a",
    subnet      = "usep10-db",
    disk_data   = "sql011-disk-data"
    disk_temp   = "sql011-disk-temp"
    disk_log    = "sql011-disk-log"
  }

  vm1 = {
    serverName  = "usep10sql012",
    ipAddress   = "10.171.25.17",
    machineType = "custom-40-266240",
    region      = "us-east4",
    zone        = "us-east4-a",
    subnet      = "usep10-db",
    disk_data   = "sql012-disk-data"
    disk_temp   = "sql012-disk-temp"
    disk_log    = "sql012-disk-log"
  }

  vm2 = {
    serverName = "usep10sql013",
    ipAddress  = "10.171.25.18",
    #machineType = "custom-40-262144",
    machineType = "custom-40-262144-ext",
    region      = "us-east4",
    zone        = "us-east4-a",
    subnet      = "usep10-db",
    disk_data   = "sql013-disk-data"
    disk_temp   = "sql013-disk-temp"
    disk_log    = "sql013-disk-log"
  }

  vm1 = {
    serverName  = "usep10sql002",
    ipAddress   = "10.171.25.26",
    machineType = "custom-40-262144",
    region      = "us-east4",
    zone        = "us-east4-a",
    subnet      = "usep10-db",
    disk_data   = "sql002-disk-data"
  }
}

vm_cbq_db = {
  vm0 = {
    serverName = "usep10cbq001",
    ipAddress  = "10.171.25.30",
    region     = "us-east4",
    zone       = "us-east4-a",
    subnet     = "usep10-db",
    disk_data  = "cbq001-disk-data"
  }
  vm1 = {
    serverName = "usep10cbq002",
    ipAddress  = "10.171.25.31",
    region     = "us-east4",
    zone       = "us-east4-a",
    subnet     = "usep10-db",
    disk_data  = "cbq002-disk-data"
  }
}

vm_cbn_db = {
  vm0 = {
    serverName = "usep10cbn001",
    ipAddress  = "10.171.25.35",
    region     = "us-east4",
    zone       = "us-east4-a",
    subnet     = "usep10-db",
    disk_data  = "cbn001-disk-data"
  }

  vm1 = {
    serverName = "usep10cbn002",
    ipAddress  = "10.171.25.36",
    region     = "us-east4",
    zone       = "us-east4-a",
    subnet     = "usep10-db",
    disk_data  = "cbn002-disk-data"
  }

  vm2 = {
    serverName = "usep10cbn003",
    ipAddress  = "10.171.25.37",
    region     = "us-east4",
    zone       = "us-east4-a",
    subnet     = "usep10-db",
    disk_data  = "cbn003-disk-data"
  }

  vm3 = {
    serverName = "usep10cbn004",
    ipAddress  = "10.171.25.38",
    region     = "us-east4",
    zone       = "us-east4-a",
    subnet     = "usep10-db",
    disk_data  = "cbn004-disk-data"
  }

}

vm_ngx_lba = {
  vm0 = {
    serverName = "usep10ngx001",
    ipAddress  = "10.171.21.40",
    region     = "us-east4",
    zone       = "us-east4-a",
    subnet     = "usep10-lba",
  }

  vm1 = {
    serverName = "usep10ngx002",
    ipAddress  = "10.171.21.41",
    region     = "us-east4",
    zone       = "us-east4-b",
    subnet     = "usep10-lba",
  }
}

vm_dcs_mgt = {
  vm0 = {
    serverName = "usep10dcs001",
    ipAddress  = "10.171.20.16",
    region     = "us-east4",
    zone       = "us-east4-a",
    subnet     = "usep10-mgt",
  }

  vm1 = {
    serverName = "usep10dcs002",
    ipAddress  = "10.171.20.17",
    region     = "us-east4",
    zone       = "us-east4-b",
    subnet     = "usep10-mgt",
  }
}

vm_utl_mgt = {
  vm0 = {
    serverName = "usep10utl001",
    ipAddress  = "10.171.20.18",
    region     = "us-east4",
    zone       = "us-east4-a",
    subnet     = "usep10-mgt",
    disk       = "utl001-disk-data"
  }

  vm1 = {
    serverName = "usep10utl002",
    ipAddress  = "10.171.20.19",
    region     = "us-east4",
    zone       = "us-east4-b",
    subnet     = "usep10-mgt",
    disk       = "utl002-disk-data"
  }
}

vm_mgt_mgt = {
  vm0 = {
    serverName = "usep10mgt001",
    ipAddress  = "10.171.20.20",
    region     = "us-east4",
    zone       = "us-east4-a",
    subnet     = "usep10-mgt",
    disk       = "mgt001-disk-data"
  }

  vm1 = {
    serverName = "usep10mgt002",
    ipAddress  = "10.171.20.21",
    region     = "us-east4",
    zone       = "us-east4-b",
    subnet     = "usep10-mgt",
    disk       = "mgt002-disk-data"
  }
}

vm_rss_mgt = {
  vm0 = {
    serverName = "usep10rss001",
    ipAddress  = "10.171.20.22",
    region     = "us-east4",
    zone       = "us-east4-a",
    subnet     = "usep10-mgt",
  }
}

disk_tu = {
  cbq001-disk-data = {
    name = "cbq001-disk-data",
    type = "pd-standard",
    zone = "us-east4-a",
    size = "2048",
  }

  

  sql013-disk-temp = {
    name = "sql013-disk-temp",
    type = "pd-ssd",
    zone = "us-east4-a",
    size = "1024",
  }

  sql013-disk-log = {
    name = "sql013-disk-log",
    type = "pd-ssd",
    zone = "us-east4-a",
    size = "512",
  }

  sql013-disk-data = {
    name = "sql013-disk-data",
    type = "pd-standard",
    zone = "us-east4-a",
    size = "5632",
  }

  sql014-disk-temp = {
    name = "sql014-disk-temp",
    type = "pd-ssd",
    zone = "us-east4-b",
    size = "1024",
  }

  sql015-disk-temp = {
    name = "sql015-disk-temp",
    type = "pd-ssd",
    zone = "us-east4-a",
    size = "1024",
  }

  sql015-disk-log = {
    name = "sql015-disk-log",
    type = "pd-ssd",
    zone = "us-east4-a",
    size = "512",
  }

  sql015-disk-data = {
    name = "sql015-disk-data",
    type = "pd-standard",
    zone = "us-east4-a",
    size = "5632",
  }

  sql016-disk-temp = {
    name = "sql016-disk-temp",
    type = "pd-ssd",
    zone = "us-east4-a",
    size = "1024",
  }

  sql017-disk-log = {
    name = "sql017-disk-log",
    type = "pd-ssd",
    zone = "us-east4-a",
    size = "512",
  }

  sql017-disk-data = {
    name = "sql017-disk-data",
    type = "pd-standard",
    zone = "us-east4-a",
    size = "5632",
  }
}

hosted_master_cidr = "10.171.28.0/28"