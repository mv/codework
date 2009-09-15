#!/usr/bin/perl -w
#
# ch07/showmedia.pl: Shows the information about a given type of site
#

use DBI;
use CGI;
use MegalithDB;

my $query = new CGI;
print $query->header;

### Write out the header for the page
print <<EOF;
<HTML>
<HEAD>
<TITLE>Megalith Multimedia</TITLE>
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
Megalithic Multimedia
</FONT>
</CENTER>
<P>
EOF

if ( $query->param( 'id' ) ) {

    my $media_id = $query->param( 'id' );

    ### Extract the media information from the database and print it out...
    my $dbh = DBI->connect( $MegalithDB::DSN, $MegalithDB::USER, $MegalithDB::PASS, {
                LongReadLen => 2048
              } );

    my $sth = $dbh->prepare( "
                SELECT med.description, med.url, meg.id, meg.name
                FROM media med, megaliths meg
                WHERE med.id = $media_id
                AND med.megaliths_id = meg.id
              " );
    $sth->execute();

    while ( my ( $med_description, $med_url, $meg_id, $meg_name ) =
                    $sth->fetchrow_array ) {

        ### Twiddle the URL accordingly...
        $med_url =~ s/^#//g;
        $med_url =~ s/#$//g;
        $med_url =~ s/nerfherder/forteviot\.symbolstone\.org/g;

        print <<EOF;
<CENTER>
<TABLE BORDER=5 WIDTH="100%">
<TR><TD ALIGN=center><IMG SRC="$med_url" ALT="[ $meg_name ]"></TD>
</TR>
</TABLE>
<BR>
<FONT FACE="Helvetica,Verdana,Arial" SIZE="+1"><B>$meg_name</B></FONT>
</CENTER>
<P>
<BLOCKQUOTE>
$med_description
</BLOCKQUOTE>
<P>
<HR WIDTH=60%>
<P>
<CENTER>
[ <A HREF="/cgi/megalithdemo/showsite.pl?id=$meg_id">Return to $meg_name Information</A> ]
</CENTER>
EOF
      }

    $dbh->disconnect;
  }

### Write out the footer for the page
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
