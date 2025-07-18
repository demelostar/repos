#!/bin/bash

LOGFILE="/var/log/adminapi_watch.log"

echo "===== Démarrage de la surveillance Admin_API à $(date) =====" >> "$LOGFILE"

while true; do
    DATE=$(date "+%Y-%m-%d %H:%M:%S")
    # Cherche les processus contenant Admin_API
    MATCHES=$(ps aux | grep -i "Admin" | grep -v grep)

    if [[ ! -z "$MATCHES" ]]; then
        echo "[$DATE] Détection de processus Admin_API :" >> "$LOGFILE"
        echo "$MATCHES" >> "$LOGFILE"
        echo "------------------------------------------" >> "$LOGFILE"
    fi

    sleep 0.5
done
