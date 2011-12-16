#!/usr/bin/perl -wT
# $Id: passwd.change.pl 2175 2006-10-25 17:28:28Z marcus.ferreira $
#

use CGI;
use Apache::Htpasswd;

my $ht = new Apache::Htpasswd(
                        { passwdFile => "svn_htpasswd"
                        , ReadOnly   => 0
                        }
                            );


my $q = new CGI;

my  $username = $q->param('username') || 'x';
my  $password = $q->param('password') || '0';
my $npassword = $q->param('npassword')|| '0';
my $rpassword = $q->param('tpassword')|| '0';



print $q->header("text/plain");
print <<EOF;
<pre>
    username : $username
    password : $password
    npassword: $npassword
    rpassword: $rpassword

</pre>

EOF

if( ! $npassword eq $rpassword ) {
    print <<"    ERR1";
    <pre>

    New password does not match with retyped password.
    Try again.

    </pre>
    ERR1
};

# Change a password
my $ok = $ht->htpasswd( $username, $npassword, $password);

if( $ok ) {
    print <<"    OK";
    <pre>

    Password Changed.

    </pre>
    OK

}
else {
    print <<"    ERR2";
    <pre>

    Current password does not match.
    Try again.

    </pre>
    ERR2
};

print "
<a href="http://mdbebsgold:8080/repos/">
</a>
";

exit 0;
