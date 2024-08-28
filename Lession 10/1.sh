    #!/bin/bash
    cat << 'EOF' > /usr/local/bin/log_monitor.sh
    #!/bin/bash
    source /etc/default/log_monitor
    while true; do
      if grep -q "$KEYWORD" "$LOGFILE"; then
        echo "Keyword '$KEYWORD' found in $LOGFILE"
      fi
      sleep 30
    done
EOF