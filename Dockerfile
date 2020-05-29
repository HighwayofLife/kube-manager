FROM python:3.8.3-alpine3.11

# https://github.com/kubernetes/kubectl/releases
ARG KUBECTL_VERSION=1.18.3

# https://github.com/derailed/k9s/releases
ARG K9S_VERSION=0.20.2

# https://github.com/fluxcd/flux/releases
ARG FLUXCTL_VERSION=1.19.0

# https://github.com/ahmetb/kubectx/releases
ARG KUBECTX_VERSION=0.9.0

# https://github.com/jonmosco/kube-ps1/releases
ARG KUBE_PS1_VERSION=0.7.0

# https://github.com/sbstp/kubie/releases
ARG KUBIE_VERSION=0.9.1

ENV TERM xterm-256color

COPY requirements.txt ./

RUN apk add --update --no-cache bash zsh zsh-vcs openssh openssl ca-certificates jq curl git vim xclip && \
  apk add --update --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing \
  hub xsel && \
  apk add --update --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/community \
  wl-clipboard zsh-autosuggestions && \
  apk add --no-cache --virtual=.build-deps gcc openssl-dev libffi-dev musl-dev && \
  echo "Updating and installing CA Certs, warnings can be ignored" && \
  update-ca-certificates && \
  mkdir -p ${HOME}/.kube && \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
  pip3 install --no-cache-dir -r requirements.txt && \
  apk del .build-deps

RUN echo "Installing kube-ps1 prompt" && \
  curl -o /etc/profile.d/kube-ps1.sh \
  https://raw.githubusercontent.com/jonmosco/kube-ps1/v${KUBE_PS1_VERSION}/kube-ps1.sh && \
  echo "Installing KubeCTX (Kubectl Context)" && \
  curl -fL -o /tmp/kubectx.tar.gz \
  https://github.com/ahmetb/kubectx/releases/download/v${KUBECTX_VERSION}/kubectx_v${KUBECTX_VERSION}_linux_x86_64.tar.gz && \
  tar -C /usr/local/bin -xzvf /tmp/kubectx.tar.gz && \
  rm -rf /tmp/kubectx.tar.gz && \
  echo "Installing KubeNS (Kubectl Context Namespace)" && \
  curl -fL -o /tmp/kubens.tar.gz \
  https://github.com/ahmetb/kubectx/releases/download/v${KUBECTX_VERSION}/kubens_v${KUBECTX_VERSION}_linux_x86_64.tar.gz && \
  tar -C /usr/local/bin -xzvf /tmp/kubens.tar.gz && \
  rm -rf /tmp/kubens.tar.gz && \
  echo "Installing Kubie (more powerful alternative to kubectx/ns)" && \
  curl -o /usr/local/bin/kubie \
  https://github.com/sbstp/kubie/releases/download/v${KUBIE_VERSION}/kubie-linux-amd64 && \
  chmod +x /usr/local/bin/kubie && \
  echo "Installing FlexCTL" && \
  curl -fL -o /usr/local/bin/fluxctl \
  https://github.com/fluxcd/flux/releases/download/${FLUXCTL_VERSION}/fluxctl_linux_amd64 && \
  chmod +x /usr/local/bin/fluxctl && \
  echo "Installing Kubectl" && \
  curl -o /usr/local/bin/kubectl \
  https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
  chmod +x /usr/local/bin/kubectl && \
  echo "Installing K9s" && \
  curl -fL -o /tmp/k9s.tar.gz \
  https://github.com/derailed/k9s/releases/download/v${K9S_VERSION}/k9s_Linux_x86_64.tar.gz && \
  tar -C /usr/local/bin -xzvf /tmp/k9s.tar.gz && \
  rm -rf /tmp/k9s.tar.gz

WORKDIR /root/kubectl

ENTRYPOINT ["/bin/zsh"]
