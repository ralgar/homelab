PKR_DIR  := ./templates
PKR_VARS := ./vars/secret.hcl


# Build the entire system
all: template-rocky8-base template-k3s-cluster

# Intermediary targets
templates: template-k3s-cluster

# Build VM templates with Packer
template-rocky8-base: $(PKR_DIR)rocky8-base.pkr.hcl
	packer build -var-file $(PKR_VARS) -only proxmox-iso.rocky8-base $(PKR_DIR)
template-k3s-cluster: $(PKR_DIR)/rocky8-k3s.pkr.hcl
	packer build -var-file $(PKR_VARS) \
		-only proxmox-clone.k3s-master,proxmox-clone.k3s-worker $(PKR_DIR)
