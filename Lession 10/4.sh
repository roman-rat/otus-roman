    #!/bin/bash
    cat << EOF > /etc/systemd/system/fcgiwrap.service
    [Unit]
    Description=Simple CGI Server for NGINX or Apache
    After=network.target

    [Service]
    ExecStart=/usr/sbin/fcgiwrap -s tcp:127.0.0.1:9000
    User=nginx
    Group=nginx
    Restart=on-failure
    PrivateTmp=true

    [Install]
    WantedBy=multi-user.target
EOF