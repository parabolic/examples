## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1 |
| <a name="requirement_google"></a> [google](#requirement\_google) | 4.5.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | 4.5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 4.5.0 |
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | 4.5.0 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.1.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.1.0 |
| <a name="provider_time"></a> [time](#provider\_time) | 0.7.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google-beta_google_container_node_pool.this](https://registry.terraform.io/providers/hashicorp/google-beta/4.5.0/docs/resources/google_container_node_pool) | resource |
| [google_compute_network.this](https://registry.terraform.io/providers/hashicorp/google/4.5.0/docs/resources/compute_network) | resource |
| [google_compute_subnetwork.cluster](https://registry.terraform.io/providers/hashicorp/google/4.5.0/docs/resources/compute_subnetwork) | resource |
| [google_container_cluster.primary](https://registry.terraform.io/providers/hashicorp/google/4.5.0/docs/resources/container_cluster) | resource |
| [google_project.this](https://registry.terraform.io/providers/hashicorp/google/4.5.0/docs/resources/project) | resource |
| [google_project_iam_member.this](https://registry.terraform.io/providers/hashicorp/google/4.5.0/docs/resources/project_iam_member) | resource |
| [google_project_service.this](https://registry.terraform.io/providers/hashicorp/google/4.5.0/docs/resources/project_service) | resource |
| [google_service_account.k8s](https://registry.terraform.io/providers/hashicorp/google/4.5.0/docs/resources/service_account) | resource |
| [google_service_account.this](https://registry.terraform.io/providers/hashicorp/google/4.5.0/docs/resources/service_account) | resource |
| [google_service_account_iam_binding.k8s](https://registry.terraform.io/providers/hashicorp/google/4.5.0/docs/resources/service_account_iam_binding) | resource |
| [local_file.k8s](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [random_integer.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) | resource |
| [random_pet.name](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |
| [time_sleep.wait_5_seconds](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [google_compute_zones.available](https://registry.terraform.io/providers/hashicorp/google/4.5.0/docs/data-sources/compute_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_billing_account"></a> [billing\_account](#input\_billing\_account) | n/a | `string` | n/a | yes |
| <a name="input_folder_id"></a> [folder\_id](#input\_folder\_id) | n/a | `string` | `""` | no |
| <a name="input_k8s_namespace"></a> [k8s\_namespace](#input\_k8s\_namespace) | n/a | `string` | `"cloudlad"` | no |
| <a name="input_k8s_script_path"></a> [k8s\_script\_path](#input\_k8s\_script\_path) | n/a | `string` | `null` | no |
| <a name="input_k8s_service_account"></a> [k8s\_service\_account](#input\_k8s\_service\_account) | n/a | `string` | `"cloudlad"` | no |

## Outputs

No outputs.
