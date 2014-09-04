
[ -z "$1" ] && {

  echo
  echo "Usage: $0 /path/to/key.pem"
  echo
  exit 1

}

key="$1"

set -x
openssl pkcs8 -in "$1"  -nocrypt -topk8 -outform DER | openssl sha1 -c
set +x

# vim:ft=sh:

