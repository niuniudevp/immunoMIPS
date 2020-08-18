#!/usr/bin/perl
my $fh;
open ($fh,"<sortbams.txt") || die "cant";
while (<$fh>){
	s/[\r\n]//g;
	my $line = $_;
	my $pref = $line;
	$pref =~ s/.sort.bam//g;
	system ("macs2 callpeak -B -f BAMPE -t ./sortbams/$line -n ./macs-out/$pref -g mm --nomodel")
	#system ("macs2 callpeak -B --SPMR -f BAMPE -t ./sortbams/$line -n ./macs-out-SPMR/$pref -g mm --nomodel")
}
