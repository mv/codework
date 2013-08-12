

# Finding a SQL Text

    # pre-req
    use master
    go
    GRANT VIEW SERVER STATE TO my_user
    go


    # SQL Text
    SELECT t.TEXT QueryName,
                last_elapsed_time
            FROM sys.dm_exec_query_stats s
            CROSS APPLY sys.dm_exec_sql_text( s.sql_handle ) t
            WHERE t.TEXT like '%108727%'


