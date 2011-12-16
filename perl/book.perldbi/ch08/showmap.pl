#!/usr/bin/perl -w
#
# ch07/showallsites.pl: Lists the sites in the database on a dynamically 
#                       generated map
#

### The grid locations of each map square ( bottom-left on nodots.gif )
%gridorigins = (
    'HU' => '301:98',
    'HY' => '228:171', 
    'NA' => '9:244',
    'NB' => '82:244',
    'NC' => '155:244',
    'ND' => '228:244',
    'NF' => '9:317',
    'NG' => '82:317',
    'NH' => '155:317',
    'NJ' => '228:317',
    'NK' => '301:317',
    'NL' => '9:390',
    'NM' => '82:390',
    'NN' => '155:390',
    'NO' => '228:390',
    'NR' => '82:463',
    'NS' => '155:463',
    'NT' => '228:463',
    'NU' => '301:463',
    'NX' => '155:536',
    'NY' => '228:536',
    'NZ' => '301:536',
    'SC' => '155:609',
    'SD' => '228:609',
    'SE' => '301:609',
    'SH' => '155:682',
    'SJ' => '228:682',
    'SK' => '301:682',
    'SM' => '82:755',
    'SN' => '155:755',
    'SO' => '228:755',
    'SP' => '301:755',
    'SS' => '155:828',
    'ST' => '228:828',
    'SU' => '301:828',
    'SV' => '9:901',
    'SW' => '82:901',
    'SX' => '155:901',
    'SY' => '228:901'
  );

### The root directory for the HTML and GIF images for this script ( nodots.gif )
*ROOTDIR = \"/opt/WWW/documents.symbolstone/technology/perl/DBI/megalithdemo";

use DBI;
use CGI;
use GD;
use MegalithDB;

my $query = new CGI;
print $query->header;

### Write out the header for the page
print <<EOF;
<HTML>
<HEAD>
<TITLE>All Megalithic Sites in Database</TITLE>
<SCRIPT LANGUAGE="JavaScript">
function bar(message)
{
   window.status = message
   return true
}
</SCRIPT>
</HEAD>
<BODY BGCOLOR="#ffffff" TEXT="#000000" LINK="#3a15ff" ALINK="#ff0000" VLINK="#ff282d">
<TABLE BORDER=0 WIDTH="100%">
<TR><TD VALIGN=top>
    <FONT SIZE="-1" FACE="Helvetica,Arial,Verdana">
    <CENTER>
    <A HREF="/index.html"><IMG SRC="/img/symstone.gif" WIDTH=126 HEIGHT=189 ALT="[ Symbolstone ]" BORDER=0></A>
    </CENTER>
    <!-- Navigation links -->
    <UL>
    <LI><A HREF="/technology/perl/DBI/index.html">DBI</A>
   	</UL>
    <!-- End of navigation links -->
    </FONT>
    </TD>
    </FONT></TD>
<TD VALIGN=top>
<FONT FACE="Helvetica,Arial,Verdana">
<!-- Main document body in here -->
<CENTER>
<FONT SIZE="+2">
All Megalithic Sites
</FONT>
<BR>
<FONT SIZE="-1">
<I>Original map template by Alastair McIvor for the <A HREF="http://www.megalith.ukf.net">Megalith Map</A></I>
</FONT>
</CENTER>
<P>
EOF

### Open up the template GIF for the map sheets
open MAPGIF, "$ROOTDIR/nodots.gif";
$image = newFromGif GD::Image( MAPGIF );
if ( !defined $image ) {
    die "Cannot create image: $!\n";
  }

### Start the image map declaration
$imageMap = "";
$imageMap = "<MAP NAME=\"Megalithic Sites Map\">\n";

### Extract the sites from the database and print 'em out...
my $dbh = DBI->connect( $MegalithDB::DSN, $MegalithDB::USER, $MegalithDB::PASS );

