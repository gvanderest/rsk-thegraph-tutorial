include .env
NOW=`date +v%Y%m%d%H%M%S`

create-rsk-node-cluster:
	cd rsknode/terraform && terraform init
	cd rsknode/terraform && terraform apply

docker-login:
	aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com

build-rsk-node: docker-login
	cd rsknode/image && docker buildx build --platform linux/arm64,linux/amd64 -t ${ECR_HOST}/tutorial-rsk-node:latest --push .

destroy-rsk-node-cluster:
	cd rsknode/terraform && terraform destroy
