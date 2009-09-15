package MegalithDB;

###
### Contains connection information for the megalith database
###

use vars qw($DSN $USER $PASS);

### Access configuration via proxy
#$DSN = 'dbi:Proxy:hostname=fowliswester;port=3128;dsn=dbi:ODBC:megaliths';
#$USER = '';
#$PASS = '';

### Oracle test configuration to use if DBI env vars not set
if (!$ENV{DBI_DSN} && !$ENV{DBI_USER} && !$ENV{DBI_PASS}) {
#    $DSN = 'dbi:Oracle:PANTS';
    $DSN = 'dbi:Proxy:hostname=fowliswester;port=3128;dsn=dbi:ODBC:megaliths';
    $USER = 'stones';
    $PASS = 'stones';
}

### @@Kludge...
$ENV{ORACLE_HOME} ||= '/opt/ora805';

1;
