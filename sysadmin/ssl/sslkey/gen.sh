
# Generate public/private key pair
echo  openssl genrsa -des3 -out server.key 1024

# Generate Certificate Signing Request
echo  openssl req -new -key server.key -out server.csr


cat <<EOF

Server Key:         server.key
Server Certificate: server.crt  (from CA, via server.csr)

Install private key and signed certificate

    httpd.conf:

       Listen 443                         # listen to the default SSL port
       <VirtualHost _default_:443>  # host config for 443 requests
         SSLEngine on
         SSLCertificateFile     conf/server.crt
         SSLCertificateKeyFile  conf/server.key
       </VirtualHost>
EOF
