#!/usr/bin/python3
from kubeconfig import KubeConfig
from ruamel.yaml import YAML
import os
import sys
import getopt


def usage():
    print('''
    Usage: create_kubeconfig.py -u $USER -d /working/dir [, --config=<config-path>, --manifest=<manifest-path>

        Options:

        -u  --user  (Required) The User to use in the kube config. Usually $USER

        -d  --dir (Required) The working directory to use

        -c  --config (Optional) The Kube Config path to use.

        -m  --manifest (Optional) The manifest path to use.
    ''')
    sys.exit(2)


def main(argv):
    script_dir = os.path.dirname(os.path.abspath(__file__))

    workdir = ''
    user = ''
    manifest = script_dir + '/../cluster_manifest.yaml'
    kube_config = script_dir + '/../kube_config.yaml'

    try:
        opts, args = getopt.getopt(
            argv, "hu:m:c:d:", ["help", "user=", "manifest=", "dir=", "config="])
    except getopt.GetoptError:
        usage

    for opt, arg in opts:
        if opt in ('-u', '--user'):
            user = arg
        if opt in ('-m', '--manifest'):
            manifest = arg
        if opt in ('-c', '--config'):
            kube_config = arg
        if opt in ('-d', '--dir'):
            workdir = arg
        if opt in ('-h', '--help'):
            usage

    if user == '':
        usage

    if workdir == '':
        usage

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
