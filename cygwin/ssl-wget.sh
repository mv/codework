#
# Ref:
#     http://stackoverflow.com/questions/9224298/how-do-i-fix-certificate-errors-when-running-wget-on-an-https-url-in-cygwin
#

pushd /usr/ssl/certs

curl http://curl.haxx.se/ca/cacert.pem | \
    awk 'split_after==1{n++;split_after=0} /-----END CERTIFICATE-----/ {split_after=1} {print > "cert" n ".pem"}'
c_rehash
ln -sT /usr/ssl /etc/ssl

popd

