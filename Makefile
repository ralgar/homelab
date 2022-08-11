PKR_DIR  := ./templates
TF_DIR   := ./infra
HCL_VARS := ./vars/secret.hcl


# Build the entire system
all: template-rocky8 template-k3s-cluster apply-infrastructure

# Intermediary targets
templates: template-k3s-cluster

# Build VM templates with Packer
template-rocky8: $(PKR_DIR)/rocky8.pkr.hcl
	packer build -var-file $(HCL_VARS) -only proxmox-iso.rocky8 $(PKR_DIR)
	sleep 15
template-k3s-cluster: $(PKR_DIR)/k3s-cluster.pkr.hcl
	packer build -var-file $(HCL_VARS) \
		-only proxmox-clone.k3s-master,proxmox-clone.k3s-controller,proxmox-clone.k3s-worker \
		$(PKR_DIR)
	sleep 15

# Apply and destroy Terraform infrastructure
apply-infrastructure: $(TF_DIR)/main.tf
	cd $(TF_DIR) && terraform init -upgrade
	cd $(TF_DIR) && terraform apply -var-file ../$(HCL_VARS) -auto-approve
destroy-infrastructure: $(TF_DIR)/main.tf
	cd $(TF_DIR) && terraform init -upgrade
	cd $(TF_DIR) && terraform destroy -var-file ../$(HCL_VARS) -auto-approve
