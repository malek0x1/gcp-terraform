
[Unit]
Description=Google Cloud Compute Engine SQL Proxy
After=network.target

[Service]
Type=simple
WorkingDirectory=/usr/local/bin
ExecStart=/usr/local/bin/cloud-sql-proxy  ${cloud_sql_connection_name} --address=0.0.0.0  --private-ip --port=5431
Restart=always
StandardOutput=journal
User=root

[Install]
WantedBy=multi-user.target