#!/usr/bin/perl -w
#
# ch07/showallsites.pl: Lists the sites in the database grouped by type and
#                       alphabetically in table format.
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
<TITLE>All Megalithic Sites in Database</TITLE>
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
</CENTER>
<P>
<TABLE BORDER=1 WIDTH=100%>
EOF

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
#    $meg_mapref = DBI::neat( $meg_mapref );
    print <<EOF;
<TR><TD><FONT FACE="Helvetica,Verdana,Arial"><A HREF="/cgi-bin/megalithdemo/showsite.pl?id=$meg_id">$meg_name</A></FONT></TD>
    <TD><FONT FACE="Helvetica,Verdana,Arial">$meg_location</FONT></TD>
    <TD><FONT FACE="Helvetica,Verdana,Arial">$meg_mapref</FONT></TD>
    <TD><FONT FACE="Helvetica,Verdana,Arial"><A HREF="/cgi-bin/megalithdemo/showtype.pl?id=$meg_site_type_id">$st_site_type</A></FONT></TD>
</TR>
EOF
  }

$dbh->disconnect;

### Write out the footer for the page
print <<EOF;
</TABLE>
<P>
<CENTER>
[ <A HREF="/cgi/megalithdemo/showallsites.pl">List All Sites</A> ] |
[ <A HREF="/cgi/megalithdemo/showmap.pl">Show UK Map</A> ]
</CENTER>
<!-- Footer -->
</TABLE>
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
