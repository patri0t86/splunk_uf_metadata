#!/usr/bin/env bash
# Dynamically writes UF hostname into a monitor input's _meta field.
# Adjust MONITOR_PATH to match your rsyslog output file/dir.

set -e

MONITOR_PATH="/var/log"
TARGET_FILE="$(cd "$(dirname "$0")/.." && pwd)/local/inputs.conf"
METADATA_KEY="syslog_receiver"
METADATA_VALUE=$(hostname -s)

[ -d "$(dirname "${TARGET_FILE}")" ] || mkdir "$(dirname "${TARGET_FILE}")"

DESIRED=$(cat <<EOF
[monitor://${MONITOR_PATH}]
_meta = ${METADATA_KEY}::${METADATA_VALUE}
EOF
)

if [ "$(cat "${TARGET_FILE}" 2>/dev/null)" != "${DESIRED}" ]; then
    echo "${DESIRED}" > "${TARGET_FILE}"
    if command -v systemctl &>/dev/null; then
        systemctl restart SplunkForwarder
    else
        service SplunkForwarder restart
    fi
fi
