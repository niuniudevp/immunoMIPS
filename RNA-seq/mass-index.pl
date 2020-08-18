#!/usr/bin/perl
my $fh;
open ($fh,"<mdbams.txt") || die "cant";
while (<$fh>){
	s/[\r\n]//g;
	my $line = $_;
	my $pref = $line;
	$pref =~ s/.bam//g;
	#my $fasta = "/ycga-ba/home/bioinfo/genomes/igenomes/Mus_musculus/UCSC/mm10/Sequence/WholeGenomeFasta/genome.fa";
	#system ("samtools mpileup -B -f ../nextera-lib-amplicons.fa $_ | java -jar VarScan.v2.3.9.jar mpileup2indel> $line.varscan.txt");
	system ("samtools index -@ 20 -b ./STAR-out-ucsc/$_"); 
}
