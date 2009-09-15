#!/usr/bin/perl -wT
# who.cgi - run who(1) on a user and format the results nicely

$ENV{IFS}='';
$ENV{PATH}='/bin:/usr/bin';

use CGI qw(:standard);

# print search form
print header(), start_html("Query Users"), h1("Search");
print start_form(), p("Which user?", textfield("WHO")); submit(), end_form();

# print results of the query if we have someone to look for
$name = param("WHO");
if ($name) {
    print h1("Results");
    $html = '';
    
    # call who and build up text of response
    foreach (`who`) {
        next unless /^$name\s/o;            # only lines matching $name
        s/&/&amp;/g;                        # escape HTML
        s/</&lt;/g;
        s/>/&gt;/g;
        $html .= $_;
    }
    # nice message if we didn't find anyone by that name
    $html = $html || "$name is not logged in";
    
    print pre($html);
}

print end_html();
