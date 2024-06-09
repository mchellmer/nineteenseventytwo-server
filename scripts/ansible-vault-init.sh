#!/bin/bash

# Create a new Ansible Vault file
ansible-vault create ../vault.yml

# Prompt for a password to encrypt the vault file
read -s -p "Enter a password for the vault: " vault_password
echo

# Encrypt the vault file with the provided password
ansible-vault encrypt ../vault.yml --vault-password-file <(echo "$vault_password")

# Display a success message
echo "Ansible Vault setup complete!"