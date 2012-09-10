
### first: all files must be in PEM format:

  # To convert a certificate from DER to PEM:
openssl x509 –in input.crt –inform DER –out output.crt –outform PEM
  # To convert a key from DER to PEM:

openssl rsa  –in input.key –inform DER –out output.key –outform PEM

  # To convert a key from NET to PEM:
openssl rsa  –in input.key –inform NET –out output.key –outform PEM


### From .key/.crt to .pfx
### Ref:
###     http://support.citrix.com/article/CTX106630

  # bundle .key and .crt together in .pfx:
  # obs: using a null '' password !
openssl pkcs12 -export
    -in  input.crt -inkey input.key -password pass:
    -out doman_com.pfx



### From .pfx to .key/.crt

openssl pkcs12
    -in [yourfile.pfx]
    -nocerts
    -out [private-keyfile-encrypted.key]

openssl pkcs12
    -in [yourfile.pfx]
    -clcerts
    -nokeys
    -out [certificate.crt]



### private key: removing passphrase

openssl rsa
    -in  [private-keyfile-encrypted.key]
    -out [private-keyfile-decrypted.key]

