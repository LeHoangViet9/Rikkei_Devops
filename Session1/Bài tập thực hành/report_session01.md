sudo groupadd quickbite-apps
sudo useradd -M -s /usr/sbin/nologin -g quickbite-apps user-svc
sudo mkdir -p /opt/quickbite/dev/user-service
sudo chown user-svc:quickbite-apps /opt/quickbite/dev/user-service
sudo chmod 750 /opt/quickbite/dev/user-service

