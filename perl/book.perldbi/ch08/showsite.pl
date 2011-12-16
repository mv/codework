#!/usr/bin/perl -w
#
# ch07/showsite.pl: Shows the information about a given type of site
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
<TITLE>Megalith Site Information</TITLE>
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
Megalithic Site Information
</FONT>
</CENTER>
<P>
EOF

if ( $query->param( 'id' ) ) {

    my $site_id = $query->param( 'id' );

    ### Extract the site type information from the database and print it out...
    my $dbh = DBI->connect( $MegalithDB::DSN, $MegalithDB::USER, $MegalithDB::PASS, {
                LongReadLen => 2048
              } );

    my $sth = $dbh->prepare( "
                SELECT meg.id, meg.name, meg.description, meg.location,
                       meg.mapref, st.id, st.site_type
                FROM megaliths meg, site_types st
                WHERE meg.id = $site_id
                AND meg.site_type_id = st.id
              " );
    $sth->execute();

    while ( my ( $meg_id, $meg_name, $meg_description, $meg_location, 
              $meg_mapref, $st_id, $st_site_type ) = $sth->fetchrow_array ) {
#        $meg_mapref = DBI::neat( $meg_mapref );

        print <<EOF;
<TABLE BORDER=1 WIDTH="100%">
<TR><TD><FONT FACE="Helvetica,Verdana,Arial"><B>Site Name:</B></FONT></TD>
    <TD><FONT FACE="Helvetica,Verdana,Arial">$meg_name</FONT></TD>
</TR>
<TR><TD><FONT FACE="Helvetica,Verdana,Arial"><B>Location:</B></FONT></TD>
    <TD><FONT FACE="Helvetica,Verdana,Arial">$meg_location</FONT></TD>
</TR>
<TR><TD><FONT FACE="Helvetica,Verdana,Arial"><B>OS Grid Reference:</B></FONT></TD>
    <TD><FONT FACE="Helvetica,Verdana,Arial">$meg_mapref</FONT></TD>
</TR>
<TR><TD VALIGN=top><FONT FACE="Helvetica,Verdana,Arial"><B>Description:</B></FONT></TD>
    <TD><FONT FACE="Helvetica,Verdana,Arial">$meg_description</FONT></TD>
</TR>
<TR><TD><FONT FACE="Helvetica,Verdana,Arial"><B>Site Type:</B></FONT></TD>
    <TD><FONT FACE="Helvetica,Verdana,Arial"><A HREF="/cgi-bin/megalithdemo/showtype.pl?id=$st_id">$st_site_type</A></FONT></TD>
</TR>
</TABLE>
<P>
<HR WIDTH=60%>
<P>
<CENTER>
<FONT SIZE="+1"><B>Multimedia</B></FONT>
</CENTER>
<P>
<TABLE BORDER=0 WIDTH=100%>
<TR><TD COLSPAN=2>
EOF

        ### Now, extract the media for this site...
        my $mediasth = $dbh->prepare( "
                        SELECT med.id, med.description
                        FROM media med
                        WHERE med.megaliths_id = $site_id
                      " );
        $mediasth->execute();

        print <<EOF;
<TABLE BORDER=1 WIDTH=100%>
EOF

        while ( my ( $med_id, $med_description ) = $mediasth->fetchrow_array ) {
            print <<EOF;
<TR><TD VALIGN=top><FONT FACE="Helvetica,Verdana,Arial"><A HREF="/cgi/megalithdemo/showmedia.pl?id=$med_id">View media</A></FONT></TD>
    <TD><FONT FACE="Helvetica,Verdana,Arial">$med_description</A></FONT></TD>
</TR>
EOF
          }

        print <<EOF;
</TABLE>
EOF
      }

    print <<EOF;
</TD></TR>
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
