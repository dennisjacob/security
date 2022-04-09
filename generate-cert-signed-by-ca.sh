#!/bin/bash
CA_PVT_KEY=test-ca.key
CA_PVT_CERT=test-ca.crt
CERT_PREFIX=mycert



openssl genrsa -out ${CERT_PREFIX}.key 4096

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
commonName = portal.bethel.local
emailAddress = djacob.itsg@gmail.com

[ v3_req ]
basicConstraints = CA:FALSE
subjectKeyIdentifier = hash
keyUsage = digitalSignature, keyEncipherment
extendedKeyUsage = clientAuth, serverAuth
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = portal.bethel.local
DNS.2 = api.bethel.local
DNS.3 = secured.bethel.local
DNS.4 = *.test.bethel.local


EOF

openssl req -new -key ${CERT_PREFIX}.key -out ${CERT_PREFIX}.csr -sha256  -config ./cert-config.conf
openssl x509 -req -in ${CERT_PREFIX}.csr -CA $CA_PVT_CERT -CAkey $CA_PVT_KEY -days 365 -sha256 -out ${CERT_PREFIX}.crt -CAcreateserial -CAserial serial -extensions v3_req -extfile ./cert-config.conf
echo 
echo "Certificate generated..."
openssl x509 -in  ${CERT_PREFIX}.crt -noout -subject -issuer -dates
echo 
echo "Private key - $(pwd)/${CERT_PREFIX}.key"
echo "Private key - $(pwd)/${CERT_PREFIX}.crt"
rm -f ./cert-config.conf serial $(pwd)/${CERT_PREFIX}.csr


