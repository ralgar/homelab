variable "agent_name" {
  description = "A name to identify the agent with (eg. 'cluster-1')."
  type        = string
}

variable "project_path" {
  description = "GitLab Project path with namespace (eg. 'myuser/mycloudlab')."
  type        = string
}

variable "agent_version" {
  description = "The GitLab agent version to install (matches the Helm Chart AppVersion)."
  type        = string
  default     = "2.6.1"
}

variable "replicas" {
  description = "Number of agentk replicas to deploy."
  type        = number
  default     = 2
}
