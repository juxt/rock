all: plan

fmt:
	terraform fmt

plan: fmt
	terraform plan -out proposed.plan

apply:
	terraform apply proposed.plan

destroy:
	terraform destroy
