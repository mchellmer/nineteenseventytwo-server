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
	read -p "Enter the grafana token: " grafana_password
	echo
	ansible-vault encrypt_string \
		--vault-password-file=$vault_pass_file_path \
		--encrypt-vault-id default \
		"$grafana_password" \
		--name "grafana_password" \
		--output temp_vault.yml
	ansible-playbook k8s-monitoring.yaml

nodes-init:
	export ANSIBLE_HOST_KEY_CHECKING=False && ansible-playbook k8s-nodes.yaml --ask-pass

scripts/ansible-vault-init.sh:
	chmod +x scripts/ansible-vault-init.sh

scripts/init.sh:
	chmod +x scripts/init.sh