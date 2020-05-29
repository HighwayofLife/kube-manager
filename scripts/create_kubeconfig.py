#!/usr/bin/python3
from kubeconfig import KubeConfig
from ruamel.yaml import YAML
import os
import sys
import getopt


def main(argv):
    script_dir = os.path.dirname(os.path.abspath(__file__))

    user = ''
    manifest = script_dir + '/../cluster_manifest.yaml'
    kube_config = script_dir + '/../kube_config.yaml'

    try:
        opts, args = getopt.getopt(argv, "u:m:", ["user=", "manifest="])
    except getopt.GetoptError:
        print(
            'Usage: create_kubeconfig.py -u $USER [, --config=kube_config.yaml, --manifest=cluster_manifest.yaml')
        sys.exit(2)

    for opt, arg in opts:
        if opt in ('-u', '--user'):
            user = arg
        if opt in ('-m', '--manifest'):
            manifest = arg
        if opt in ('-c', '--config'):
            kube_config = arg

    conf = KubeConfig(kube_config)
    with open(manifest, 'r') as file:
        yaml = YAML()
        doc = yaml.load(file)

        for cluster in doc['clusters']:
            conf.set_cluster(
                name=cluster['name'],
                server=cluster['cluster']['server'],
                certificate_authority=cluster['cluster']['certificate-authority']
            )
            conf.set_context(
                name=cluster['name'],
                cluster=cluster['name'],
                user=user
            )

        conf.set_credentials(
            name=user,
            auth_provider=doc['auth-provider']['name'],
            auth_provider_args=doc['auth-provider']['config']
        )


if __name__ == "__main__":
    main(sys.argv[1:])
