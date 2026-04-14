#!/command/with-contenv bash

USER=${SFTP_USER:-sftpuser}
PASS=${SFTP_PASS:-password}

# Gestione Utente
if ! id -u "$USER" >/dev/null 2>&1; then
    adduser -D -h /data "$USER"
fi
echo "$USER:$PASS" | chpasswd

# Gestione Cartelle e Permessi
mkdir -p /data/www /config
chown root:root /data
chmod 755 /data
chown "$USER":"$USER" /data/www

# Gestione Chiavi SSH Persistenti
if [ ! -f /config/ssh_host_rsa_key ]; then
    ssh-keygen -A
    mv /etc/ssh/ssh_host_* /config/
fi

# Link simbolici per far trovare le chiavi a sshd nel percorso standard
ln -sf /config/ssh_host_* /etc/ssh/

exit 0