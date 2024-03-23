# fluxcd-playground
this repo is intended to be used as a playground for trying out different aspects of the fluxcd project.  
follow [this link](https://fluxcd.io/)  for official fluxcd documentation

## setup infrastructure

### Kubectl

installation of local infra require kubectl. Your used version should not differ more than +-1 from the used cluster version. Please follow [this](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#install-kubectl-binary-with-curl-on-linux) installation guide.

### Kind

[Kind Quickstart](https://kind.sigs.k8s.io/docs/user/quick-start/).

If [go](https://go.dev/) is installed on your machine, `kind` can be easily installed as follows:

```bash
go install sigs.k8s.io/kind@v0.22.0
```

If this is not the case, simply download the [kind-v0.22.0](https://github.com/kubernetes-sigs/kind/releases/tag/v0.22.0) binary from the release page. (Other versions will probably work too. :cowboy_hat_face:)

## install the playground

```bash
make install-playground
```


### Cleanup
```bash
make clean
```
