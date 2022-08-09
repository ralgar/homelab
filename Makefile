PKR_DIR  := ./templates
PKR_VARS := ./vars/secret.hcl


# Build the entire system
all: template-rocky8 template-k3s-cluster

# Intermediary targets
templates: template-k3s-cluster

# Build VM templates with Packer
template-rocky8: $(PKR_DIR)/rocky8.pkr.hcl
	packer build -var-file $(PKR_VARS) -only proxmox-iso.rocky8 $(PKR_DIR)
	sleep 5
template-k3s-cluster: $(PKR_DIR)/k3s-cluster.pkr.hcl
	packer build -var-file $(PKR_VARS) \
		-only proxmox-clone.k3s-controller,proxmox-clone.k3s-worker $(PKR_DIR)
