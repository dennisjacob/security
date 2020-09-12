
## OpenSSL Commands

Create CA certificates

```bash

# Create the private key 
[root@k8s-master cert]# openssl genrsa -out k8s-cluster-ca.key
Generating RSA private key, 2048 bit long modulus
.....................................................+++
...............................................................+++
e is 65537 (0x10001)


# Create the CSR

[root@k8s-master cert]# openssl req -new -key k8s-cluster-ca.key -out k8s-cluster-ca.csr -subj "/CN=k8s-cluster-ca"


# Create the certificate signed

[root@k8s-master cert]# openssl x509 -req -in k8s-cluster-ca.csr -signkey k8s-cluster-ca.key -out k8s-cluster-ca.crt
Signature ok
subject=/CN=k8s-cluster-ca
Getting Private key


#Validate
[root@k8s-master cert]# openssl x509 -in k8s-cluster-ca.crt -subject -issuer -dates -noout
subject= /CN=k8s-cluster-ca
issuer= /CN=k8s-cluster-ca
notBefore=Apr  9 01:28:19 2020 GMT
notAfter=May  9 01:28:19 2020 GMT

```


Create certificates signed by CA cert

```bash

# Create the private key

[root@k8s-master cert]# openssl genrsa -out k8s-cluster.key
Generating RSA private key, 2048 bit long modulus
...................................................................+++
...................+++
e is 65537 (0x10001)

# Create the CSR

[root@k8s-master cert]# openssl req -new -key k8s-cluster.key -out k8s-cluster.csr -subj "/CN=k8s-cluster"


#Sign the cert with CA
[root@k8s-master cert]# openssl x509 -req -in k8s-cluster.csr -CA k8s-cluster-ca.crt -CAkey k8s-cluster-ca.key -out k8s-cluster.crt -CAcreateserial -CAserial serial
Signature ok
subject=/CN=k8s-cluster
Getting CA Private Key


# Verify
[root@k8s-master cert]# openssl x509 -in k8s-cluster.crt -noout -subject -dates -issuer
subject= /CN=k8s-cluster
notBefore=Apr  9 02:36:11 2020 GMT
notAfter=May  9 02:36:11 2020 GMT
issuer= /CN=k8s-cluster-ca
[root@k8s-master cert]#


```

Note


For handling addtional SANs, you may need to call openssl req with options below

``` bash
$ cat openssl.cnf

[req]
req_extensions = v3_req

[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation,
subjectAltName = @alt_names

[alt_names]
DNS.1 = kubernetes
DNS.2 = kubernetes.default
DNS.3 = kubernetes.default.svc.cluster.local
IP.1 = 10.96.0.1

$ openssl req -new -key k8s-cluster.key -out k8s-cluster.csr -subj "/CN=k8s-cluster" --config openssl.cnf
```


