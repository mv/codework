#!/usr/bin/env python3

import sys

import lib.ri_file
import lib.db
import lib.excel

###
###
###


# file = sys.argv[1]
dir_name    = sys.argv[1]
file_prefix = sys.argv[2]
account     = sys.argv[3]

###
### rgn_*_lnk_* files
###
df_rgn_data   = {}
df_rgn_names  = {
    'fuf_lnk_1yr': '_rgn_fuf_ri_lnk_oneyr.xls'  ,
    'fuf_lnk_3yr': '_rgn_fuf_ri_lnk_threeyr.xls',
    'puf_lnk_1yr': '_rgn_puf_ri_lnk_oneyr.xls'  ,
    'puf_lnk_3yr': '_rgn_puf_ri_lnk_threeyr.xls',
    'nuf_lnk_1yr': '_rgn_nuf_ri_lnk_oneyr.xls'  ,
    'nuf_lnk_3yr': '_rgn_nuf_ri_lnk_threeyr.xls',
}

df_rgn_totals = {}
# df_rgn_totals = pd.DataFrame({
#     'ri_type'                        : [],
#     'total_ri_recommend'             : [],
#     'total_ri_upfront_price'         : [],
#     'total_current_on_demand_price'  : [],
#     'total_effective_monthly_price'  : [],
#     'total_effective_monthly_saving' : [],
#     'total_saving_perc'              : [],
#     })

for name in df_rgn_names.keys():
    readname = dir_name + '/' + file_prefix + df_rgn_names[ name ]
    filename = file_prefix + '_rgn_' + name + '.xlsx'
    print('Read '+ readname )

    # process read files
    df = lib.ri_file.get_data( readname )
    df_rgn_data[ name ] = lib.ri_file.rgn_lnk( df )

    # totals
#   df_rgn_totals = lib.ri_file.rgn_lnk_totals( df, name )


print()

### Individual files
for name in df_rgn_names.keys():
    readname = dir_name + '/' + file_prefix + df_rgn_names[ name ]
    filename = file_prefix + '_rgn_' + name + '.xlsx'
    print('File '+ filename )
#   lib.excel.create_file( df_rgn_data, filename )
print()

### Composed files in a workbook
print('Compose')
lib.excel.create_workbook( df_rgn_data, df_rgn_totals, file_prefix + '.' + account  + '.xlsx' )
print()

