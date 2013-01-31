#
# Ref:
#     http://msdn.microsoft.com/en-us/library/ms162773.aspx
#


### Simple

    sqlcmd -S db.example.com\mydb -U user -P password
    sqlcmd -S db.example.com      -U user -P password -d mydb



### Types of connection

    sqlcmd -S     db.example.com\mydb      -U user -P password  # default
    sqlcmd -S tcp:db.example.com\mydb,1433 -U user -P password  # default
    sqlcmd -S lpc:db.example.com\mydb      -U user -P password  # lpc: shared memory
    sqlcmd -S  np:db.example.com\mydb      -U user -P password  #  np:named pipes



### Using environment variables

        # all but pass
        set SQLCMDSERVER=db.example.com
        set SQLCMDDBNAME=mydb
        set SQLCMDUSER=user

        sqlcmd -P password

        # all
        set SQLCMDSERVER=db.example.com
        set SQLCMDDBNAME=mydb
        set SQLCMDUSER=user
        set SQLCMDPASSWORD=mypass

        sqlcmd



### Scripting a query


    sqlcmd -Q 'select count(1) from users;'     # execute and quit sqlcmd
    sqlcmd -q 'select count(1) from users;'     # execute and stays at sqlcmd

    sqlcmd -i query.sql                         # read from input script
    sqlcmd -i query.sql -o results.txt          # save output
    sqlcmd -i query.sql -o results.txt -u       # output file in unicode



### Listing all available instances for a server

    sqlcmd -L


