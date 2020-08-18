#!/usr/bin/perl
use strict;
use warnings;
# splits the kmt2d tpm data into the individual cancer types
my $fh;

open ($fh,"<../RNA/RNAseq-cases.txt") || die "cant";
my %info;
my %tissues;
<$fh>;
while (<$fh>){
	s/[\r\n]//g;
	s/"//g;
	my $line = $_;
	my @lines = split ("\t",$line);
	my $id = $lines[3];
	$id =~ s/-/./g;
	my $organ = $lines[0];
	$organ =~ s/TCGA-//g;
	$info{$id} = $organ;
	if (!defined $tissues {$organ}){
		$tissues{$organ} = 1;
	}
}
close $fh;

my $ofh;

foreach my $t (keys %tissues){
	open ($fh,"<KMT2D-XCell-merge.txt") || die "cant";
	open ($ofh,">./KMT2D-Xcell-types/$t.KMT2D.tpm.xcell.txt") || die "cant";
	my $head = <$fh>;
	$head =~ s/[\r\n]//g;
	$head =~ s/"//g;
	my @headers = split ("\t",$head);
	my @wantcols;
	for (my $i = 1; $i < scalar @headers; $i++){
		my $id = $headers[$i];
		my @blah=split("\Q.",$id);
		$id = "$blah[0].$blah[1].$blah[2]";
#print $id,"\n";
		my $organ = $info{$id};
		
		if ($organ eq $t){
			push (@wantcols,$i);
		}
		
	}
	print $ofh "gene";
	
	foreach my $i (@wantcols){
		print $ofh "\t$headers[$i]";	
	}
	print $ofh "\n";
	
	while (<$fh>){
		s/[\r\n]//g;
		my $line = $_;
		my @lines = split ("\t",$line);
		print $ofh $lines[0];
		
		foreach my $i (@wantcols){
			print $ofh "\t$lines[$i]";
		}
		print $ofh "\n";
	}
}
		
		
	
