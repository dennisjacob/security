#!/bin/bash
FILE_PREFIX=test-ca
rm -f ./${FILE_PREFIX}.*
# Create the CA key
openssl genrsa -out ${FILE_PREFIX}.key 4096

# Create the CSR. Modify the DN as needed.
openssl req -new -key ${FILE_PREFIX}.key -sha256  -out ${FILE_PREFIX}.csr -subj "/CN=*.bethel.local"

# Generate the certificate , default validity set to 10 year for the CA cert.
openssl x509 -days 3650 -req -in ${FILE_PREFIX}.csr -signkey ${FILE_PREFIX}.key -out ${FILE_PREFIX}.crt

# Validate the cert
echo
echo "Certificate generated..."
openssl x509 -in ${FILE_PREFIX}.crt -issuer -subject -dates -noout
echo
echo "CA private key - $(pwd)/${FILE_PREFIX}.key"
echo "CA certificate - $(pwd)/${FILE_PREFIX}.crt"
echo "++ Script finished ++"

