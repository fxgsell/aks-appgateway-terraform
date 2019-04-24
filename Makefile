all: apply

config:
	echo "`terraform output kube_config`" > ~/.kube/azurek8s

apply:
	terraform apply -auto-approve

install:
	terraform init