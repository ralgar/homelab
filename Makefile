TF_ROOT  := ./infra/envs/dev

CURRENT_REF := $(shell git symbolic-ref HEAD)

.PHONY: plan
plan:
	cd $(TF_ROOT) && terraform plan -var="gitops_ref_name=$(CURRENT_REF)"

.PHONY: apply
apply:
	cd $(TF_ROOT) && terraform apply -auto-approve -var="gitops_ref_name=$(CURRENT_REF)"

.PHONY: destroy
destroy: gitops-destroy
	cd $(TF_ROOT) && terraform state rm 'module.k8s_cluster.module.flux[0]' || true
	cd $(TF_ROOT) && terraform destroy -auto-approve

.PHONY: gitops-redeploy
gitops-redeploy: gitops-destroy
	cd $(TF_ROOT) && terraform apply -auto-approve \
		-target "module.k8s_cluster.module.flux[0].helm_release.flux_sync" \
		-var="gitops_ref_name=$(CURRENT_REF)"

.PHONY: gitops-destroy
gitops-destroy:
	cd $(TF_ROOT) && terraform destroy -auto-approve \
		-target "module.k8s_cluster.module.flux[0].helm_release.flux_sync"
	sleep 60

.PHONY: docs
docs: venv
	source venv/bin/activate && mkdocs serve --config-file docs/mkdocs.yml

venv:
	python -m venv venv
	source venv/bin/activate && pip install mkdocs mkdocs-material
