#!/usr/bin/perl
my $fh;
open ($fh,"<sortbedgraphs.txt") || die "cant";
while (<$fh>){
	s/[\r\n]//g;
	my $line = $_;
	my $pref = $line;
	$pref =~ s/.sort.bdg//g;
	#$pref =~ s/_treat_pileup.bdg//g;
	#system("bedSort ./macs-out-SPMR/$line ./macs-out-SPMR/$pref.sort.bdg");
	system ("bedGraphToBigWig ./macs-out-SPMR/$line mm10.chrom.sizes ./bigWigs/$pref.bw")
	#system ("macs2 callpeak --broad -f BAMPE -t ./sortbams/$line -n ./macs-out-broad/$pref -g mm --nomodel"); 
}
