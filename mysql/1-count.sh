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

for table in $LIST
do
    results=$( mysql -B -s -e "SELECT COUNT(1) FROM $table" )
    echo "$table: $results"
done | column -t

# vim:ft=sh:

