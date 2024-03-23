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
