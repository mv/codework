#!/bin/perl

# Copyright 2001, Harold F. Skelly jr.

# To be done, 
#       - format the output to create a NetBackup includes file
#       - check that the number of streams created is <= number of streams
#         requested

# Add proper option parsing for -s chunksize -d startting dir

use File::Find;
use Getopt::Std;

$i=$j=0;

getopt('cdv');
# -c chunksize
# -d root
# -v verbose

$USAGE = "depth2 -c streamCount -d rootdir [-v]erbose \nWhere:\
    streamcount is the number of streams to divide the filessystem into and\
    rootdir is the mountpoint that must be split up.\n";

if (! $opt_c)  {print $USAGE; exit 1;}
else {$streamtotal = $opt_c;}

if ($opt_d) {$starting = $opt_d;}
else {$starting='.';}


if ($opt_h or $opt_x) {print $USAGE;}

# See perl module FILE ( pp 439,440 of 2nd Edition Programming Perl
finddepth(\&wanted, $starting);

print "Total size to divide up is $dirs{$starting}\n\n";

# Set the chunk size to be the total size of the directory tree (basically
# dirs{$starting} DIVIDED by the number of streams, $streamtotal

$chunksize = $dirs{$starting} / $streamtotal;

$streamct=1;

buildstreams( $starting);

&printstreams;

exit;


#===========================================================================

sub wanted {
        #Get current name of directory/file, w/o path
              # Note that this is the proto-ized function needed by 'finddepth' 
              # which is a depth first search 
        $filename = $_;

        #Get current directory name
        my $currdir = $File::Find::dir;

        #Get full pathname of currdir and file
        my $full = $File::Find::name;

        #If the current name is a directory
        if (-d $full) { 
                #Add size of it's own directory entry to this directory
                $dirs{$full}+= (stat $full)[7];
                    # we only need to skip when looking at 'myself'
                    # otherwise we end up doubling the total size
                return if ( $full eq $starting );

                #Add size of contents of this subdir to this directory
                $dirs{$currdir}+= $dirs{$full};
        }

        #If not a directory, add its size to directory total
        else { 
                $dirs{$currdir}+= -s $full ;
                }

}


#===========================================================================

sub bydepth {
        #find the one with the larger number of path elements
        split($SEP,$a) <=> split($SEP, $b);
}

#===========================================================================

sub printstreams {
        # print out streams and chunk sizes.  Ea. STREAM is a comma separated list
        #  of directories
        open (RSLTS,"> ./includes") || die "can open ./includes\n";
        print "Created the following streams of less than $chunksize size\n";
        for ($k=0; $k<$streamct; $k++)   {
                $STREAMS[$k] =~ s/,/\n/g;
                printf RSLTS "\nNEW_STREAM\n";
                print "\nNEW_STREAM\n" if $opt_v;
                printf RSLTS "$STREAMS[$k]\n";
                print "$STREAMS[$k]\n" if $opt_v;
                $STREAMS[$k] =~ s/\n/,/g;
                $sz = strmsize($STREAMS[$k]);
                print "\tSIZE=$sz\n" if $opt_v;
                $grandsum+=$sz;
                }
        close RSLTS;

        print "\nThe Grand total of all streams is $grandsum\n" if opt_v;
}



#===========================================================================

sub buildstreams {
        #  take a directory and return set of streams composed of 
        #  various subdirs. and files 

        #  look at ea. directory from the top down.  If the directory size 
        #  is LESS than chunksize, then include this (and thus all subdirs 
        #  and files) in the # backup stream.  If if is too large though, 
        #  then loop through all of the subdirs. down one level.

        my $indir = @_[0];
        my $i, $elem, $sz;
        my @allelems;
        my $streamlist;
        
        
        # check size of current dirname to see if it will fit in any existing 
        # stream and add it if so.
        for ($i=0; $i<$streamct; $i++) {
                if ( (strmsize($STREAMS[$i]) + $dirs{$indir}) < $chunksize ) {
                        $streamlist = $STREAMS[$i];
                        #$streamlist = $streamlist.",". $indir.$dirs{$indir};
                        $streamlist = $streamlist.",". $indir;
                        $STREAMS[$i] = $streamlist;
                        return;
                }
        }
        
        # We didn't find an existing stream large enough so either create
        # a new stream (if it will fit in one) or descend to new subdirs.
        if ( $dirs{$indir} < $chunksize ) {
                # Note here that $streamct is 1 greater than the index of the
                # the last element of $STREAMS
                $STREAMS[$streamct++] = $indir;
                return;
        }

        else {          
            #go down one level using opendir and readdir till done
            opendir THISDIR, $indir or die "couldn't open $indir to recurse\n";
            # get rid of . and .. and make all full path names 
            @allelems = map "$indir/$_", grep !/^\.\.?$/,  readdir THISDIR;
            close THISDIR;

            # run the following loop twice to look a subdirs first then files
            # second recursing on directories.
            foreach $elem (@allelems) {
                next if (-f $elem);
                        # else we recurse on each subdir
                        if  ( -d $elem ) {buildstreams($elem);}
                        }
            ELEM:
            foreach $elem (@allelems) {
                next if (-d $elem);    #we've already streamified dirs, right?
                $sz = -s $elem;
                if  ( -f $elem  || -l $elem) {
                    # add to a stream if it will fit, else build a new stream
                        for ($i=0; $i < $streamct; $i++) {
                            if ( (strmsize($STREAMS[$i]) + $sz) < $chunksize) {
                                    $streamlist = $STREAMS[$i];
                                    #$streamlist = $elem.$sz.",". $streamlist;
                                    $streamlist = $streamlist.",". $elem;
                                    $STREAMS[$i] = $streamlist;
                                    next ELEM;    #we've placed in a stream
                            }
                        }
                        if ( $sz < $chunksize) {
                                $STREAMS[$streamct++] = $elem;
                                next ELEM;
                        }
        else { die "single file $elem greater than $chunksize \
             (1/$streamtotal of the size of the root directory)\n";
                        }
                }
            }
        }
}

#===========================================================================

sub strmsize {
        # get a CSV string of dir names and add up the sizes
        my $sum;
        my $indir = @_[0];
        my @list;
        @list = split ',', $indir;
        foreach $elm (@list) { 
                if ( -f $elm ) { $sum+= -s $elm }
                else {$sum+=$dirs{$elm} } 
        }
        return $sum;
}
