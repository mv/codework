
-- table-size.sql

select table_schema
     , table_name
     , table_type
     , engine
--   , create_options
--   , version
     , table_rows
  from information_schema.tables
 where table_schema like '%zoemob%'
 order by table_schema
        , table_rows desc
-- limit 50
     ;

