#!/bin/bash
cat << EOF > /etc/default/log_monitor
LOGFILE=/var/log/messages
KEYWORD=info
EOF
