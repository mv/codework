

# RPMs from dev.mysql.com

    MySQL-client-5.6.12-2.el6.x86_64.rpm
    MySQL-devel-5.6.12-2.el6.x86_64.rpm
    MySQL-embedded-5.6.12-2.el6.x86_64.rpm
    MySQL-server-5.6.12-2.el6.x86_64.rpm
    MySQL-shared-5.6.12-2.el6.x86_64.rpm
    MySQL-shared-compat-5.6.12-2.el6.x86_64.rpm
    MySQL-test-5.6.12-2.el6.x86_64.rpm


# Roolback

    rpm -e --nodeps MySQL-shared-compat \
                    MySQL-client        \
                    MySQL-devel
    yum install -y
            mysql-libs  \
            mysql       \
            mysql-devel


