# Module 04: Wireless Infrastructure & Security Assessment

## Executive Overview
This wireless audit evaluates local Wi-Fi architecture against NIST SP 800-153 (Guidelines for Securing Wireless Local Area Networks) standards. The evaluation assesses WPA3-Personal authentication mechanisms, AES payload encryption, signal coverage, and administrative access controls.

---

## Wireless Configuration Baseline

* **SSID Security Protocol:** WPA3-Personal (SAE - Simultaneous Authentication of Equals)
* **Encryption Algorithm:** AES-CCMP / GCMP-256
* **Frequency Bands:** 2.4 GHz / 5 GHz dual-band operational mode
* **Management Frame Protection (PMF):** Required (802.11w)

---

## NIST SP 800-153 Compliance Matrix

| Audit Check | Status | Risk Level | Findings & Remediation |
| :--- | :--- | :--- | :--- |
| **Legacy WEP/WPA Deprecation** | PASS | LOW | Network strictly enforces WPA3/WPA2-Enterprise fallback. |
| **Default Credential Usage** | PASS | LOW | Administrative portal credentials updated from factory defaults. |
| **WPS (Wi-Fi Protected Setup)** | PASS | LOW | WPS disabled to eliminate brute-force vulnerabilities. |
| **Guest Network Isolation** | WARN | MEDIUM | Recommended enabling client isolation on the guest VLAN. |

---

## Diagnostic Commands Executed (Linux Mint)

Inspect active wireless network configuration via terminal:

```bash
# Check active link status and encryption details
nmcli dev wifi show

# Inspect interface capabilities
iw list | grep -E "WPA3|SAE"
```
