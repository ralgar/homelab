apiVersion: v1
kind: Config
preferences: {}
current-context: homelab
contexts:
  - name: homelab
    context:
      cluster: homelab
      user: admin
clusters:
  - name: homelab
    cluster:
      certificate-authority-data: ${cluster_ca_certificate}
      server: "https://${cluster_ipv4_address}:6443"
users:
  - name: admin
    user:
      client-certificate-data: ${client_certificate}
      client-key-data: ${client_key}
