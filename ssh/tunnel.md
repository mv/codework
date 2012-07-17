# SSH tunnel

    # ssh -L localport:localhost:remoteport remotehost
    ssh -L 5433:localhost:5432 pg-db-01
    ssh -L 3307:localhost:3306 mysql-db-01


