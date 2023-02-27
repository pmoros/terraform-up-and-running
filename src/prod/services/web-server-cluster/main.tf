terraform {
  backend "s3" {
    key    = "prod/services/webserver-cluster/terraform.tfstate"
  }
}

provider "aws" {
    region = "us-east-2"
}


module "webserver_cluster" {
    source = "../../../modules/services/web-server-cluster"
    cluster_name = "webservers-prod"
    db_remote_state_bucket = "paul-moros-terraform-up-and-running-state"
    db_remote_state_key = "prod/data-stores/mysql/terraform.tfstate"
}
