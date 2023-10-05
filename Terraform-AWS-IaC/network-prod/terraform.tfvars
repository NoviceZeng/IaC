/******************************************
  Project General Vars
 *****************************************/
region = "us-west-2"

# Subnets
sh_network_prod_subnets = {
  subnet1 = {
    subnet_name   = "used01subnet1"
    subnet_ip     = "10.0.1.0/24"
  }

  subnet2 = {
    subnet_name   = "used01subnet2"
    subnet_ip     = "10.0.2.0/24"
  }

  subnet3 = {
    subnet_name   = "used01subnet3"
    subnet_ip     = "10.0.3.0/24"
  }
}

/*************************
  Security Group
 *************************/
 
security_group     = [
  {
    name        = "prod_app1_sg"
    description = "Allow TLS inbound traffic"
  },
  {
    name        = "prod_app2_sg"
    description = "Allow TLS inbound traffic"
  },
]
