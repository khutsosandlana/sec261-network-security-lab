# Module 03: Intrusion Detection & Telemetry Processing

## Executive Overview
This module demonstrates the deployment, configuration, rule engineering, and log parsing for Suricata 7.0 IDS running natively on Linux Mint. The setup monitors network interfaces for active reconnaissance (Nmap SYN scans) and port probing, generating structured JSON event telemetry mapped to MITRE ATT&CK techniques.

---

## Environment Configuration
* **Host Operating System:** Linux Mint (64-bit)
* **Monitored Interface:** Dynamic (Auto-detected)
* **IDS Version:** Suricata 7.0.3 RELEASE
* **Service Status:** Active (`systemctl status suricata`)

---

## Step-by-Step Implementation

### 1. Installation & Ruleset Management
Suricata was installed via APT package management. Community rules were updated using `suricata-update`, pulling latest Emerging Threats (ET) Open rulesets alongside local custom signatures:

```bash
sudo apt update && sudo apt install suricata -y
sudo suricata-update
```

### 2. Live Scan Execution & Testing
Reconnaissance was simulated from an external host targeting the monitored interface:

* **Port Connection Test:**
  ```bash
  nc -zv <TARGET_IP> 80
  ```
* **Nmap Stealth SYN Scan:**
  ```bash
  sudo nmap -sS -p 1-1000 <TARGET_IP>
  ```

---

## Telemetry Output & Incident Analysis

### Log Artifacts Inspected (`/var/log/suricata/`)
* `fast.log`: Human-readable summary alerts.
* `eve.json`: Full Extensible Event Format JSON output containing flow data and signature metadata.

### Executing the Custom Python Parser
The Python CLI tool `eve_parser.py` was executed to extract, format, and defang indicator IPs from `eve.json`:

```bash
python3 scripts/eve_parser.py /var/log/suricata/eve.json
```

---

## MITRE ATT&CK Mapping & Mitigation

| MITRE Technique | Observables | Mitigation Recommendation |
| :--- | :--- | :--- |
| **T1595.002 (Active Scanning)** | TCP SYN packets exceeding threshold rates | Correlate IDS alerts with `iptables` drop rules. |
| **T1046 (Network Service Discovery)** | Connection probes across common ports | Enforce strict perimeter firewall drop rules. |
