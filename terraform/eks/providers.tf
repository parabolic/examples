provider "aws" {
  version = "~> 2.27.0"

  profile = local.profile
  region  = local.region
}
