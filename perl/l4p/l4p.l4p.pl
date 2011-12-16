# use Log::Log4perl qw(:resurrect :easy);

###l4p Log::Log4perl->easy_init($DEBUG);
###l4p DEBUG "It works!";
# ...
###l4p INFO "Really!";

set PERL5OPT=-MLog::Log4perl=:resurrect,:easy
export PERL5OPT
