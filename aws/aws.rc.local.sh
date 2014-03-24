#!/bin/bash
#

# AWS meta-data
export EC2_PUBLIC_NAME=$(     /usr/bin/curl -s http://169.254.169.254/latest/meta-data/public-hostname )
export EC2_INSTANCE_TYPE=$(   /usr/bin/curl -s http://169.254.169.254/latest/meta-data/instance-type   )
export EC2_SECURITY_GROUPS=$( /usr/bin/curl -s http://169.254.169.254/latest/meta-data/security-groups )

# Using my public name
#cho $EC2_PUBLIC_NAME > /etc/hostname
#xport PS1='\u@\H:\w\n\$ '

# Using a fixed name
echo centos-base-03.sa-east-1.compute.amazonaws.com > /etc/hostname

# Defining
/bin/hostname $( cat /etc/hostname )
export PS1='\u@\h:\w\n\$ '


