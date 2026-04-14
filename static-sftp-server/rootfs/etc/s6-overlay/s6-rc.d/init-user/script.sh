#!/command/with-contenv bash

USER=${SFTP_USER:-sftpuser}
PASS=${SFTP_PASS:-password}

if ! id -u "$USER" >/dev/null 2>&1; then
    adduser -D -h /data "$USER"
fi
echo "$USER:$PASS" | chpasswd

mkdir -p /data/www /config
chown root:root /data
chmod 755 /data
chown "$USER":"$USER" /data/www

if [ ! -f /config/ssh_host_rsa_key ]; then
    ssh-keygen -A
    mv /etc/ssh/ssh_host_* /config/
fi

ln -sf /config/ssh_host_* /etc/ssh/

chmod 600 /config/ssh_host_*_key
chmod 644 /config/ssh_host_*_key.pub
chown root:root /config/ssh_host_*

exit 0