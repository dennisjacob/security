#! /bin/bash

#####################################################################################################################
# Script to extract key and cert in X509 .pem format
#  
# Author : dennis.jacob@gmail.com
#####################################################################################################################


JDK_PATH=/usr/mware/java
SRC_KEYSTORE=/tmp/source.jks
P12_KEYSTORE=${SRC_KEYSTORE%%.jks}.p12
SRC_ALIAS=pvt_key_alias
SRC_PASS=pass_source_jks
DEST_ALIAS=dest_alias
DST_PASS=dest_jks_pass

[[ "x${DEST_ALIAS}" == "x" ]] && DEST_ALIAS=$SRC_ALIAS
[[ "x${DST_PASS}" == "x" ]] && DST_PASS=$SRC_PASS

${JDK_PATH}/jre/bin/keytool -importkeystore -srckeystore $SRC_KEYSTORE -destkeystore $P12_KEYSTORE -srcstoretype JKS -deststoretype PKCS12 -srcstorepass $SRC_PASS \
							-srcalias $SRC_ALIAS  -destalias $DEST_ALIAS -deststorepass $DST_PASS


openssl pkcs12 -in $P12_KEYSTORE -out ${DEST_ALIAS}.crt.pem  -clcerts -nokeys -passin pass:${DST_PASS}
openssl pkcs12 -in $P12_KEYSTORE -out ${DEST_ALIAS}.key.pem  -nocerts -nodes -passin pass:${DST_PASS}

openssl x509 -in  ${DEST_ALIAS}.crt.pem -noout -subject -issuer -dates

