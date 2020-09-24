locals {
  workloads = {
    team-a = {
      projects = {
        quality-assurance = {
          auto_create_network = true
          services = [
            "sql-component.googleapis.com",
          ]
        }
      }
    }
    team-b = {
      projects = {
        quality-assurance = {
          auto_create_network = false
          services = [
            "sql-component.googleapis.com",
          ]
        }
        development = {
          services = [
            "sql-component.googleapis.com",
            "pubsub.googleapis.com",
          ]
        }
      }
    }
    team-c = {
      projects = {
        production = {}
      }
    }
  }
}

module "cloudlad_org" {
  source   = "./modules/resource_management"
  for_each = local.workloads

  billing_account = var.billing_account
  folder_parent   = var.folder_parent
  folder_name     = each.key
  projects        = lookup(each.value, "projects", null)

  depends_on = [module.cloudlad_org_security]
}


locals {
  security = {
    team-x = {
      projects = {
        sec-check = {
          auto_create_network = false
        }
      }
    }
  }
}

module "cloudlad_org_security" {
  source   = "./modules/resource_management"
  for_each = local.security

  billing_account = var.billing_account
  folder_parent   = var.folder_parent
  folder_name     = each.key
  projects        = lookup(each.value, "projects", null)
}
