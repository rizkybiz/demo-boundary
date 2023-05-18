# DEMO-BOUNDARY

## Prerequisites

- [HashiCorp Cloud Platform](https://portal.cloud.hashicorp.com/sign-in) Client ID and Secret
- Docker installed locally
- Terraform CLI version 1.4.6 installed locally
- Boundary CLI version 0.12.2 or greater installed locally

## Steps to Run

1. Clone this repo: `git clone git@github.com:rizkybiz/demo-boundary.git`
2. Move into repo directory: `cd demo-boundary`
3. Initialize Terraform: `terraform init`
4. Set Terraform variables
5. Apply Terraform: `terraform apply`

## Variables

| Terraform Variable |          ENV_VAR         |                Description               |
|:------------------:|:------------------------:|:----------------------------------------:|
| boundary_username  | TF_VAR_boundary_username | Initial Boundary authentication username |
| boundary_password  | TF_VAR_boundary_password | Initial Boundary authentication password |
| hcp_client_id      | TF_VAR_hcp_client_id     | HCP Service Principle Client ID          |
| hcp_client_secret  | TF_VAR_hcp_client_secret | HCP Service Principle Client Secret      |