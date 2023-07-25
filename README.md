# DEMO-BOUNDARY

## Prerequisites

- [HashiCorp Cloud Platform](https://portal.cloud.hashicorp.com/sign-in) Client ID and Secret
  - In order to access the project level, create the service principal at the org level
- Docker installed locally
- Terraform CLI version 1.4.6 installed locally
- Boundary CLI version 0.12.2 or greater installed locally

## Steps to Run

1. Clone this repo: `git clone git@github.com:rizkybiz/demo-boundary.git`
2. Move into repo directory: `cd demo-boundary`
3. Move into the `infra` directory: `cd infra`
4. Initialize Terraform: `terraform init`
5. Set Terraform variables
6. Apply Terraform: `terraform apply`
7. Move into the `platform_config` directory: `cd ../platform_config`
8. Initialize Terraform: `terraform init`
5. Set Terraform variables
6. Apply Terraform: `terraform apply`
7. Set ENV VAR for Boundary url from output: `export BOUNDARY_ADDR=<address from output>`
8. Authenticate with Boundary: `boundary authenticate password -login-name=<provided boundary username variable>`

## Variables

| Terraform Variable |          ENV_VAR         |                Description               |
|:------------------:|:------------------------:|:----------------------------------------:|
| boundary_username  | TF_VAR_boundary_username | Initial Boundary authentication username |
| boundary_password  | TF_VAR_boundary_password | Initial Boundary authentication password |
| hcp_client_id      | TF_VAR_hcp_client_id     | HCP Service Principle Client ID          |
| hcp_client_secret  | TF_VAR_hcp_client_secret | HCP Service Principle Client Secret      |