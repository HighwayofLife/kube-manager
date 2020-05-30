# Kube Manager
Access all of your Kubernetes Clusters with one container of all your favorite Kubernetes CLI tools. Negates the need to configure a workstation or environment to manage clusters. Ease onboarding kubectl access for all of your SRE / DevOps Engineers.
Allows easy creation of a kube config from a manifest file.

Todo
----
- [ ] Use GoLang instead of Python for the kubeconfig generation
- [ ] Support editing the kube config within the `KUBECONFIG` environment var
- [ ] Expand usage manifest examples
- [ ] Create k9s base config? -- or persist across containers/sessions
- [ ] Persist container command history across containers/sessions
- [ ] Manifest certificates can point to URL, relative path, or absolute path of certificate file that is retrieved (copied) into the local repo.

Installation
------------

1. Clone this repo.
2. Configure the `cluster_manifest.yaml` file with all the clusters you need access to.
3. Run `make generate` to generate a `kube_config.yaml` file.
    - This can be used locally or within the Docker container.
    - Locally on your workstation using `export KUBECONFIG=$PWD/kube_config.yaml`
    - Within a Docker container by running `make run`

#### Note:
You can combine multiple kube configs using the following command:
```sh
export KUBECONFIG=$PWD:kube_config.yaml:$HOME/.kube/config
```

To persist this config across terminal sessions, place the export command in your `.bash_profile` or `.zshrc` file.

Usage
-----

* Run `make build` to rebuild the container.
* Run `make generate` to regenerate the `kube_config.yaml` from the `cluster_manifest.yaml` at any time.
* Run `make run` to run the container.

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

Included Tools
--------------

This repo contains an image build for managing Kubernetes clusters using the following tools:
* kubectl - Kubernetes CLI tool
* k9s - Provides a terminal UI to interact with your Kubernetes clusters.
* kubectx - Kubernetes config context utility
* kubens - Kubernetes context-namespace utility
* kubie - Improved and expanded kubectx/ns alternative
* fluxctl - FluxCD CTL tool
* kube-ps1 - Kubernetes prompt

