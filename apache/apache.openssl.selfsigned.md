X.509 self-signed key
-----------------------

## 1. Generate Private key

    # create private key
    openssl genrsa -des3 -out server.key 1024

    # Remove passphrase
    cp server.key server.key.org
    openssl rsa -in server.key.org -out server.key


## 2. Generate a Certificate Signing Request (CSR)

    # from the private key, generate a CSR
    openssl req \
        -subj '/C=BR/ST=SP/L=São Paulo/O=EdenBrasil/OU=DevTeam/CN=Marcus Vinicius Ferreira/emailAddress=mv@baby.com.br' \
        -new -key server.key -out server.csr

    # using the CSR, create a self-signed key
    openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt

## 3. Use the keys




