module "k3s-master" {
  // Module Settings
  source           = "./k3s-master"
  guestTargetNode  = "pve1"
  guestStoragePool = "local-zfs"

  // Global Variables
  guestPubKeyFile = local.guest_pubKeyFile
  netDnsHosts     = local.net_dnsServers
  netDomain       = local.net_domain
}

module "k3s-controllers" {
  // Module Settings
  source           = "./k3s-controller"
  replicas         = 0
  guestTargetNode  = "pve1"
  guestStoragePool = "local-zfs"

  // Global Variables
  guestPubKeyFile = local.guest_pubKeyFile
  netDnsHosts     = local.net_dnsServers
  netDomain       = local.net_domain
}

module "k3s-workers" {
  // Module Settings
  source           = "./k3s-worker"
  replicas         = 2
  guestTargetNode  = "pve1"
  guestStoragePool = "local-zfs"

  // Global Variables
  guestPubKeyFile = local.guest_pubKeyFile
  netDnsHosts     = local.net_dnsServers
  netDomain       = local.net_domain

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

  depends_on       = [ module.k3s-workers ]
}

resource "helm_release" "gitops-config" {
  name       = "gitops-config"
  chart      = "../cluster/bootstrap/gitops-config"
  namespace  = "argocd"
  values     = [ "${file("../cluster/bootstrap/gitops-config/values.yaml")}" ]

  depends_on = [ helm_release.argo-cd ]
}
