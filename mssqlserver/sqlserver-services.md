sqlserver-services





SQL Server Browser
------------------

(Using SQL Server Browser)[http://msdn.microsoft.com/en-us/library/ms165724(v=sql.90).aspx]
(SQL Server Browser Service)[http://msdn.microsoft.com/en-us/library/ms181087(v=sql.100).aspx]


    UDP 1434

    - Broadcastas all instances currently installed in a server.
    - Disabled in SQLServer Express



### Privileges

The minimum user rights for SQL Server Browser are the following:

    Deny access to this computer from the network
    Deny logon locally
    Deny Log on as a batch job
    Deny Log On Through Terminal Services
    Log on as a service
    Read and write the SQL Server registry keys related to network communication (ports and pipes)


### Default account


Other possible accounts include the following:

    Any 'domain\local' account
    The 'local service' account (not available on W2K platforms)
    The 'local system' account (not recommended as has unnecessary privileges)


