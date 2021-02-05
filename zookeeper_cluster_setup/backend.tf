terraform {
  backend "s3" {
    key    = "zookeeper/terraform.tfstate"
    region = "eu-central-1"
  }
}