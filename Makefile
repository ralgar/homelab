TF_DEV  := ./infra/envs/dev
TF_PROD := ./infra/envs/prod

prod:
	cd $(TF_PROD) && terraform init -upgrade
	cd $(TF_PROD) && terraform apply

.PHONY: cluster
cluster:
	cd $(TF_DEV) && terraform apply -auto-approve \
		-target module.k8s_cluster \
		-target module.k8s_network

destroy-cluster:
	cd $(TF_DEV) && terraform destroy -auto-approve \
		-target module.k8s_cluster \
		-target module.k8s_network
