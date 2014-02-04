#!/usr/bin/env perl
#go through a bunch of readdbs and tally up something

foreach my $dbfile ( @ARGV ) {
    # first do jobview
    foreach my $line ( `nodeview --nocolor --readdb=$dbfile --jobview --extended` ) {
        next unless $line =~ m/^\s*(\d+)\s+Running\s+(\d+):(\d+)\s+(\S+\s+){5}(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s*$/;
        #[1838553] [1] [8] [shared         ] [0.00] [0.02] [349.61] [18520.00] [] [] [] [] [] []
        my ($jobid, $nods, $ppn, $queue, $walltime, $cputime, $physmem, $vmem ) = ( $1, $2, $3, $4, $5, $6, $7, $8 );
        next if ($cputime / ($walltime+0.01) ) < 0.05;
        $memuse=$physmem/$nods;
        if ( $jobmem{$jobid} &&  $jobmem{$jobid} < $memuse ) {
            $jobmem{$jobid} = $memuse;
        }
        else {
            $jobmem{$jobid} = $memuse;
        }
    }

    # now the hard way
    my $mynod;
    foreach my $line ( `nodeview --nocolor --readdb=$dbfile -f` ) {
        if ( $line =~ m/^\s*(gcn|trestles)-\d+-\d+ \s*\d+ \s*\d+ \s*\d+ \s*\S+ \s*(\S+)G \s*(\S+)% \s*\S+/ ) {
            $mynod = $2 * $3 / 100.0 * 1024;
        }
        elsif ( $line =~ m/^\s*(\d+)\s+Running.*normal/ ) {
            $jobid = $1;
            if ( $jobmem{$jobid} && $jobmem{$jobid} < $mynod ) {
                print "ooh, I spy $jobid in $dbfile using $mynod MB of RAM (was formerly $jobmem{$jobid})\n";
                $jobmem{$jobid} = $mynod;
            }
        }
    }
}

my ( $over, $total ) = ( 0, 0 );
foreach my $jobid ( keys(%jobmem) ) {

    printf( "%10s %.2f\n", $jobid, $jobmem{$jobid} );
    if ( $jobmem{$jobid} > 32767.0 ) { $over++; }
    $total++;
}
printf("over: %d\n", $over);
printf( "total: %d\n", $total );
printf( "fraction of jobs using more than 32 GB of RAM: %.4f\n", $over/$total );
