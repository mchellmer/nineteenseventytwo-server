.PHONY: deploy-kubernetes deploy-cni console-init ansible-vault-init

ansible-vault-init: scripts/ansible-vault-init.sh
	bash scripts/ansible-vault-init.sh

ansible-console-init:
	make ansible-vault-init
	make ansible-netplan

ansible-console-config:
	ansible-playbook k8s-console.yaml

ansible-docker:
	ansible-playbook k8s-docker.yaml

ansible-kubernetes:
	ansible-playbook k8s-kubernetes.yaml -vv

ansible-kubernetes-join:
	ansible-playbook k8s-kubernetes.yaml -vv --skip-tags "reset_kubeadm,init_kubeadm"

ansible-netplan:
	ansible-playbook k8s-netplan.yaml

console-init: scripts/init.sh
	bash scripts/init.sh

deploy-kubernetes:
	make ansible-docker
	make ansible-kubernetes

deploy-cni:
	ansible-playbook k8s-flannel.yaml --extra-vars "kubectl_args=--validate=false"

nodes-init:
	export ANSIBLE_HOST_KEY_CHECKING=False && ansible-playbook k8s-nodes.yaml --ask-pass

scripts/ansible-vault-init.sh:
	chmod +x scripts/ansible-vault-init.sh

scripts/init.sh:
	chmod +x scripts/init.sh