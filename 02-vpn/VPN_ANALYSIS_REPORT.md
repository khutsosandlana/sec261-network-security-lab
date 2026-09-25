# Module 02: Secure Transport & Site-to-Site VPN

## Executive Overview
This module demonstrates the deployment of an OpenVPN site-to-site encrypted tunnel bridging two distinct network segments. Using AES-256-GCM encryption and SHA256 data authentication, the tunnel ensures payload confidentiality and integrity over untrusted transit networks.

---

## Network Topology & Subnet Mapping

| Parameter | Network Value | Description |
| :--- | :--- | :--- |
| **Tunnel Network** | `10.8.0.0/24` | Virtual point-to-point addressing |
| **Site A (Server)** | `192.168.1.0/24` | Primary internal network segment |
| **Site B (Client)** | `192.168.2.0/24` | Remote site network segment |
| **Cipher Suite** | `AES-256-GCM` | Authenticated symmetric encryption |
| **Authentication** | `SHA-256` | TLS certificate/key verification |

---

## Technical Verification & PCAP Analysis

### 1. Route Table Verification
When the tunnel is established, static routes are injected into the kernel routing table:

```bash
ip route show
# Output: 10.8.0.0/24 dev tun0 proto kernel scope link src 10.8.0.1
```

### 2. Wireshark Encrypted Traffic Verification
Traffic captured on the physical interface during active communication through the VPN revealed only UDP packet payloads encapsulated on port 1194. No plaintext protocol headers were observable, validating data confidentiality.
