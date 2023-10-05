variable "region" {
  type = string
}
/*****************************************
  Network and Subnetwork
*****************************************/
variable "sh_network_prod_subnets" {
  description = "The definition of the subnets"
  type        = map(map(string))
}

/*************************
  Security Group
 *************************/
variable "security_group" {
  description = "The definition of the subnets security group"
  type        = list(object({
    name         = string
    description  = string
  }))
  default     = []
}

/*variable "sg_rules" {
  description = "The definition of the sg rules"
  type        = map(map(string))
}*/