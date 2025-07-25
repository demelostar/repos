#!/bin/bash

while true; do
    # Récupérer le processus curl suspect
    process=$(ps aux | grep -i "Admin_API" | grep -v "grep")

    if [[ ! -z "$process" ]]; then
        echo "[ALERT] Processus détecté : $process" >> logs.txt
    fi
    sleep 0.2  # Vérifier toutes les secondes
done

