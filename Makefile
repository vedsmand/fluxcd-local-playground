.PHONY: install-playground
install-playground: install-kind install-fluxcd install-ns

.PHONY: install-kind
install-kind:
ifneq ($(shell kind get nodes), kind-control-plane)
	./bootstrap/kind-with-registry.sh
	kubectl wait --for=condition=Ready node/kind-control-plane
endif

.PHONY: install-fluxcd
install-fluxcd:
	kubectl apply -f https://github.com/fluxcd/flux2/releases/latest/download/install.yaml
	kubectl wait --for=condition=Ready pod -l app=helm-controller -n flux-system --timeout 3m
	kubectl wait --for=condition=Ready pod -l app=image-automation-controller -n flux-system --timeout 3m
	kubectl wait --for=condition=Ready pod -l app=image-reflector-controller -n flux-system --timeout 3m
	kubectl wait --for=condition=Ready pod -l app=kustomize-controller -n flux-system --timeout 3m
	kubectl wait --for=condition=Ready pod -l app=notification-controller -n flux-system --timeout 3m
	kubectl wait --for=condition=Ready pod -l app=source-controller -n flux-system --timeout 3m

.PHONY: install-ns
install-ns:
	kubectl create namespace development
	kubectl create namespace production

.PHONY: clean
clean:
	kind delete cluster
	docker rm kind-registry -f

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
