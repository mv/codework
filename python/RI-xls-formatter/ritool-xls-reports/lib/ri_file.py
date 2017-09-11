#!/usr/bin/env python3

import re
import pandas as pd


###
### Column names
###

column_names = {
    'linkedaccountid'          : 'linked_account'           ,
    'Billed Instance Type'     : 'instance_type'            ,
    'OS Type'                  : 'os_type'                  ,
    'region'                   : 'region'                   ,
    'Tenancy'                  : 'tenancy'                  ,
    'OnDemand Rate'            : 'on_demand_rate'           ,
    'RI Actual Rate'           : 'ri_actual_rate'           ,
    'RI Effective Rate'        : 'ri_effective_rate'        ,
    'Usage Min'                : 'usage_min'                ,
    'Usage Max'                : 'usage_max'                ,
    'Usage Avg'                : 'usage_avg'                ,
    'Current OnDemand Price'   : 'current_on_demand_price'  ,
    'OnDemand Monthly Price'   : 'on_demand_monthly_price'  ,
    'RI Recommendation'        : 'ri_recommend'             ,
    'RI Upfront Price'         : 'ri_upfront_price'         ,
    'Effective Monthly Price'  : 'effective_monthly_price'  ,
    'Actual Monthly Price'     : 'actual_monthly_price'     ,
    'Effective Monthly Saving' : 'effective_monthly_saving' ,
    'Break Even'               : 'break_even'               ,
    'ROI %'                    : 'roi_perc'                 ,
    'Fully Paid Day'           : 'fully_paid_day'           ,
    'Confidence'               : 'confidence'               ,
    }

###
### Pandas: read original xls(csv) files
###

def get_data(file_name):
    df = pd.read_csv(file_name, sep='\t', header=1)

    #
    # fix column names
    #
    df = df.rename(columns = column_names)

    #
    # fix data types
    #
    df['linked_account'] = df['linked_account'].astype(str)

    #
    # fix values
    #
    re_region  = re.compile( r".*\((.*)\)" )
    re_os_type = re.compile( r"-License included|-No license required" )
    for index, row in df.iterrows():
        df.loc[ index, 'region' ]  = re_region.sub( r'\1', df.loc[ index, 'region'] )
        df.loc[ index, 'os_type' ] = re_os_type.sub( ''  , df.loc[ index, 'os_type'] )

    return df


def rgn_lnk(df):
    #
    # add new calculated values
    #
    df['billed_hours']  = df['current_on_demand_price']  / df['on_demand_rate']
    df['saving_perc']   = df['effective_monthly_saving'] / df['current_on_demand_price']
    df['ri_fee']        = df['ri_upfront_price']         / df['ri_recommend']

    df['monthly_hours'] = df['on_demand_monthly_price']  / df['on_demand_rate']

    #
    # re-ordering
    #
#   df = df.sort_values(['region', 'os_type', 'current_on_demand_price'], ascending=[True, False, False])
    df = df.sort_values(['region', 'current_on_demand_price'], ascending=[True, False])

    df2 = pd.DataFrame({})
    df2 = df[ [
                'linked_account'           ,
                'instance_type'            ,
                'os_type'                  ,
                'region'                   ,
                'tenancy'                  ,
                'on_demand_rate'           ,
                'billed_hours'             ,
                'current_on_demand_price'  ,
                'usage_min'                ,
                'usage_max'                ,
                'usage_avg'                ,
                'ri_recommend'             ,
                'ri_fee'                   ,
                'ri_upfront_price'         ,
                'effective_monthly_price'  ,
                'effective_monthly_saving' ,
                'saving_perc'              ,
                'break_even'               ,
                'confidence'               ,
#               'monthly_hours'            ,
#               'on_demand_monthly_price'  ,
#               'actual_monthly_price'     ,
#               'ri_actual_rate'           ,
#               'ri_effective_rate'        ,
#               'roi_perc'                 ,
#               'fully_paid_day'           ,
            ] ]

    return(df2)


def rgn_lnk_totals(df, name):
    #
    # add new calculated values
    #

    df.loc[name] = [
        name                                                                             ,
        df['current_on_demand_price'].sum()                                              ,
        df['ri_recommend'].sum()                                                         ,
        df['ri_upfront_price'].sum()                                                     ,
        df['effective_monthly_price'].sum()                                              ,
        df['effective_monthly_saving'].sum()                                             ,
        df['total_effective_monthly_saving'] / df['total_current_on_demand_price']       ,
        ]

    return(df)


