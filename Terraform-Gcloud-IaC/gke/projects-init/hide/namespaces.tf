variable "namespaces" {
  description = "a map of all the namespaces and their permissions, 'team' and 'name' are used for organization purposes. 'users' and 'groups' are used for RBAC permissions"
  type = map(object({
    name      = string
    team      = string
    users = list(string)
    groups = list(string)
  }))
  default = {
    "test-ns" =  {
       name    = "Finance Tools"
       team    = "finance"
       users   = ["yingyigu@stubmain.cloud"]
       groups  = []
    }
   "jenkins" =  {
       name    = "Jenkins CICD"
       team    = "cloud-infra"
       users   = ["yingyigu@stubmain.cloud"]
       groups  = []
    }
    "catalog-ns" =  {
       name    = "Catalog"
       team    = "Catalog-team"
       users   = []
       groups  = ["dl-sh-catalog@stubmain.cloud"]
    }
    "ce-ns" =  {
       name    = "CE"
       team    = "CE-team"
       users   = []
       groups  = ["dl-sh-ce@stubmain.cloud"]
    }
    "checkout-ns" =  {
       name    = "Checkout"
       team    = "Checkout-team"
       users   = []
       groups  = ["dl-sh-checkout@stubmain.cloud"]
    }
    "content-ns" =  {
       name    = "Content"
       team    = "Content-team"
       users   = []
       groups  = ["dl-sh-content@stubmain.cloud"]
    }
    "crm-ns" =  {
       name    = "CRM"
       team    = "CRM-team"
       users   = []
       groups  = ["dl-sh-crm@stubmain.cloud"]
    }
    "data-platform-ns" =  {
       name    = "Data-Platform"
       team    = "Data-Platform-team"
       users   = []
       groups  = ["dl-sh-dataplatform@stubmain.cloud"]
    }
    "findb-ns" =  {
       name    = "FINDB"
       team    = "FINDB-team"
       users   = []
       groups  = ["dl-sh-findb@stubmain.cloud"]
    }
    "frontend-ns" =  {
       name    = "FrontEnd"
       team    = "FrontEnd-team"
       users   = []
       groups  = ["dl-sh-frontend@stubmain.cloud"]
    }
    "fulfillment-ns" =  {
       name    = "Fulfillment"
       team    = "Fulfillment-team"
       users   = []
       groups  = ["dl-sh-fulfillment@stubmain.cloud"]
    }
    "identity-ns" =  {
       name    = "Identity"
       team    = "Identity-team"
       users   = []
       groups  = ["dl-sh-identity@stubmain.cloud"]
    }
    "international-ns" =  {
       name    = "International"
       team    = "International-team"
       users   = []
       groups  = ["dl-sh-international@stubmain.cloud"]
    }
    "martech-ns" =  {
       name    = "MarTech"
       team    = "MarTech-team"
       users   = []
       groups  = ["dl-sh-martech@stubmain.cloud"]
    }
    "messaging-ns" =  {
       name    = "Messaging"
       team    = "Messaging-team"
       users   = []
       groups  = ["dl-sh-messaging@stubmain.cloud"]
    }
    "ml-developers-ns" =  {
       name    = "ML-Developers"
       team    = "ML-Developers-team"
       users   = []
       groups  = ["dl-sh-mldevelopers@stubmain.cloud"]
    }
    "ml-platform-ns" =  {
       name    = "ML-Platform"
       team    = "ML-Platform-team"
       users   = []
       groups  = ["dl-sh-mlplatform@stubmain.cloud"]
    }
    "myaccountbe-ns" =  {
       name    = "MyAccountBE"
       team    = "MyAccountBE-team"
       users   = []
       groups  = ["dl-sh-myaccountbe@stubmain.cloud"]
    }
    "myaccountfe-ns" =  {
       name    = "MyAccountFE"
       team    = "MyAccountFE-team"
       users   = []
       groups  = ["dl-sh-myaccountfe@stubmain.cloud"]
    }
    "native-ns" =  {
       name    = "Native"
       team    = "Native-team"
       users   = []
       groups  = ["dl-sh-native@stubmain.cloud"]
    }
    "payments-ns" =  {
       name    = "Payments"
       team    = "Payments-team"
       users   = []
       groups  = ["dl-sh-payments@stubmain.cloud"]
    }
    "recommendation-ns" =  {
       name    = "Recommendation"
       team    = "Recommendation-team"
       users   = []
       groups  = ["dl-sh-recommendation@stubmain.cloud"]
    }
    "seat-maps-ns" =  {
       name    = "Seat-Maps"
       team    = "Seat-Maps-team"
       users   = []
       groups  = ["dl-sh-seatmaps@stubmain.cloud"]
    }
    "seo-ns" =  {
       name    = "SEO"
       team    = "SEO-team"
       users   = []
       groups  = ["dl-sh-seo@stubmain.cloud"]
    }
    "supply-ns" =  {
       name    = "Supply"
       team    = "Supply-team"
       users   = []
       groups  = ["dl-sh-supply@stubmain.cloud"]
    }
    "tns-ns" =  {
       name    = "TnS"
       team    = "TnS-team"
       users   = []
       groups  = ["dl-sh-tns@stubmain.cloud"]
    }
  #  "namespace" =  {
  #     name    = "Friendly Name" // used to annotate the namespace
  #     team    = "team-name" // used to label the namespace
  #     groups  = ["group1@domain.com", "group2@domain.com"] // used for permissions
  #     users   = ["user1@domain.com", "user2@domain.com"] // used for permissions
  #   }
 }
}

# Create all namespaces for non-prod cluster a.
resource "kubernetes_namespace" "cluster-a-non-prod-namespaces" {
  provider = kubernetes.cluster-a-non-prod
  for_each = var.namespaces
  metadata {
    annotations = {
      name = each.value.name
    }
    labels = {
      team = each.value.team
    }
    name = each.key
   }
}

# Grant default permissions for each domains namespace in cluster a.
resource "kubernetes_role_binding" "cluster-a-non-prod-domain-permissions" {
  provider = kubernetes.cluster-a-non-prod
  for_each = var.namespaces
  metadata {
    name      = "admins"
    namespace = each.key
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  dynamic "subject" {
    for_each = each.value.users
      content {
        kind      = "User"
        name      = subject.value
        api_group = "rbac.authorization.k8s.io"
      }
  }
  dynamic "subject" {
    for_each = each.value.groups
      content {
        kind      = "Group"
        name      = subject.value
        api_group = "rbac.authorization.k8s.io"
      }
  }
}

resource "kubernetes_namespace" "cluster-na-non-prod-namespaces" {
  provider = kubernetes.cluster-na-non-prod
  for_each = var.namespaces
  metadata {
    annotations = {
      name = each.value.name
    }
    labels = {
      team = each.value.team
    }
    name = each.key
   }
}

# Grant default permissions for each domains namespace in cluster a.
resource "kubernetes_role_binding" "cluster-na-non-prod-domain-permissions" {
  provider = kubernetes.cluster-na-non-prod
  for_each = var.namespaces
  metadata {
    name      = "admins"
    namespace = each.key
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  dynamic "subject" {
    for_each = each.value.users
      content {
        kind      = "User"
        name      = subject.value
        api_group = "rbac.authorization.k8s.io"
      }
  }
  dynamic "subject" {
    for_each = each.value.groups
      content {
        kind      = "Group"
        name      = subject.value
        api_group = "rbac.authorization.k8s.io"
      }
  }
}