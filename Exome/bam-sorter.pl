#!/usr/bin/perl
my $fh;
open ($fh,"<unsortbams.txt") || die "cant";
while (<$fh>){
	s/[\r\n]//g;
	my $line = $_;
	my @lines = split ("\t",$line);
	my $pref = $line;
	$pref =~ s/.bam//g;
	system("samtools sort -m 6G -@ 6 -o ./sortbams/$pref.sort.bam ./unsortbams/$line");
}
