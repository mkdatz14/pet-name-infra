# pet-name-infra

Basic app for deploying an example pet name resource.

## Targeted HCP Terraform applies

This repository includes a manual GitHub Actions workflow at `.github/workflows/hcp-terraform-targeted-apply.yml` that queues a run for exactly one HCP Terraform workspace. It is intended to sit alongside the existing VCS connection so you can trigger a single deployment such as `dev2` or `staging3` without applying the other workspaces in the same environment.

### Required GitHub configuration

Add these repository settings before using the workflow:

- Repository secret `HCP_TERRAFORM_TEAM_TOKEN`: an HCP Terraform user or team token with permission to read workspaces and queue/apply runs. Organization tokens are not accepted by the runs API.
- Repository variable `HCP_TERRAFORM_ORG`: your HCP Terraform organization name.
- Repository variable `HCP_TERRAFORM_WORKSPACE_MAP`: a JSON object that maps a deployment key to a concrete workspace name.

Example `HCP_TERRAFORM_WORKSPACE_MAP`:

```json
{
	"dev1": "pet-name-dev-1",
	"dev2": "pet-name-dev-2",
	"dev3": "pet-name-dev-3",
	"staging1": "pet-name-staging-1",
	"staging2": "pet-name-staging-2",
	"staging3": "pet-name-staging-3",
	"prod1": "pet-name-prod-1",
	"prod2": "pet-name-prod-2",
	"prod3": "pet-name-prod-3"
}
```

### How it works

1. You run the workflow manually from GitHub Actions.
2. You choose the environment, deployment number, and whether the run should auto-apply.
3. The workflow resolves the selected key, such as `dev2`, to a single workspace name from `HCP_TERRAFORM_WORKSPACE_MAP`.
4. It checks that the target workspace does not already have a non-final run.
5. It queues a run through the HCP Terraform Runs API using the workspace's current VCS-backed configuration version.

Because the workflow only creates a run for the selected workspace, it does not fan out to the other workspace deployments.
