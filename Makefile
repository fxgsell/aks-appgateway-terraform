DOMAIN:=www.testsazu.re
SECRET:=my-secret

all: apply

config:
	echo "`terraform output kube_config`" > ~/.kube/azurek8s

apply: 
	unset KUBECONFIG; terraform apply -auto-approve

destroy: config
	terraform destroy

install:
	terraform init -upgrade=true

deploy_app:
	kubectl apply -f demo_app/guestbook-all-in-one.yaml

deploy_ingress: 
	kubectl apply -f demo_app/ing-guestbook.yaml

deploy_cert:
	kubectl create secret tls $(SECRET) --key ssl/private.key --cert ssl/certificate.crt

deploy_ssl_ingress: 
	sed 's/__DOMAIN__/$(DOMAIN)/g; s/__SECRET__/$(SECRET)/g' demo_app/ssl-ing-guestbook.yaml | kubectl apply -f -

clean:
	rm -rf .terraform/ *.tfstate *.tfstate.backup
