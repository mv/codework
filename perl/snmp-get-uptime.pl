;
use SNMP_Session;

# Return the uptime of the localhost to test SNMP$host = "localhost";

$community = "public";
$oid = encode_oid(1,3,6,1,2,1,1,3,0); # Uptime
    
$session = SNMP_Session->open ($host, $community, 161)    || die "Can't open SNMP session to localhost";

$session->get_request_response ($oid);
         ($bindings) = $session->decode_get_response ($session->{pdu_buffer});
($binding,$bindings) = &decode_sequence ($bindings);
       ($oid,$value) = &decode_by_template ($binding, "%O%@");

print &pretty_print($oid)," => ", &pretty_print ($value), "\n";


