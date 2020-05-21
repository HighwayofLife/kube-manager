FROM mcr.microsoft.com/azure-cli:2.5.1 AS builder
# From Source tag list: https://mcr.microsoft.com/v2/azure-cli/tags/list
# Note: This image is huge, so we create a multi-stage build to copy
#   the built contents into the final image

ARG APP_VERSION=1.18.2-0.1

# https://github.com/kubernetes/kubectl/releases
ARG KUBECTL_VERSION=1.18.2

# https://github.com/derailed/k9s/releases
ARG K9S_VERSION=0.19.5

# https://github.com/fluxcd/flux/releases
ARG FLUXCTL_VERSION=1.19.0

# https://github.com/ahmetb/kubectx/releases
ARG KUBECTX_VERSION=0.9.0

# https://github.com/jonmosco/kube-ps1/releases
ARG KUBE_PS1_VERSION=0.7.0

RUN echo "Installing kube-ps1 prompt" && \
  curl -o /etc/profile.d/kube-ps1.sh \
  https://raw.githubusercontent.com/jonmosco/kube-ps1/v${KUBE_PS1_VERSION}/kube-ps1.sh

RUN echo "Installing KubeCTX (Kubectl Context)" && \
  curl -fL -o /tmp/kubectx.tar.gz \
  https://github.com/ahmetb/kubectx/releases/download/v${KUBECTX_VERSION}/kubectx_v0.9.0_linux_x86_64.tar.gz && \
  tar -C /usr/local/bin -xzvf /tmp/kubectx.tar.gz && \
  rm -rf /tmp/kubectx.tar.gz

RUN echo "Installing KubeNS (Kubectl Context Namespace)" && \
  curl -fL -o /tmp/kubens.tar.gz \
  https://github.com/ahmetb/kubectx/releases/download/v${KUBECTX_VERSION}/kubens_v0.9.0_linux_x86_64.tar.gz && \
  tar -C /usr/local/bin -xzvf /tmp/kubens.tar.gz && \
  rm -rf /tmp/kubens.tar.gz

RUN echo "Installing FlexCTL" && \
  curl -fL -o /usr/local/bin/fluxctl \
  https://github.com/fluxcd/flux/releases/download/${FLUXCTL_VERSION}/fluxctl_linux_amd64 && \
  chmod +x /usr/local/bin/fluxctl

RUN echo "Installing Kubectl" && \
  curl -o /usr/local/bin/kubectl \
  https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
  chmod +x /usr/local/bin/kubectl

RUN echo "Installing K9s" && \
  curl -fL -o /tmp/k9s.tar.gz \
  https://github.com/derailed/k9s/releases/download/v${K9S_VERSION}/k9s_Linux_x86_64.tar.gz && \
  tar -C /usr/local/bin -xzvf /tmp/k9s.tar.gz && \
  rm -rf /tmp/k9s.tar.gz

# Create final image
FROM python:3.8.3-alpine3.11
# https://hub.docker.com/_/python?tab=description

COPY --from=builder /usr/local/bin/az* /usr/local/bin/jp* /usr/local/bin/k* /usr/local/bin/fluxctl /usr/local/bin/
COPY --from=builder /etc/profile.d/kube-ps1.sh /etc/profile.d/kube-ps1.sh
COPY ./.bashrc /root/.bashrc

## When running on-prem or in corp networks, create a ca_certs.pem file
##  containing the root CA certs and any SCM CA certs
COPY ca_certs.pem /usr/local/share/ca-certificates/ca_certs.pem

RUN apk add --update --no-cache sudo bash openssh ca-certificates jq curl openssl git vim && \
  echo "Updating and installing CA Certs, warnings can be ignored" && \
  update-ca-certificates && \
  mkdir -p ${HOME}/.kube

WORKDIR /root

ENTRYPOINT ["/bin/bash"]

