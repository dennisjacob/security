#!/bin/bash
KEY_FILE=mycert.key
CERT_FILE=mycert.crt
CA_CERT_LIST="intermediate-ca.crt root-ca.crt"
OUTPUT_JKS_FILE=mycert.jks
ALIAS=my-alias
echo "onverting pem to p12"
openssl pkcs12 -export -in $CERT_FILE -inkey $KEY_FILE  -out OUTPUT_JKS_FILE.p12 -name $ALIAS
echo "converting p12 file to jks"
keytool -importkeystore -srckeystore OUTPUT_JKS_FILE.p12  -srcstoretype pkcs12 -deststoretype jks -destkeystore $OUTPUT_JKS_FILE
echo "Importing CAs"
for each in $CA_CERT_LIST
do
keytool -importcert -keystore  $OUTPUT_JKS_FILE -file $each -alias $each
done
