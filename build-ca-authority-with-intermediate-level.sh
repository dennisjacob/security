#!/bin/bash
# Build CA with root and intermediate

ROOTCA_FILE_PREFIX=root-ca
CA_PVT_KEY=${ROOTCA_FILE_PREFIX}.key
CA_PVT_CERT=${ROOTCA_FILE_PREFIX}.crt
INTERMCA_FILE_PREFIX=intermediate-ca

rm -f ./${ROOTCA_FILE_PREFIX}.*
# Create the CA key
openssl genrsa -out ${ROOTCA_FILE_PREFIX}.key 4096

# Create the CSR. Modify the DN as needed.
openssl req -new -key ${ROOTCA_FILE_PREFIX}.key -sha256  -out ${ROOTCA_FILE_PREFIX}.csr -subj "/CN=root.bethel.local"

# Generate the certificate , default validity set to 10 year for the CA cert.
openssl x509 -days 3650 -req -in ${ROOTCA_FILE_PREFIX}.csr -signkey ${ROOTCA_FILE_PREFIX}.key -out ${ROOTCA_FILE_PREFIX}.crt

# Validate the cert
echo
echo "Root Certificate generated..."
openssl x509 -in ${ROOTCA_FILE_PREFIX}.crt -issuer -subject -dates -noout
echo
echo "Root CA private key - $(pwd)/${ROOTCA_FILE_PREFIX}.key"
echo "Root CA certificate - $(pwd)/${ROOTCA_FILE_PREFIX}.crt"
echo "Root Cert Details"
openssl x509 -in $(pwd)/${ROOTCA_FILE_PREFIX}.crt -issuer -subject -dates -noout


openssl genrsa -out ${INTERMCA_FILE_PREFIX}.key 4096

rm -f cert-config.conf && cat << EOF >> cert-config.conf
[ req ]
default_bits = 4096
prompt = no
default_md = sha256
distinguished_name = req_dn
x509_extensions = v3_req

[ req_dn ]
countryName = SG
localityName = Singapore
organizationName = bethel
commonName = intermediate.bethel.local

[ v3_req ]
basicConstraints = CA:TRUE
subjectKeyIdentifier = hash


EOF

openssl req -new -key ${INTERMCA_FILE_PREFIX}.key -out ${INTERMCA_FILE_PREFIX}.csr -sha256  -config ./cert-config.conf
openssl x509 -req -in ${INTERMCA_FILE_PREFIX}.csr -CA $CA_PVT_CERT -CAkey $CA_PVT_KEY -days 1825 -sha256 -out ${INTERMCA_FILE_PREFIX}.crt -CAcreateserial -CAserial serial -extensions v3_req -extfile ./cert-config.conf
echo
echo "Intermediate Certificate generated..."
echo
echo "Intermediate Private key - $(pwd)/${INTERMCA_FILE_PREFIX}.key"
echo "Intermediate Private key - $(pwd)/${INTERMCA_FILE_PREFIX}.crt"
echo "Intermediate Cert Details"
openssl x509 -in $(pwd)/${INTERMCA_FILE_PREFIX}.crt -issuer -subject -dates
rm -f ./cert-config.conf serial $(pwd)/${INTERMCA_FILE_PREFIX}.csr


