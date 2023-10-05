terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"

  backend "local" {
    path = "terraform.tfstate"
  }

/*  cloud {
    organization = "stubhub_nov"
    workspaces {
      name = "tf_nov"
    }
  }*/
}

# default aws provider
provider "aws" {
  region = var.region
  #access_key = ""
  #secret_key = ""
}

/********Multiple AWS Regions, default region is in aws provider that doesn`t have alias.
provider "aws" {
  alias  = "use1"
  region = "us-east-1"
}

resource "aws_instance" "east_instance" {
  provider = aws.use1

  // instance details
}
*********/