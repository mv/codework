#!/bin/sh
#
# This script will be executed *after* all the other init scripts.
# You can put your own initialization stuff in here if you don't
# want to do the full Sys V style init stuff.

###
### mvf: Marcus Vinicius Ferreira           ferreira.mv[ at ]gmail.com
###

touch /var/lock/subsys/local

###
### mvf: CentOS original stuff
###
# set a random pass on first boot
if [ -f /root/firstrun ]; then
  dd if=/dev/urandom count=50 | md5sum | passwd --stdin root
  passwd -l root
  rm /root/firstrun
fi

###
### mvf: get KeyPair inside a function
###
get_key_pair_for() {

    user="${1}"
    gid=$( getent passwd "$user" | awk -F: '{print $4}' )
    dir=$( getent passwd "$user" | awk -F: '{print $6}' )/.ssh

    # User must exist
    if [ "${gid}" == "" ]
    then
        logger -i -t "$0" "User [${user}] does not exist. Skipping."
        return
    fi

    # ~/.ssh must exist
    if [ ! -d ${dir} ]; then
      mkdir -m 0700 -p  ${dir}
      chown ${user}:${gid} ${dir}
      restorecon ${dir}
    fi

    # Get the root ssh key setup
    for retry in {1..3}
    do
      if curl -s -f http://169.254.169.254/latest/meta-data/public-keys/0/openssh-key > ${dir}/authorized_keys
      then
        chown ${user}:${gid} ${dir}/authorized_keys
        chmod 600            ${dir}/authorized_keys
        restorecon           ${dir}/authorized_keys
        logger -i -t "$0" "EC2 KeyPair for [${user}] ok."
        break
      else
        logger -i -t "$0" "EC2 KeyPair for [${user}] retrying..."
        sleep 2
      fi
    done

    logger -i -t "$0" "EC2 KeyPair NOT FOUND."
}

get_key_pair_for    root
get_key_pair_for    ec2-user

# vim:ft=sh:
