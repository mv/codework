
X.509 self-signed key
-----------------------

## 1. Generate Private key

    # create private key
    openssl genrsa -des3 -out pk.encrypted.key 1024

    # Remove passphrase from encrypted key
    openssl rsa -in pk.encrypted.key -out pk.key

    # Name private key using AWS name
    cp pk.key pk-user-aws.pem


## 2. Generate a Certificate Signing Request (CSR)

    # from the private key, generate a CSR
    openssl req \
        -subj '/C=BR/ST=SP/L=São Paulo/O=EdenBrasil/OU=DevTeam/CN=Marcus Vinicius Ferreira/emailAddress=mv@baby.com.br' \
        -new -key pk.key -out cert.csr

    # using the CSR, create a self-signed key
    openssl x509 -req -days 365 \
        -signkey pk.key \
        -in  cert.csr   \
        -out cert.crt

    # Name certificate using AWS name
    cp cert.crt cert-user-aws.pem

## 3. Use the keys

    # copy keys to $HOME/.ec2/
    cp *pem /home/user/.ec2/

    # Upload certifate (i.e., public part of your key) to AWS console IAM
    # cert-*.pem

