CURRENT_REF := $(shell git symbolic-ref HEAD)

.PHONY: diff
diff:
	flux diff kustomization flux-system \
		--recursive \
		--path ./kubernetes/clusters/metal \
		--local-sources GitRepository/flux-system/flux-system=./

.PHONY: switch-branch
switch-branch:
	kubectl patch gitrepository flux-system -n flux-system --type=merge -p '{"spec":{"ref":{"name":"$(CURRENT_REF)"}}}'

.PHONY: docs
docs: venv
	source venv/bin/activate && mkdocs serve --config-file docs/mkdocs.yml

venv:
	python -m venv venv
	source venv/bin/activate && pip install mkdocs mkdocs-material
