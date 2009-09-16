rm -f config.sh Policy.sh
sh Configure -de
make
make test
make install

-O2 -no-strict-aliasing  -pipe
/usr/local/lib/perl5/vendor_perl/5.8/cygwin

rm -f config.sh Policy.sh
sh Configure
make
make test
make install

# You may also wish to add these:
(cd /usr/include && h2ph *.h sys/*.h)

    sh Configure   -des     \
        -Dprefix=$PREFIX    \
        -Dcc=gcc.orig       \
        -Duse64bitint       \
        -Uuseperlio         \
        -optimize="-O2 -no-strict-aliasing  -pipe"


    sh Configure
        -Dcc=gcc
        -Dusethreads
        -Duse64bitint|-Duse64bitall
        -Uuseperlio
?       -Uusedl
?       -Dusesitecustomize
        -optimize="-O2"

    grep '^install' config.sh
    &-d

Install
Configure variable  Default value
$prefixexp          /usr/local
$binexp             $prefixexp/bin
$scriptdirexp       $prefixexp/bin
$privlibexp         $prefixexp/lib/perl5/$version
$archlibexp         $prefixexp/lib/perl5/$version/$archname
$man1direxp         $prefixexp/man/man1
$man3direxp         $prefixexp/man/man3
$html1direxp        (none)
$html3direxp        (none)

CPAN
Configure variable  Default value
$siteprefixexp      $prefixexp
$sitebinexp         $siteprefixexp/bin
$sitescriptexp      $siteprefixexp/bin
$sitelibexp         $siteprefixexp/lib/perl5/site_perl/$version
$sitearchexp        $siteprefixexp/lib/perl5/site_perl/$version/$archname
$siteman1direxp     $siteprefixexp/man/man1
$siteman3direxp     $siteprefixexp/man/man3
$sitehtml1direxp    (none)
$sitehtml3direxp    (none)
    sh Configure -Dprefix=/opt/perl -Doptimize='-xpentium -xO4' -des
