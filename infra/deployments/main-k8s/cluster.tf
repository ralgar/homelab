data "openstack_containerinfra_clustertemplate_v1" "default" {
  name = "Kubernetes v1.26-1"
}

resource "openstack_containerinfra_cluster_v1" "cluster1" {
  name                = "Cluster"
  cluster_template_id = data.openstack_containerinfra_clustertemplate_v1.default.id
  keypair             = data.openstack_compute_keypair_v2.admin.name

  master_count = 1
  node_count   = 1
  flavor       = "m1.xlarge"

  fixed_network       = module.k8s_network.network.id
  fixed_subnet        = module.k8s_network.default_subnet.id
  floating_ip_enabled = true

  // Optional: Override the default container volume size
  //docker_volume_size = 40

  labels = {
    // Node Options
    //etcd_volume_size = 10

    // Auto-scaling / Auto-healing Options
    //auto_healing_enabled = false
    //auto_scaling_enabled = false
    //min_node_count       = 1
    //max_node_count       = 3

    // API Server LB (if enabled in template)
    //master_lb_floating_ip_enabled = true
    //master_lb_allowed_cidrs       = "0.0.0.0/0"  // Comma delimited list
  }

  // Merge labels with the template to allow per-cluster customizations
  merge_labels = true
}

module "cluster1_agent" {
  source        = "../../modules/kubernetes/gitlab-agent"
  providers = {
    helm       = helm.cluster1
  }

  agent_name    = "cluster1"
  project_path  = var.gitlab_project
  agent_version = "2.6.1"
  replicas      = 1
}

module "cluster1_gitops" {
  source    = "../../modules/kubernetes/flux"
  providers = {
    helm       = helm.cluster1
    kubernetes = kubernetes.cluster1
  }

  repository = var.gitops_repo
  ref_name   = var.gitops_ref_name
  path       = "./clusters/envs/${var.environment}"

  configs = {
    DOMAIN            = trimsuffix(openstack_dns_zone_v2.environment.name, ".")
    MEDIA_VOLUME_ID   = openstack_blockstorage_volume_v3.media.id
    MEDIA_VOLUME_SIZE = "${openstack_blockstorage_volume_v3.media.size}Gi"
  }

  secrets = {
    GCP_BACKUP_PROJECT_ID   = module.gcp_bucket.project_id
    GCP_BACKUP_BUCKET_NAME  = module.gcp_bucket.name
    GCP_BACKUP_BUCKET_CREDS = module.gcp_bucket.service_account_key  # base64
    BACKUP_REPO_PASSWORD    = var.backup_repo_password
    DESIGNATE_AUTH_ID       = openstack_identity_application_credential_v3.designate.id
    DESIGNATE_AUTH_SECRET   = openstack_identity_application_credential_v3.designate.secret
  }
}
