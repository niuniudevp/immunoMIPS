#!/usr/bin/perl
my @matfiles;
use strict;
use warnings;
my $fh;

my %immunecells;
open ($fh,"<wanted-celltypes.txt") || die "no";
while (<$fh>){
	s/[\r\n]//g;
	$immunecells{$_} = 1;
}
close $fh;

my $vars;
my @variables;
my @snoCols;
open ($fh,"<matfiles.txt") || die "cant";
while (<$fh>){
	s/[\r\n]//g;
	my $line = $_;
	#if ($line !~ /GBM/){
		push (@matfiles,$line);
	#}
}
close $fh;

my %mathash;
my @wantcols;
my $counter = 0; 
foreach my $f (@matfiles){
	open ($fh,"<./spearman/$f") || die "cant";
	my $name = $f;
	$name =~ s/.KMT2D.tpm.xcell.txtcorMat.txt//g;
	$vars = <$fh>;
	$vars =~ s/[\r\n]//g;
	@variables = split ("\t",$vars);
#variables is one short
	if ($counter == 0){
		for (my $i = 0; $i < scalar @variables; $i++){
			if ($variables[$i] !~ /KMT2D/ && defined $immunecells{$variables[$i]}){
				push (@snoCols,$i+1);
			}
		}
		$counter++;
	}
	while (<$fh>){
		s/[\r\n]//g;
		my $line = $_;
		my @lines = split ("\t",$line);
		my $variable = $lines[0];
		my @wantdata;
		#if ($variable eq "CD4+ T-cells"){
			foreach my $i (@snoCols){
				push(@wantdata,$lines[$i]);
			}
			$mathash{$name} = [@wantdata];
		#}
		#elsif ($variable eq "PRF1"){
		#	foreach my $i (@snoCols){
		#		push(@wantdata,$lines[$i]);
		#	}
		#	my @temp = @{$mathash{$name}};
		#	my @newvals = (@temp+@wantdata)/2;
		#	$mathash{$name} = [@newvals];
		#}
		
	}
	close $fh;
}

##get variables into an array



my @pvalfiles;
open ($fh,"<pval-files.txt") || die "cant";
while (<$fh>){
	s/[\r\n]//g;
	my $line = $_;
	#if ($line !~ /GBM/){
		push (@pvalfiles,$line);
	#}
}
close $fh;
my %pvalhash;

foreach my $f (@pvalfiles){
	open ($fh,"<./spearman/$f") || die "cant";
	my $name = $f;
	$name =~ s/.KMT2D.tpm.xcell.txtcorPval.txt//g;
	<$fh>;
	while (<$fh>){
		s/[\r\n]//g;
		my $line = $_;
		my @lines = split ("\t",$line);
		my $variable = $lines[0];
		my @wantdata;
		#if ($variable eq "CD4+ T-cells"){
			foreach my $i (@snoCols){
				push(@wantdata,$lines[$i]);
			}
			$pvalhash{$name} = [@wantdata];
		#}
		
	}
	close $fh;	
}	

my $ofh;
open ($ofh,">merged-corMat.KMT2D.txt") || die "no";
print $ofh "Type";
foreach my $i (@snoCols){
	print $ofh "\t",$variables[$i-1];
}
print $ofh "\n";

foreach my $k (sort keys %mathash){
	print $ofh "$k";
	my @matdata = @{$mathash{$k}};
	for (my $i = 0; $i < scalar @matdata; $i++){
		print $ofh "\t$matdata[$i]";
	}
	print $ofh "\n";
}
close $ofh;

open ($ofh,">merged-corPval.KMT2D.txt") || die "no";
print $ofh "Type";
foreach my $i (@snoCols){
	print $ofh "\t",$variables[$i-1];
}
print $ofh "\n";

foreach my $k (sort keys %pvalhash){
	print $ofh "$k";
	my @pvaldata = @{$pvalhash{$k}};
	for (my $i = 0; $i < scalar @pvaldata; $i++){
		print $ofh "\t$pvaldata[$i]";
	}
	print $ofh "\n";
}
close $ofh;






