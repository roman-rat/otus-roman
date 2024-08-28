    #!/bin/bash
    cat << EOF > /etc/systemd/system/log_monitor.service
    [Unit]
    Description=Log Monitoring Service
    After=network.target

    [Service]
    ExecStart=/usr/local/bin/log_monitor.sh
    Restart=always

    [Install]
    WantedBy=multi-user.target
EOF