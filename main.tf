terraform {
  required_version = ">= 1.2.9"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.34.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket = "vln-project-terraforrm-state"
    key    = "devops_test/terraform.tfstate"
    region = "ca-central-1"
  }
}
