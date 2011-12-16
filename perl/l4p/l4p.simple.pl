
=head1
Stealth loggers

Sometimes, people are lazy. If you're whipping up a 50-line script and
want the comfort of Log::Log4perl without having the burden of carrying
a separate log4perl.conf file or a 5-liner defining that you want to
append your log statements to a file, you can use the following fea-
tures:

=cut

use Log::Log4perl qw(:easy);
    Log::Log4perl->easy_init( { level    => $DEBUG,
                                file     => ">>test.log",
                                category => "Bar::Twix",
                                layout   => '%F{1}-%L-%M: %m%n'
                              }
                              { level    => $DEBUG,
                                file     => "STDOUT",
                                category => "Bar::Mars",
                                layout   => '%m%n'
                                },
                            );

DEBUG("Debug this!");
INFO("Info this!");
WARN("Warn this!");
ERROR("Error this!");

some_function();

sub some_function {
        # Same here
    FATAL("Fatal this!");
}

