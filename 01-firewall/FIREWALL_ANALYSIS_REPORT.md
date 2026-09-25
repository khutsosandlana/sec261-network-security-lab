# Module 01: Stateful Packet Filtering & Boundary Defense

## Executive Overview
This module details the implementation of a stateful firewall using `iptables` on Linux Mint. The configuration enforces a strict **Default Deny** ingress security posture while explicitly permitting controlled SSH (TCP/22), HTTP (TCP/80), and rate-limited ICMP ping traffic. All unauthorized connection attempts are logged to the Linux kernel syslog for security analysis.

---

## Security Policy Specification

| Traffic Direction | Protocol / Port | State | Action | Justification |
| :--- | :--- | :--- | :--- | :--- |
| **Ingress** | Loopback (`lo`) | Any | `ACCEPT` | Internal process communication |
| **Ingress** | Any | `ESTABLISHED, RELATED` | `ACCEPT` | Maintains active outbound response packets |
| **Ingress** | TCP / 22 | `NEW` | `ACCEPT` | Remote administration access |
| **Ingress** | TCP / 80 | `NEW` | `ACCEPT` | Public web service accessibility |
| **Ingress** | ICMP Echo Request | `NEW` | `ACCEPT (Rate-Limited)` | Diagnostics while mitigating ICMP flood DoS |
| **Ingress** | Any | Any | `LOG_AND_DROP` | Blocks unauthorized port scans and probing |
| **Egress** | Any | Any | `ACCEPT` | Unrestricted outbound network access |

---

## Verification & Log Analysis

### 1. Applying Configuration
Execute the bash automation script with administrative privileges:

```bash
sudo ./01-firewall/setup_firewall.sh
```

### 2. Testing Filtering Behavior
From a secondary network endpoint or testing shell, run diagnostic connection probes:

* **Permitted Service Test (Port 80):**
  ```bash
  nc -zv <TARGET_IP> 80
  # Result: Connection succeeded!
  ```
* **Blocked Service Test (Port 445 / SMB):**
  ```bash
  nc -zv -w 2 <TARGET_IP> 445
  # Result: Connection timed out / dropped
  ```

### 3. Inspecting Syslog Blocked Traffic Artifacts
Kernel logs recorded dropped packet alerts under `/var/log/syslog` or `dmesg`:

```bash
sudo journalctl -k | grep "IPTables-Dropped:"
```

**Log Sample Output:**
```text
IPTables-Dropped: IN=wlp1s0 OUT= MAC=00:11:22:33:44:55 SRC=192.168.0.134 DST=192.168.0.59 PROTO=TCP SPT=49152 DPT=445 FLAGS=SYN
```

* **Analysis:** The log entry confirms an unauthorized host (`192.168.0.134`) attempted a TCP SYN probe against port 445 (SMB), which was intercepted, logged, and dropped by the `LOG_AND_DROP` chain rule.
