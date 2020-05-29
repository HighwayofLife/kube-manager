# kubectl
Kubectl Access to Kubernetes clusters. Generates a kube config from a manifest file.

Todo
----
- [ ] Use GoLang instead of Python for the kubeconfig generation
- [ ] Support editing the kube config within the `KUBECONFIG` environment var
- [ ] Expand usage manifest examples
- [ ] Create k9s base config? -- or persist across containers/sessions
- [ ] Persist container command history across containers/sessions

Installation
------------

1. Clone this repo.
2. Run `make`
    - This will build the container
    - Runs the python script inside the container that takes values from `cluster_manifest.yaml` and creates a `kube_config.yaml` in the repo.
    - Starts a container run session with the loaded `KUBECONFIG` env variable or otherwise the generated `kube_config.yaml`
3 run `export KUBECONFIG=$PWD:kube_config.yaml:$HOME/.kube/config`
    - Or some variation of this depending on your needs.

Usage
-----

* Run `make build` to rebuild the container and regenerate the `kube_config.yaml` from the `cluster_manifest.yaml` at any time.
* Run `make` or `make run` to run the container.

The container will load in the kube config from the value of the `KUBECONFIG` environment variable if it exists. If not, it will load the generated `kube_config.yaml`. Therefore, you can use any kube config within the kubectl container to manage that cluster.

### Project Manifest (local)
* `cluster_manifest.yaml`


#### manifest spec
This example shows with using with an Azure OIDC provider

```yaml
clusters:
  - cluster:
      certificate-authority: ./certs/<cluster-1-cert-ca.cert>
      server: https://<cluster-1-ip-or-hostname>
    name: cluster-1
  - cluster:
      certificate-authority: ./certs/<cluster-2-cert-ca.cert>
      server: https://<cluster-2-ip-or-hostname>
    name: cluster-2
  - cluster:
      certificate-authority: ./certs/<cluster-3-cert-ca.cert>
      server: https://<cluster-3-ip-or-hostname>
    name: cluster-3
auth-provider:
  config:
    apiserver-id: <api-server-app-id>
    client-id: <client-id>
    environment: AzurePublicCloud
    tenant-id: <tenant-id>
  name: azure
```

Components
----------
3 Scenarios.
Problem Statements - what are we trying to solve with this container?

1. I have a fully configured environment, but need cluster access
    - I need cluster access
    - I have my own kubectl/k9s
    - I care about Tooling component, and project manifest
    - Maybe I want the kube config to be optionally stored in ~/.kube/config
2. I don't want a fully configured environment to manage my clusters
    - I need cluster access
    - I don't have my own kubectl/k9s
    - I care about Upstream (Docker), Tooling, and Project
3. I have a kube-config, but just want k8s tooling.
    - I don't need cluster access created for me
    - I have my own kube config
    - I don't have my own kubectl/k9s
    - I care about: Upstream tools (Docker)

