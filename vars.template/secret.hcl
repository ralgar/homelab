//////////////////////////////////
///   Proxmox Authentication   ///
//////////////////////////////////

// IP address or FQDN of a Proxmox node in your cluster
pve_host             = "pve1.homelab.internal"

// Proxmox API credentials
pve_api_token_id     = "automation@pve!default"
pve_api_token_secret = "00000000-0000-0000-0000-000000000000"

// Uncomment to disable SSL/TLS verification for the Proxmox node
// pve_tlsInsecure      = true


/////////////////////////////////////////////
///   Global Guest Settings (CloudInit)   ///
/////////////////////////////////////////////

// Path to the SSH public key file to be installed on the guests
guest_pubKeyFile  = "~/.ssh/id_ed25519.pub"

// Uncomment to set custom DNS servers for the guests
// Default: Uses the Proxmox host's settings
// net_dnsServers    = [ "1.1.1.1", "1.0.0.1" ]

// Uncomment to set a custom root domain for the guests
// Default: Uses the Proxmox host's settings
// net_domain        = "homelab.internal"
