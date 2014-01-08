#!/usr/bin/env perl
#
#  script to go through PBS logs and count up the number of jobs which ended
#  with good exit codes (=0), bad exit codes (>0), and ugly exit codes (<0)
#

use strict;
use warnings;

my @keys = qw{ good bad ugly g_skip b_skip u_skip };
my $overall;

print "     \t";
foreach my $key ( @keys )
{
    $overall->{$key} = 0 foreach @keys;
    print "\t$key";
}
print "\ttot\n";

foreach my $logfile ( @ARGV )
{
    open LOGF, "<$logfile" or next;
    my $counts;
    $counts->{$_} = 0 foreach @keys;

    while ( my $line = <LOGF> )
    {
        my $key;
        next unless $line =~ m/Exit_status=(-?\d+)/;
        my $exit_status = $1;
        my $wall = 0;
        if ( $line =~ m/resources_used.walltime=(\d+):(\d+):(\d+)/ ) { 
            $wall = $1*3600 + $2*60 + $3;
        }

        if ( $wall < 10 ) {
            if    ( $exit_status < 0 ) { $key = "u_skip"; }
            elsif ( $exit_status > 0 ) { $key = "g_skip"; }
            else  { $key = "b_skip"; }
        }
        else {
            if    ( $exit_status == 0 ) { $key = "good"; }
            elsif ( $exit_status  > 0 ) { $key = "bad"; }
            else { $key = "ugly"; }
        }
        $counts->{$key}++;
    }

    my $id = $logfile;
    $id = "$2/$3/$1" if $logfile =~ m/^(\d{4})(\d{2})(\d{2})$/;

    print "$id";
    foreach my $key ( @keys )
    {
        printf( "\t%d", $counts->{$key});
        $overall->{$key} += $counts->{$key};
        $counts->{tot} += $counts->{$key};

    }
    printf( "\t%d\n", $counts->{tot} );;

}

print "   Total";
foreach my $key ( @keys )
{
    printf( "\t%d", $overall->{$key} );
    $overall->{tot} += $overall->{$key};
}
printf( "\t%d\n", $overall->{tot} );

