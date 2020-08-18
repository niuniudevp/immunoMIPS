#!/usr/bin/perl
use strict;
use warnings;
my $fh;

my @files;
my %poshash;
my %neghash;
my %annot;

open ($fh,"<htseq-gene-names-translated.txt") || die "no";
<$fh>;
while (<$fh>){	
	s/[\r\n]//g;
	s/"//g;
	my $line = $_;
	my @lines = split ("\t",$line);
	if (defined $lines[1]){
		$annot{$lines[0]} = $lines[1];
	}
	else {
		$annot{$lines[0]} = "NA";
	}
}
close $fh;

open ($fh,"<correlfiles.txt") || die "no";
while (<$fh>){	
	s/[\r\n]//g;
	push (@files,$_);
}
close $fh;
my %posct;
my %negct;
foreach my $f (@files){
	my $type = $f;
	$type =~ s/.KMT2D.correl.txt//g;
	open ($fh,"<./Spearman-correl/$f") || die "d";
	<$fh>;
	while (<$fh>){
		s/[\r\n]//g;
		s/"//g;
		my $line = $_;
		my @lines = split ("\t",$line);
		my $gene = $lines[0];
		my $corr = $lines[1];
		my $pval = $lines[2];
		my $adjp = $lines[3];
		
		if ($adjp < 0.05){
			if ($corr > 0){
				if (!defined $poshash{$gene}){
					$poshash{$gene} = $type;
					$posct{$gene} = 1;
				}
				else {
					$poshash{$gene} .=" $type";
					$posct{$gene}++;
				}
			}
			elsif ($corr < 0){ 
				if (!defined $neghash{$gene}){
					$neghash{$gene} = $type;
					$negct{$gene} = 1;
				}
				else {
					$neghash{$gene} .=" $type";
					$negct{$gene}++;
				}
			}
		}
	}
	close $fh;
}
my $ofh;

open ($ofh,">merged-KMT2D-positive-correl.txt") || die "n";
print $ofh "ENSG\tGene\tNumTypesSig\tTypes\n";
foreach my $k (sort {$posct{$b} <=> $posct{$a}} keys %posct){
	if ($k ne "KMT2D"){
		print $ofh "$k\t$annot{$k}\t$posct{$k}\t$poshash{$k}\n";
	}
}
close $ofh;	

open ($ofh,">merged-KMT2D-negative-correl.txt") || die "n";
print $ofh "ENSG\tGene\tNumTypesSig\tTypes\n";
foreach my $k (sort {$negct{$b} <=> $negct{$a}} keys %negct){
	print $ofh "$k\t$annot{$k}\t$negct{$k}\t$neghash{$k}\n";
}
close $ofh;
