#!/usr/bin/perl -w
#
# ch07/showtype.pl: Shows the information about a given type of site
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
<TITLE>Megalithic Site Type Information</TITLE>
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
Megalithic Site Type Information
</FONT>
</CENTER>
<P>
EOF

if ( $query->param( 'id' ) ) {

    my $site_type_id = $query->param( 'id' );

    ### Extract the site type information from the database and print it out...
    my $dbh = DBI->connect( $MegalithDB::DSN, $MegalithDB::USER, $MegalithDB::PASS, {
                LongReadLen => 2048
              } );

    my $sth = $dbh->prepare( "
                SELECT site_type, description
                FROM site_types
                WHERE id = $site_type_id
              " );
    $sth->execute;

    my ( $site_type, $description ) = $sth->fetchrow_array;

    print <<EOF;
<TABLE BORDER=1 WIDTH="100%">\n
<TR><TD VALIGN=top><FONT FACE="Helvetica,Verdana,Arial"><B>Site Type:</B></FONT></TD>
    <TD><FONT FACE="Helvetica,Verdana,Arial">$site_type</FONT></TD>
</TR>
<TR><TD VALIGN=top><FONT FACE="Helvetica,Verdana,Arial"><B>Description:</B></FONT></TD>
    <TD><FONT FACE="Helvetica,Verdana,Arial">$description</FONT></TD>
</TR>
</TABLE>
EOF

    $sth->finish;

    $sth = $dbh->prepare( "
                SELECT meg.id, meg.name, meg.location, meg.mapref
                FROM megaliths meg
                WHERE meg.site_type_id = $site_type_id
              " );
    $sth->execute;

    print <<EOF;
<P>
<HR WIDTH=60%>
<P>
<CENTER>
<FONT SIZE="+1"><B>Related Sites</B></FONT>
<P>
<TABLE BORDER=1 WIDTH="100%">
<TR><TH BGCOLOR="#ffdddd"><FONT FACE="Helvetica,Verdana,Arial">Site Name</FONT></TH>
    <TH BGCOLOR="#ffdddd"><FONT FACE="Helvetica,Verdana,Arial">Location</FONT></TH>
    <TH BGCOLOR="#ffdddd"><FONT FACE="Helvetica,Verdana,Arial">OS Grid Reference</FONT></TH>
</TR>
EOF

    while ( my ( $meg_id, $meg_name, $meg_location, $meg_mapref ) =
                $sth->fetchrow_array ) {
#        $meg_mapref = DBI::neat( $meg_mapref );
        print <<EOF;
<TR><TD><FONT FACE="Helvetica,Verdana,Arial"><A HREF="/cgi-bin/megalithdemo/showsite.pl?id=$meg_id">$meg_name</A></FONT></TD>
    <TD><FONT FACE="Helvetica,Verdana,Arial">$meg_location</FONT></TD>
    <TD><FONT FACE="Helvetica,Verdana,Arial">$meg_mapref</FONT></TD>
</TR>
EOF
      }

    print <<EOF;
</TABLE>
EOF

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
