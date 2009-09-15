#!/usr/bin/perl -w
#
# ch02/DBM/Megalith.pm: A perl class encapsulating a megalith

package Megalith;

use strict;
use Carp;

### Creates a new megalith object and initializes the member fields.
sub new {
    my $class = shift;
    my ( $name, $location, $mapref, $type, $description ) = @_;
    my $self = {};
    bless $self => $class;

    ### If we only have one argument, assume we have a string
    ### containing all the field values in $name and unpack it
    if ( @_ == 1 ) {
        $self->unpack( $name );
    }
    else {
        $self->{name} = $name;
        $self->{location} = $location;
        $self->{mapref} = $mapref;
        $self->{type} = $type;
        $self->{description} = $description;
    }
    return $self;
}

### Packs the current field values into a colon delimited record
### and returns it
sub pack {
    my ( $self ) = @_;

    my $record = join( ':', $self->{name}, $self->{location},
                            $self->{mapref}, $self->{type},
                            $self->{description} );

    ### Simple check that fields don't contain any colons
    croak "Record field contains ':' delimiter character"
        if $record =~ tr/:/:/ != 4;

    return $record;
}

### Unpacks the given string into the member fields
sub unpack {
    my ( $self, $packedString ) = @_;

    ### Naive split...Assumes no inter-field delimiters
    my ( $name, $location, $mapref, $type, $description ) =
        split( ':', $packedString, 5 );

    $self->{name} = $name;
    $self->{location} = $location;
    $self->{mapref} = $mapref;
    $self->{type} = $type;
    $self->{description} = $description;
}

### Displays the megalith data
sub dump {
    my ( $self ) = @_;

    print "$self->{name} ( $self->{type} )\n", 
          "=" x ( length( $self->{name} ) + 
                  length( $self->{type} ) + 5 ), "\n";
    print "Location:      $self->{location}\n"; 
    print "Map Reference: $self->{mapref}\n";
    print "Description:   $self->{description}\n\n";
}

1;
