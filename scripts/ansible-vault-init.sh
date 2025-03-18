#!/bin/bash

rm $HOME/vault_password.txt
rm $HOME/1972-Server/group_vars/all/vault.yml

vault_pass_file_path="$HOME/vault_password.txt"
vault_file_path="$HOME/1972-Server/group_vars/all/vault.yml"
ansible_config_path="$HOME/ansible.cfg"
ansible_log_path="$HOME/ansible.log"

# Create ansible cfg and set vault password file as well as cfg file path
touch $vault_pass_file_path
touch $ansible_config_path

# Generate ansible.cfg content
cat <<EOL > $ansible_config_path
[defaults]
vault_password_file = $vault_pass_file_path
log_path = $ansible_log_path
stdout_callback = yaml
EOL

sudo mkdir -p /etc/ansible
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
    --encrypt-vault-id default \
    "$wifi_password" \
    --name "bearden_wifi_pass" \
    --output temp_vault.yml

echo >> $vault_file_path
cat temp_vault.yml >> $vault_file_path
rm temp_vault.yml

# Display a success message
echo "Wi-Fi password added to Ansible Vault!"

# Ask for become password
read -s -p "Enter become pass: " become_pass
echo

# Update Ansible Vault file with become password
ansible-vault encrypt_string \
    --vault-password-file=$vault_pass_file_path \
    --encrypt-vault-id default \
    "$become_pass" \
    --name "ansible_become_password" \
    --output temp_vault.yml

echo >> $vault_file_path
cat temp_vault.yml >> $vault_file_path
rm temp_vault.yml

# Display a success message
echo "Ansible become pass added to Ansible Vault!"

# Ask for ansible_default_ipv4_address
read -p "Enter ansible_default_ipv4_address: " ansible_default_ipv4_address
echo

# Update Ansible Vault file with ansible_default_ipv4_address
ansible-vault encrypt_string \
    --vault-password-file=$vault_pass_file_path \
    --encrypt-vault-id default \
    "$ansible_default_ipv4_address" \
    --name "ansible_default_ipv4_address" \
    --output temp_vault.yml

echo >> $vault_file_path
cat temp_vault.yml >> $vault_file_path
rm temp_vault.yml

# Display a success message
echo "ansible_default_ipv4_address added to Ansible Vault!"