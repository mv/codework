

# Finding a SQL Text

    # create user
    --
    -- reference: http://sqlserverplanet.com/security/add-users-to-database-script
    --

    ### 1: login/passwd
    CREATE LOGIN my_user WITH PASSWORD='my_user'
    go

    ### 2: user inside a database
    USE my_database_prd
    go
    CREATE USER my_user FOR LOGIN my_user
    go
    exec sp_addrolemember 'db_datareader', my_user
    go