my $sth = $dbh->prepare( "
            SELECT meg.id, meg.name, meg.location, meg.mapref, 
                   meg.site_type_id, st.site_type
            FROM megaliths meg, site_types st
            WHERE meg.site_type_id = st.id
          " );
$sth->execute;

while ( my ( $meg_id, $meg_name, $meg_location, $meg_mapref, $meg_site_type_id,
             $st_site_type ) = $sth->fetchrow_array ) {
    ### Work out the pixel locations....
    my $WIDTH = 73;
    my $HEIGHT = 73;
    my $cx = 0;
    my $cy = 0;
    $ossheet = $meg_mapref;
    $ossheet =~ s/(\ |[0-9])*//g;
    $osgridref = $meg_mapref;
    $osgridref =~ s/[A-Za-z]+//g;
    $osgridref =~ s/\ *//g;
    my $oslength = length( $ossheet );
    if ( $oslength > 0 ) {
        if ( ( $oslength % 2 ) != 0 ) {
            print "Bogus mapsheet!\n\<P>\n";
          }
        $oslength = length( $osgridref );
        $cx = substr( $osgridref, 0, $oslength / 2 );
        $cy = substr( $osgridref, $oslength / 2, $oslength / 2 );
        $cx /= 1000;
        $cy /= 1000;
        $cx *= $WIDTH;
        $cy *= $HEIGHT;

        ### Translate the point on the map
        if ( !exists $gridorigins{$ossheet} ) {
            die "Cannot locate grid origin for mapsheet: $ossheet\n";
          } else {
            my $org = $gridorigins{$ossheet};
            ( $orgx, $orgy ) = split( /\:/, $org );
            $cx += $orgx;
            $cy = $orgy - $cy;
          }

        print STDERR "Location of site: $meg_mapref -> ( $cx, $cy )\n";
        my $red = $image->colorAllocate( 1, 0, 0 );
        $image->arc( $cx, $cy, 10, 10, 0, 360, $red );
        $image->fill( $cx, $cy, $red );

        ### Add this to the image-map
        $imageMap .= "<AREA SHAPE=\"circle\" COORDS=\"$cx,$cy,10 \" HREF=\"/cgi-bin/megalithdemo/showsite.pl?id=$meg_id\" ONMOUSEOVER=\"return bar( '$meg_name $st_site_type at map reference $meg_mapref' );\" ONMOUSEOUT=\"return bar( 'Move the mouse over a site on the map' )\">\n";
      } 
  }

$dbh->disconnect;

### Write out the footer for the page
### Open the output file, write it and write the link...
open OUTFILE, ">$ROOTDIR/img/osmaps/$$.gif";
binmode OUTFILE;
print OUTFILE $image->gif();
close OUTFILE;
print <<EOF;
<CENTER>
<IMG SRC="/technology/perl/DBI/megalithdemo/img/osmaps/$$.gif" WIDTH=508 HEIGHT=904 ALT="[ Megalithic Sites Map ]" USEMAP=\"#Megalithic Sites Map\">
</CENTER>
EOF

close MAPGIF;

### Close the image map and write it to the WWW page
$imageMap .= "</MAP>\n";
print $imageMap;

print <<EOF;
<P>
<CENTER>
[ <A HREF="/cgi/megalithdemo/showallsites.pl">List All Sites</A> ] |
[ <A HREF="/cgi/megalithdemo/showmap.pl">Show UK Map</A> ]
</CENTER>
</TABLE>
<!-- Footer -->
<P>
<HR>
<CENTER>
<TABLE BORDER=0 WIDTH="100%">
<TR><TD><FONT SIZE="-1" FACE="Helvetica,Arial">
		<I>
        Last modified on: 
        <B>
        <!--#flastmod virtual="\$DOCUMENT_URI" -->
        </B>
        </I>
        </FONT>
    </TD>
    <TD><CENTER>
    	<FONT SIZE="-1" FACE="Helvetica,Arial">
    	<I><B>Copyright &copy; 1995-99
    	      <BR>
    	      <A HREF="/descarte/index.html" TARGET="_top">Alligator Descartes</A>
    	   </B>
    	</I>
    	</FONT>
    	</CENTER>
    </TD>
</TR>
</TABLE>
</CENTER>
<!-- End of footer -->
</BODY>
</HTML>
EOF

exit;
