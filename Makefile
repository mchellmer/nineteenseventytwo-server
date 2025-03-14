.PHONY: deploy-kubernetes deploy-cni

deploy-kubernetes:
	ansible-playbook k8s-kubernetes.yaml

deploy-cni:
	ansible-playbook k8s-flannel.yaml --extra-vars "kubectl_args=--validate=false"