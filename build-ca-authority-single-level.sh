#!/bin/bash

# Build a root CA which can be used for signing the leaf/server certificates.

ROOTCA_FILE_PREFIX=test-ca
rm -f ./${ROOTCA_FILE_PREFIX}.*
# Create the CA key
openssl genrsa -out ${ROOTCA_FILE_PREFIX}.key 4096

# Create the CSR. Modify the DN as needed.
openssl req -new -key ${ROOTCA_FILE_PREFIX}.key -sha256  -out ${ROOTCA_FILE_PREFIX}.csr -subj "/CN=root.bethel.local"

# Generate the certificate , default validity set to 10 year for the CA cert.
openssl x509 -days 3650 -req -in ${ROOTCA_FILE_PREFIX}.csr -signkey ${ROOTCA_FILE_PREFIX}.key -out ${ROOTCA_FILE_PREFIX}.crt

# Validate the cert
echo
echo "Root CA Certificate generated..."
openssl x509 -in ${ROOTCA_FILE_PREFIX}.crt -issuer -subject -dates -noout
echo
echo "Root CA private key - $(pwd)/${ROOTCA_FILE_PREFIX}.key"
echo "Root CA certificate - $(pwd)/${ROOTCA_FILE_PREFIX}.crt"
echo "Root CA Certificate Details"
openssl x509 -in $(pwd)/${INTERMCA_FILE_PREFIX}.crt -issuer -subject -dates -noout


echo "++ Script finished ++"

