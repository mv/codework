package AnalyzeSentence;

use strict;
use warnings;

use base 'Exporter';

our $WORD_SEPARATOR = qr/\s+/;
our @EXPORT_OK      = qw( $WORD_SEPARATOR count_words words );

sub words
{
    my $sentence = shift;
    return split( $WORD_SEPARATOR, $sentence );
}

sub count_words
{
    my $sentence = shift;
    return scalar words( $sentence );
}

1;
