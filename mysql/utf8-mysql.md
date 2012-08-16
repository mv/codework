Ref:
    http://dev.mysql.com/doc/refman/5.6/en/server-system-variables.html

# Shell environment

    export LC_ALL=en_US.UTF-8
    export LANG=en_US.UTF-8
    export LANGUAGE=en_US.UTF-8

# Mysql client

    # option 1
    set names utf8 collate utf8_bin ;
    # option 2
    charset utf8;

# /etc/my.cnf

    ### option 1
    collation-server=utf8_general_ci

    ### option 2
    collation-server=utf8_bin

### Settings

    [client]
    default-character-set=utf8

    [mysqld]
    default-character-set = utf8
    collation-server = utf8_bin
    character-set-server = utf8
    character-set-filesystem = utf8

    init-connect='SET names utf8 COLLATE utf8_bin'

# Mysql database,table,column

    ALTER DATABASE dbname DEFAULT CHARACTER SET utf8 COLLATE utf8_bin;
    ALTER TABLE    tbname DEFAULT CHARACTER SET utf8 COLLATE utf8_bin;
    ALTER TABLE    tbname MODIFY column_name TEXT         CHARACTER SET utf8 COLLATE utf8_bin;
    ALTER TABLE    tbname MODIFY column_name VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_bin;

    # I must test...
    ALTER TABLE    tbname CONVERT TO CHARACTER SET utf8 COLLATE utf8_unicode_ci;


## SQL Query

    select table_schema
         , table_name
         , table_collation
      from information_schema.tables
     where table_schema like 'dinda%'
    -- and table_collation <> 'utf8_bin'
         ;


## SQL generation

### table level
    select concat('alter table '
         , table_name
         , ' DEFAULT CHARSET=utf8 COLLATE=utf8_bin;') as cmd
      from information_schema.tables
     where table_schema like 'dinda%'
         ;

    # alter table addresses  DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
    # alter table brands     DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
    # alter table categories DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

### column level

    select concat( 'alter table ',table_name
         , ' modify ', column_name, ' ', data_type, '(',character_maximum_length,')'
         , ' CHARSET utf8 COLLATE utf8_bin ;') cmd
      from information_schema.columns
     where table_schema like 'dinda%'
       and data_type = 'varchar'
       and (   collation_name     <> 'utf8'
            or character_set_name <> 'utf8_bin'
           )
    UNION
    select concat( 'alter table ',table_name
         , ' modify ', column_name, ' ', data_type
         , ' CHARSET utf8 COLLATE utf8_bin ;') cmd
      from information_schema.columns
     where table_schema like 'dinda%'
       and data_type = 'text'
       and (   collation_name     <> 'utf8'
            or character_set_name <> 'utf8_bin'
       )
    ;

    # alter table users  modify email       varchar(255) CHARSET utf8 COLLATE utf8_bin ;
    # alter table users  modify first_name  varchar(100) CHARSET utf8 COLLATE utf8_bin ;
    # alter table users  modify last_name   varchar(100) CHARSET utf8 COLLATE utf8_bin ;
    # alter table brands modify description text         CHARSET utf8 COLLATE utf8_bin ;


vim:ft=markdown:

