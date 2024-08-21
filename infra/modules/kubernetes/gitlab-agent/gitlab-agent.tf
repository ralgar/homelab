data "gitlab_project" "this" {
  path_with_namespace = var.project_path
}

resource "gitlab_cluster_agent" "this" {
  project = data.gitlab_project.this.id
  name    = var.agent_name
}

resource "gitlab_cluster_agent_token" "this" {
  project  = data.gitlab_project.this.id
  agent_id = gitlab_cluster_agent.this.agent_id
  name     = var.agent_name
}

resource "helm_release" "gitlab_agent" {
  name             = "gitlab-agent"
  namespace        = "gitlab-agent"
  create_namespace = true
  repository       = "https://charts.gitlab.io"
  chart            = "gitlab-agent"
  version          = var.agent_version

  set {
    name  = "config.token"
    value = gitlab_cluster_agent_token.this.token
  }
}
