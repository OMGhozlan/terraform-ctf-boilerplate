terraform {
  required_version = ">= 1.0"

  required_providers {
    ctfchallenge = {
      source  = "OMGhozlan/ctfchallenge"
      version = "1.0.4"
    }

    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}