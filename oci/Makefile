include ../Makefile

.PHONY: install-ns
install-ns:
	kubectl create namespace development
	kubectl create namespace production

.PHONY: push-latest-change-to-registry
push-latest-change-to-registry:	
	flux push artifact oci://localhost:5000/manifests/demo-config:$(shell git rev-parse --short HEAD) --path="./configs" --source="$(shell git config --get remote.origin.url)" --revision="$(shell git branch --show-current)/$(shell git rev-parse HEAD)"

.PHONY: tag-current-commit-SHA-as-latest
tag-current-commit-SHA-as-latest:
	flux tag artifact oci://localhost:5000/manifests/demo-config:$(shell git rev-parse --short HEAD) --tag latest

.PHONY: list-pushed-artifacts
list-pushed-artifacts:
	flux list artifacts oci://localhost:5000/manifests/demo-config

.PHONY: push-release-from-git-to-registry
push-release-from-git-to-registry:
	flux push artifact oci://localhost:5000/manifests/demo-config:$(shell git tag --points-at HEAD) --path="./configs" --source="$(shell git config --get remote.origin.url)" --revision="$(shell git tag --points-at HEAD)/$(shell git rev-parse HEAD)"

.PHONY: tag-release-as-stable
tag-release-as-stable:
	flux tag artifact oci://localhost:5000/manifests/demo-config:$(shell git tag --points-at HEAD) --tag stable
