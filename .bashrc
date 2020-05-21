export EDITOR="vim"
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

source /etc/profile.d/kube-ps1.sh

export PS1=$'\n\e[0;37;100m k8s-cli \e[0;90;43m\UE0B0\e[0;90;43m ${KUBE_PS1_CONTEXT}/${KUBE_PS1_NAMESPACE} \e[0;33;44m\UE0B0\e[0;37;44m \w \e[0;34;40m\UE0B0\e[0;39m\n$ '

alias k=kubectl
alias ku=kubectl
alias ctx=kubectx
alias ns=kubens

certCABundleFile="/usr/local/share/ca-certificates/ca_certs.pem"

if [ -f "${certCABundleFile}" ]; then
  # Enables Azure CLI to use the cert bundle when making commands/requests
  export REQUESTS_CA_BUNDLE=$certCABundleFile
fi

