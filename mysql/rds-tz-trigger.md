

## Forcing a timezone using a trigger


Create this:

        DELIMITER |
        CREATE PROCEDURE mysql.store_time_zone ()
        IF NOT (POSITION('rdsadmin@' IN CURRENT_USER()) = 1) THEN
        SET SESSION time_zone = 'Europe/Dublin';
        END IF |
        DELIMITER ;


Add to your param group.

        rds-modify-db-parameter-group my_param_group \
            --parameters "name=init_connect, value='CALL mysql.store_time_zone', method=immediate"



