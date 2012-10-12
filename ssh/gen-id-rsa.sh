#!/bin/bash
#
# gen-id-rsa.sh
#     Generates a ssh key pair, for cap deploy
#
# Marcus Vinicius Fereira            ferreira.mv[ at ].gmail.com
# 2012-10
#

[ -z "$2" ] && {

  echo
  echo "Usage: $0 app_name env"
  echo
  echo "    Generates a ssh key pair, for an app be able to"
  echo "    make a git clone in a capistrano deploy scenario."
  echo
  echo "Example:"
  echo "    $0 app_name prd  : creates app_name_prd_id_rsa == app_name@prd"
  echo "    $0 mega_api dev  : creates mega_api_dev_id_rsa == mega_api@dev"
  echo
  exit 2
}

filename="${1}_${2}_id_rsa"
 comment="${1}@${2}"

ssh-keygen -t rsa -f ./${filename} -C ${comment} -N '' -v


# vim:ft=sh:

