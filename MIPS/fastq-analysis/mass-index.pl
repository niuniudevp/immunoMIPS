#!/usr/bin/perl
my $fh;
open ($fh,"<intersectbams.txt") || die "cant"; #list of intersected bam files
while (<$fh>){
	s/[\r\n]//g;
	my $line = $_;
	my $pref = $line;
	$pref =~ s/.bam//g;
	system ("samtools index -b ./intersectbams/$_"); 
}
