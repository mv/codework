#!/bin/bash
#
# Dump from pg, to be used on MySQL
#
# Marcus Vinicius Fereira            ferreira.mv[ at ].gmail.com
# 2012-07
#

LIST='
active_admin_comments
addresses
admin_users
authorizations
billing_addresses
brands
categories
categorizations
cep_locations
cep_neighborhoods
cep_streets
coupons
credit_templates
credits
favorite_products
invitations
order_items
order_logs
orders
pictures
product_descriptors
products
schema_migrations
settings
shipping_companies
shipping_ranges
users
'

 db='dinda_production'
 dt=$( /bin/date '+%F_%H%M%S' )
dir=${db}_${dt}
log=${db}_${dt}_count.log
txt=/tmp/${db}_count.$$.txt


cat <<EOF >$log

$db : $dt

Results
-------

EOF

/bin/rm -f $txt
mkdir -p ${dir}/

for table in $LIST
do
    echo "Dump INSERT: $table"
    pg_dump --data-only --inserts --column-inserts --blobs -t $table $db \
      | egrep -v '^SELECT pg_catalog|^SET |^$' \
      > ${dir}/${table}.ins.sql

    echo "$table $( egrep '^INSERT' ${dir}/${table}.ins.sql | wc -l ) records." >> $txt

done

# archive
tar cvfz ${dir}.tar.gz ${dir}

# results
column -t $txt >> $log
cat $log

/bin/rm -f $txt

# vim:ft=sh:

