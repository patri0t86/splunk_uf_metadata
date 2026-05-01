# uf_syslog_metadata

A Splunk Universal Forwarder app that dynamically tags syslog data with the receiving host's hostname via the `_meta` field.

## What it does

When a syslog aggregator receives logs from remote hosts and writes them to a local directory, Splunk has no built-in way to know which machine is forwarding that data. This app stamps every event from the monitored path with `syslog_receiver::<hostname>`, making the receiving forwarder identifiable at search time.

## How it works

`bin/metadata.sh` is run once at Splunk startup (`interval = -1`). It:

1. Resolves the hostname of the local machine.
2. Writes a `local/inputs.conf` that applies `_meta = syslog_receiver::<hostname>` to all events under the monitored path (`/var/log` by default).
3. Restarts the Splunk Forwarder service only if the config changed, preventing a restart loop.

## Configuration

Edit `bin/metadata.sh` to change the monitored path:

```bash
MONITOR_PATH="/var/log"
```

## Requirements

- Splunk Universal Forwarder
- Script must run as a user with permission to restart the `SplunkForwarder` service
- systemd or SysV init

## Installation

Deploy this app to `$SPLUNK_HOME/etc/apps/uf_syslog_metadata` and restart the forwarder. The script will self-configure on first startup.
