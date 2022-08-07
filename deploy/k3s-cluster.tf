module "k3s-controllers" {
  // Module Settings
  source           = "./k3s-controller"
  count            = 1
  countIndex       = count.index
  guestTargetNode  = "pve1"
  guestStoragePool = "local-zfs"

  // Global Variables
  guestPubKeyFile = var.guest_pubKeyFile
  netDnsHosts     = var.net_dnsServers
  netDomain       = var.net_domain
}

module "k3s-workers" {
  // Module Settings
  source           = "./k3s-worker"
  count            = 2
  countIndex       = count.index
  guestTargetNode  = "pve1"
  guestStoragePool = "local-zfs"

  // Global Variables
  guestPubKeyFile = var.guest_pubKeyFile
  netDnsHosts     = var.net_dnsServers
  netDomain       = var.net_domain
}

resource "time_sleep" "wait_for_controlplane" {
  create_duration = "60s"
  depends_on      = [ module.k3s-controllers ]
}

resource "helm_release" "argo-cd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "4.9.10"
  namespace        = "argocd"
  create_namespace = true
  wait             = true
  values           = [ "${file("../cluster/bootstrap/argocd/values.yaml")}" ]

  depends_on       = [ time_sleep.wait_for_controlplane ]
}

resource "helm_release" "gitops-config" {
  name       = "gitops-config"
  chart      = "../cluster/bootstrap/gitops-config"
  namespace  = "argocd"
  values     = [ "${file("../cluster/bootstrap/gitops-config/values.yaml")}" ]

  depends_on = [ helm_release.argo-cd ]
}
