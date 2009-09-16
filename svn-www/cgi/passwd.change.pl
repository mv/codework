#!/u01/subversion/local/bin/perl -wT
# $Id: passwd.change.pl 2383 2006-10-27 19:02:18Z marcus.ferreira $
#
# Poor man's passwd change for svn
#
# Marcus Vinicius Ferreira      ferreira.mv[ at ]gmail.com
# Set/2006

use CGI;
use Apache::Htpasswd;

my $passwdfile="/u01/subversion/repos/mdbsvn_htpasswd";
my $ht = new Apache::Htpasswd(
                        { passwdFile => "$passwdfile"
                        , ReadOnly   => 0
                        }
                            );


my $q = new CGI;

my  $username = $q->param('username') || 'x';
my  $password = $q->param('password') || '0';
my $npassword = $q->param('npassword')|| '0';
my $rpassword = $q->param('tpassword')|| '0';



print $q->header("text/html");

# print <<EOF;
# <pre>
#     username : $username
#     password : $password
#     npassword: $npassword
#     rpassword: $rpassword
#
# </pre>
#
# EOF

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
    <body>
    <hr>
    <a href="/">Subversion: Projeto EBS/Salto </a>
    <hr>
    </body>
    OK

}
else {
    print <<"    ERR2";
    <hr>
    <pre>

    Invalid password.
    Try again.

    </pre>
    <hr>
    ERR2
};


exit 0;

__END__

- Apache::Htgroup
- Apache::Htpassword
    - Crypt::PasswdMD5
    - Digest::SHA1
