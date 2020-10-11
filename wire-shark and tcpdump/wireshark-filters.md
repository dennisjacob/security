### TCP dump and wireshark filters



#### TCP dump filter to extract the Server Hello and Client Hello records in the TCP packets


```bash

# Extract the TCP packets  which are Client and Server Hello and port is 8443

((tcp[((tcp[12:1] &  0xf0 ) >> 2 ) + 5:1] == 0x01) or (tcp[((tcp[12:1] &  0xf0 ) >> 2 ) + 5:1] == 0x02) ) and port 8443 and (tcp[((tcp[12:1] & 0xf0 ) >> 2):1] = 0x16)

```


#### Wireshark Filters


```
# Filter SSL and TLS protocols upto TLS 1.2
ssl.record.version  == 0x303 or ssl.record.version  == 0x302 or ssl.record.version  == 0x301 or ssl.record.version  == 0x300  


# Look for content in an unencrypted or decrypted HTTP packet stream
http.request.uri contains "healthcheck"


# Capture all Server Hello and Client Hello records in a TCP packet
ssl.handshake.type == 1 or ssl.handshake.type == 2

# Looks for certificate in Server Hello and Client Hello TLS records containing ".visa.com"
x509sat.printableString contains ".visa.com"


#Look for SNI(Subject Name Indicator) contains "com"
ssl.handshake.extensions_server_name contains "com"

#Filter all TLS handshake failures
ssl.alert_message.desc == 40 


```

