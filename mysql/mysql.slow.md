# RDS Slow Query Log

## References

    python
      https://gist.github.com/1481025
      http://www.memonic.com/user/pneff/folder/presentation-summer-of-speed/id/1wHsJ

    ruby
      http://www.johnhawthorn.com/2011/07/slow-log-on-rds/
      https://rubygems.org/gems/rds_slow_log


## Params

### Local Mysql: my.cnf

    slow_query_log = 1
    slow_query_log_file = /var/log/mysql-slow.log
    long_query_time = 2
    min_examined_row_limit = 250
    log_queries_not_using_indexes

### Amazon RDS

    # Create a test parameter group for slow query logging.
    rds-create-db-parameter-group --db-parameter-group-name test-group --engine MySQL5.1 --description "Test group"

    # Modify the parameter group to support UTF8 and slow query logging.
    rds-modify-db-parameter-group  \
        dinda-mysql55-01           \
        --parameters="name=slow_query_log         , value=ON              , method=immediate" \
        --parameters="name=long_query_time        , value=2               , method=immediate" \
        --parameters="name=min_examined_row_limit , value=250             , method=immediate" \
        --parameters="name=wait_timeout           , value=600             , method=immediate" \
        --parameters="name=interactive_timeout    , value=600             , method=immediate" \
        --parameters="name=max_allowed_packet     , value=524288000       , method=immediate" # 500M

#       --parameters="name=max_allowed_packet     , value=67108864        , method=immediate" # 64M

    # Modify RDS instance
    rds-modify-db-instance rds-db --db-parameter-group-name test-group

    # Reboot it.
    rds-reboot-db-instance rds-db

    # Connect to the RDS instance after it is rebooted, execute 2s query, and check the table.
    select * from mysql.slow_log \G

    # Rotate the log out of the table with this command. It will move the queries to mysql.slow_log_backup.
    \u mysql
    call rds_rotate_slow_log


## Analyzing

    https://github.com/wvanbergen/request-log-analyzer
    mysqldumplog


