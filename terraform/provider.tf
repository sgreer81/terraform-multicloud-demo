terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region  = "us-west-2"
  profile = "demo1"
}

provider "azurerm" {
  features {}
}

provider "cloudflare" {
  api_token = trimspace(file("~/.cloudflare_api_token"))
}
