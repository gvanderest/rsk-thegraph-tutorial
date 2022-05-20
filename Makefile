include .env
NOW=`date +v%Y%m%d%H%M%S`

create-rsk-node-cluster:
	cd rsknode/terraform && terraform init
	cd rsknode/terraform && terraform apply

destroy-rsk-node-cluster:
	cd rsknode/terraform && terraform destroy
