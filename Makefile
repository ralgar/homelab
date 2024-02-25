TF_DEV  := ./infra/envs/dev
TF_PROD := ./infra/envs/prod

CURRENT_REF := $(shell git symbolic-ref --short HEAD)

prod:
	cd $(TF_PROD) && terraform init -upgrade
	cd $(TF_PROD) && terraform apply

.PHONY: plan-dev
plan-dev:
	cd $(TF_DEV) && terraform plan \
		-var="gitops_ref_name=refs/heads/$(CURRENT_REF)"

.PHONY: cluster
cluster:
	cd $(TF_DEV) && terraform apply -auto-approve \
		-var="gitops_ref_name=refs/heads/$(CURRENT_REF)"

.PHONY: taint-gitops
gitops-redeploy:
	cd $(TF_DEV) && terraform destroy -auto-approve \
		-target "module.k8s_cluster.module.flux[0].helm_release.flux_sync" \
		-var="gitops_ref_name=refs/heads/$(CURRENT_REF)"
	sleep 60
	cd $(TF_DEV) && terraform apply -auto-approve \
		-target "module.k8s_cluster.module.flux[0].helm_release.flux_sync" \
		-var="gitops_ref_name=refs/heads/$(CURRENT_REF)"

destroy-cluster:
	cd $(TF_DEV) && terraform state rm 'module.k8s_cluster.module.flux[0]'
	cd $(TF_DEV) && terraform destroy -auto-approve \
		-target module.gcp_bucket \
		-target module.k8s_cluster \
		-target module.k8s_network

.PHONY: docs
docs: venv
	source venv/bin/activate && mkdocs serve --config-file .mkdocs.yml

venv:
	python -m venv venv
	source venv/bin/activate && pip install mkdocs mkdocs-material
