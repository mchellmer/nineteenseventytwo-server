#!/bin/bash

vault_pass_file_path="$HOME/vault_password.txt"
vault_file_path="$HOME/1972-server/group_vars/all/vault.yml"
ansible_config_path="$HOME/ansible.cfg"
ansible_log_path="$HOME/ansible.log"

# Create ansible cfg and set vault password file as well as cfg file path
touch $vault_pass_file_path
touch $ansible_config_path
sed -i "s|;vault_password_file =.*|vault_password_file = $vault_pass_file_path|" "$ansible_config_path"
sed -i "s|;log_path =.*|log_path = $ansible_log_path|" "$ansible_config_path"
sed -i "s|;stdout_callback =.*|stdout_callback = yaml|" "$ansible_config_path"
sudo cp $ansible_config_path /etc/ansible/ansible.cfg

# Ask for a password to encrypt the vault file
read -s -p "Enter a password for the vault: " vault_password
echo
# Save the vault password to a file
echo "$vault_password" > $vault_pass_file_path
# Ask for Wi-Fi password
read -s -p "Enter Wi-Fi password: " wifi_password
echo

# Update Ansible Vault file with Wi-Fi password
ansible-vault encrypt_string \
    --vault-password-file=$vault_pass_file_path \
    "$wifi_password" \
    --name "bearden_wifi_pass" \
    >> $vault_file_path

# Display a success message
echo "Wi-Fi password added to Ansible Vault!"

# Ask for Wi-Fi password
read -s -p "Enter become pass: " become_pass
echo

# Update Ansible Vault file with Wi-Fi password
ansible-vault encrypt_string \
    --vault-password-file=$vault_pass_file_path \
    "$become_pass" \
    --name "ansible_become_password" \
    >> $vault_file_path

# Display a success message
echo "Ansible become pass added to Ansible Vault!"