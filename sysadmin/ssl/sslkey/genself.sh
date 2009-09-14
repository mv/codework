

# Self-Signed X509
openssl req -new -x509 -days 120    \
            -keyout server.self.key \
            -out    server.self.crt \
            -subj   '/CN=WebCo Self Certificate'
