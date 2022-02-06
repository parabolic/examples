locals {
  region      = "europe-west3"
  name_prefix = "cloudlad"
  name        = "${local.name_prefix}-${random_pet.name.id}"
}

