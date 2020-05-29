#!/bin/sh

echo "Starting container..."
containerId=$( docker run --rm -t -d \
  -v $PWD/certs:/root/.kube/certs \
  -v $PWD:/root/kubectl \
  -v $PWD/.bashrc:/root/.bashrc \
  -v $PWD/.zshrc:/root/.zshrc \
  kubectl-manager )

echo "Creating kube_config.yaml"
docker exec -it $containerId bash -c "/usr/local/bin/python /root/kubectl/scripts/create_kubeconfig.py -u ${USER}; exit"

echo "Removing container"
docker stop $containerId

export KUBECONFIG=$PWD/kube_config.yaml