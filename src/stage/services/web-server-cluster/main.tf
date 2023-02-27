terraform {

  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    key    = "stage/services/webserver-cluster/terraform.tfstate"
  }
}

provider "aws" {
    region = "us-east-2"
}


module "webserver_cluster" {
    source = "../../../../modules/services/web-server-cluster"
    cluster_name = var.cluster_name
    db_remote_state_bucket = var.db_remote_state_bucket
    db_remote_state_key = var.db_remote_state_key
}
