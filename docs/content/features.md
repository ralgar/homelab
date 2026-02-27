# Features

---

## Kubernetes Cluster

### System

- [x] Talos Linux — immutable, API-driven OS with automated etcd backups
- [x] GitOps-driven continuous deployment via Flux

### Networking

- [x] Cilium CNI with Envoy-powered Gateway API (HTTPRoute)
- [x] Automated TLS certificate management via cert-manager with Let's Encrypt

### Storage

- [x] Block, object, and shared filesystem storage powered by Rook Ceph
- [x] VolSync for automated, incremental volume backup and restore

### Security & Secrets

- [x] HashiCorp Vault for secrets management with automated generation
- [x] External Secrets Operator syncing from Vault and GitLab CI/CD Variables

### Databases

- [x] Crunchy Postgres Operator (PGO) for cloud-native PostgreSQL deployment
- [x] Reusable Postgres component with seamless, automatic backup and restore

### Observability

- [x] Prometheus metrics scraped from critical components
- [x] Grafana with dashboards for visualization of metrics
- [x] Loki for cluster-wide log aggregation
- [ ] Exportarr sidecars for rich *arr application metrics

### Applications

- [x] Complete media server platform with requests and automated acquisition
- [x] Home automation platform powered by MQTT protocol
