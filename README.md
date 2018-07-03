 # Test Terraform
 
 Hooks into the LW Sandbox environment
 
 ## Commands
 
 `terraform init` - sets things up
 `terraform plan -var-file=variables.tfvars -out=sandbox.out` - runs through the plan and outputs the result to a file, so it can be directly applied later
 `terraform apply sandbox.out` - apply that configuration
 
 ## Files
 
 `variables.tfvars` - use as a key/value store for variables