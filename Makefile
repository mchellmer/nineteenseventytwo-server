.PHONY: deploy-kubernetes deploy-cni console-init ansible-vault-init

ansible-vault-init: scripts/ansible-vault-init.sh
	bash scripts/ansible-vault-init.sh

ansible-console-init:
	make ansible-vault-init

ansible-console-config:
	ansible-playbook k8s-console.yaml

ansible-docker:
	ansible-playbook k8s-docker.yaml

ansible-kubernetes:
	ansible-playbook k8s-kubernetes.yaml -vv

ansible-kubernetes-join:
	ansible-playbook k8s-kubernetes.yaml -vv --skip-tags "install_kubernetes,reset_kubeadm,init_kubeadm"

ansible-netplan:
	ansible-playbook k8s-netplan.yaml

console-init: scripts/init.sh
	bash scripts/init.sh

deploy-kubernetes:
	make ansible-docker
	make ansible-kubernetes

deploy-cni:
	ansible-playbook k8s-flannel.yaml

deploy-ingress:
	ansible-playbook k8s-ingress-nginx.yaml

deploy-loadbalancer:
	ansible-playbook k8s-metallb.yaml

deploy-monitoring:
	if ! grep -q "grafana_password" $HOME/1972-Server/group_vars/all/vault.yml; then \
		read -p "Enter the grafana token: " grafana_password; \
		echo; \
		ansible-vault encrypt_string \
		--vault-password-file=$HOME/vault_password.txt \
		--encrypt-vault-id default \
		"$$grafana_password" \
		--name "grafana_password" \
		--output temp_vault.yml; \
		echo >> $HOME/1972-Server/group_vars/all/vault.yml; \
		cat temp_vault.yml >> $HOME/1972-Server/group_vars/all/vault.yml; \
		rm temp_vault.yml; \
	fi;
	ansible-playbook k8s-monitoring.yaml

nodes-init:
	export ANSIBLE_HOST_KEY_CHECKING=False && ansible-playbook k8s-nodes.yaml --ask-pass

scripts/ansible-vault-init.sh:
	chmod +x scripts/ansible-vault-init.sh

scripts/init.sh:
	chmod +x scripts/init.sh