#!/usr/bin/env sh 

sudo tee /etc/systemd/system/battery-charge-threshold.service >/dev/null <<'EOF'
[Unit]
Description=Set battery charge stop threshold
After=local-fs.target

[Service]
Type=oneshot
ExecStart=/bin/sh -c 'echo 85 > /sys/class/power_supply/BAT0/charge_stop_threshold'
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now battery-charge-threshold.service
