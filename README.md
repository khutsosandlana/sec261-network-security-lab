# Network Security & Detection Engineering Lab (SEC261)

A hands-on network security architecture, perimeter defense, and intrusion detection laboratory. This repository contains technical configurations, custom Suricata detection rules, Python telemetry parsing scripts, and security assessments covering core SOC and Security Engineering domains.

---

## Architecture Topology

```text
               [ External WAN / Attacker ]
                            │
                            ▼
               [ Stateful Firewall (iptables) ]
                ├── Allow: TCP/22 (SSH), TCP/80 (HTTP)
                └── Drop/Log: Unauthorized Traffic
                            │
                            ▼
               [ OpenVPN Site-to-Site Tunnel ]
                └── AES-256 Encrypted Subnet (10.8.0.0/24)
                            │
                            ▼
               [ Suricata IDS Telemetry Engine ]
                ├── Interface: Dynamic (wlp1s0 / eth0)
                └── Log Engine: eve.json & fast.log
                            │
                            ▼
               [ WPA3/AES Wireless Network Audit ]
```

---

## Module Breakdown

### **01. Perimeter Security & Stateful Firewall (`01-firewall/`)**
* Configured stateful filtering rules via `iptables` to strictly control ingress/egress boundaries.
* Whitelisted operational ports (SSH TCP/22, HTTP TCP/80) while enforcing dropping policies and logging rejected packets.
* Analyzed kernel dropped-packet logs to identify unauthorized external scanning activity.

### **02. Secure Transport & Site-to-Site VPN (`02-vpn/`)**
* Implemented an OpenVPN site-to-site encrypted tunnel between isolated virtual network segments (Site A: `192.168.1.0/24`, Site B: `192.168.2.0/24`).
* Configured tun interfaces (`10.8.0.0/24`) and verified route tables for secure inter-network traffic routing.
* Captured and analyzed traffic in Wireshark to confirm packet payload confidentiality across the tunnel.

### **03. Intrusion Detection & Telemetry Processing (`03-ids-suricata/`)**
* Deployed Suricata 7.0 IDS in system daemon mode to passively monitor real-time network interface traffic.
* Maintained rulesets via `suricata-update` using Emerging Threats (ET) Open feeds alongside custom local signatures.
* Authored custom Suricata rules to detect Nmap SYN scans (`T1595.002`) and port probes, validating alerts against live scan execution.
* Developed a Python script (`eve_parser.py`) to parse JSON events from `eve.json` into defanged threat alerts for CTI reporting.

### **04. Wireless Infrastructure Assessment (`04-wireless-audit/`)**
* Conducted a wireless audit based on NIST SP 800-153 guidelines evaluating WPA3-Personal authentication, AES encryption, and signal parameters.
* Documented router hardening recommendations including WPS disabling, default credential replacement, and guest network segmentation.

---

## Quickstart & Reproduction

### Prerequisites
* Linux Mint / Ubuntu / Debian
* Suricata 7.0+
* OpenVPN
* Python 3.10+

### 1. Apply Firewall Baseline Rules
```bash
sudo chmod +x 01-firewall/setup_firewall.sh
sudo ./01-firewall/setup_firewall.sh
```

### 2. Run Suricata with Custom Signatures
```bash
sudo suricata -c /etc/suricata/suricata.yaml -s 03-ids-suricata/rules/custom_detection.rules -i wlp1s0
```

### 3. Parse JSON Threat Alerts
```bash
python3 03-ids-suricata/scripts/eve_parser.py 03-ids-suricata/logs/eve.json
```

---

## MITRE ATT&CK Mapping

| Technique ID | Technique Name | Detection Location |
| :--- | :--- | :--- |
| **T1595.002** | Active Scanning: Vulnerability Scanning | Suricata Custom Rule (`sid:1000001`) |
| **T1046** | Network Service Discovery | Firewall Drop Logs & IDS Alerting |
| **T1048** | Exfiltration Over Alternative Protocol | OpenVPN Encrypted Tunneling |
