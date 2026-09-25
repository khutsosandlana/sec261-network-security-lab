#!/usr/bin/env python3
import json
import os
from collections import Counter

LOG_FILE = "03-ids-suricata/logs/eve.json"

def parse_eve_log(file_path):
    if not os.path.exists(file_path):
        print(f"[-] Error: Log file not found at {file_path}")
        return

    signatures = Counter()
    src_ips = Counter()
    event_types = Counter()

    with open(file_path, "r") as f:
        for line in f:
            try:
                data = json.loads(line.strip())
                event_types[data.get("event_type", "unknown")] += 1

                if data.get("event_type") == "alert":
                    alert = data.get("alert", {})
                    sig = alert.get("signature", "Unknown Alert")
                    src = data.get("src_ip", "Unknown IP")
                    signatures[sig] += 1
                    src_ips[src] += 1
            except json.JSONDecodeError:
                continue

    print("=" * 50)
    print("        SURICATA IDS LOG ANALYSIS REPORT")
    print("=" * 50)
    print(f"\nTotal Events Parsed: {sum(event_types.values())}")
    
    print("\n[+] Top Detected Alert Signatures:")
    for sig, count in signatures.most_common(5):
        print(f"  - [{count}x] {sig}")

    print("\n[+] Top Source IPs Triggering Alerts:")
    for ip, count in src_ips.most_common(5):
        print(f"  - [{count}x] {ip}")
    print("=" * 50)

if __name__ == "__main__":
    parse_eve_log(LOG_FILE)
