#!/bin/bash
#
# ref: http://www.commandlinefu.com/commands/view/2491/sort-a-list-of-numbers-on-on-line-separated-by-spaces.
#

curl -v -k -u user:password 
    "https://members.dyndns.org/nic/update?hostname=<your_domain_name_here>&myip=$(curl -s http://checkip.dyndns.org | sed 's/[a-zA-Z<>/ :]//g')&wildcard=NOCHG&mx=NOCHG&backmx=NOCHG"

