#!/bin/sh

certCABundleFile="${PWD}/ca_certs.pem"

# Add the System root certs
security export -k "/System/Library/Keychains/SystemRootCertificates.keychain" -t "certs" -p > $certCABundleFile
security export -k "/Library/Keychains/System.keychain" -t "certs" -p >> $certCABundleFile



