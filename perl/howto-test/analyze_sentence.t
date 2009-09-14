#!perl

use strict;
use warnings;

use Test::More tests => 5;

my @subs = qw( words count_words );

#BEGIN{
    use_ok( 'AnalyzeSentence', @subs, '$WORD_SEPARATOR' ) or exit;
#}

can_ok( __PACKAGE__, 'words'       );
can_ok( __PACKAGE__, 'count_words' );

my $sentence =
    'Queen Esther, ruler of the Frog-Human Alliance, briskly devours a
    monumental ice cream sundae in her honor.';

# Test
our $WORD_SEPARATOR = qr/(?:\s|-)+/;
my @words = words( $sentence );
ok( @words == 18, '... respecting $WORD_SEPARATOR, if set'  );

# Test
$sentence = 'Rampaging ideas flutter greedily.';
my $count = count_words( $sentence );
ok( $count == 4, 'count_words() should handle simple sentences' );
