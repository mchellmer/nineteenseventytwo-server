#!/bin/bash

# Set the path to the vault file in Ansible config
ansible_config_path="/c:/Users/mchel/repos/1972-Server/ansible.cfg"
vault_file_path="/c:/Users/mchel/repos/1972-Server/group_vars/all/vault.yml"
sed -i "s|^#vault_password_file =.*|vault_password_file = $vault_file_path|" "$ansible_config_path"

# Ask for a password to encrypt the vault file
read -s -p "Enter a password for the vault: " vault_password
echo
# Save the vault password to a file
echo "$vault_password" > ../vault_password.txt
# Ask for Wi-Fi password
read -s -p "Enter Wi-Fi password: " wifi_password
echo

# Set Wi-Fi password as environment variable
export ENV_WIFI_PASSWORD="$wifi_password"
# Update Ansible Vault file with Wi-Fi password
ansible-vault encrypt_string \
    --vault-password-file=../vault_password.txt \
    "$wifi_password" \
    --name "wifi_password" \
    >> ../group_vars/all/vault.yml

# Display a success message
echo "Wi-Fi password added to Ansible Vault!"