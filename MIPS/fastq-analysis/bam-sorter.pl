#!/usr/bin/perl
my $fh;
open ($fh,"<bamlist.txt") || die "cant"; # list of bam files
while (<$fh>){
	s/[\r\n]//g;
	my $line = $_;
	my @lines = split ("\t",$line);
	my $pref = $line;
	$pref =~ s/.bam//g;
	system("samtools sort -m 8G -@ 8 -o ./sortbams/$line.sort.bam ./unsortbams/$line");
}
