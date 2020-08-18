#!/usr/bin/perl
my $fh;
open ($fh,"<sortbams.txt") || die "cant";
while (<$fh>){
	s/[\r\n]//g;
	my $line = $_;
	my $pref = $line;
	$pref =~ s/.bam//g;
	#my $fasta = "/ycga-gpfs/home/bioinfo/genomes/igenomes/Mus_musculus/Ensembl/GRCm38/Sequence/WholeGenomeFasta/genome.fa"; 
	my $fasta = "/gpfs/ycga/datasets/genomes/Mus_musculus/UCSC/mm10/Sequence/WholeGenomeFasta/genome.fa";	
	#system ("samtools mpileup -B -f ../nextera-lib-amplicons.fa $_ | java -jar VarScan.v2.3.9.jar mpileup2indel> $line.varscan.txt");
	system ("samtools calmd -@ 8 -b ./STAR-out-ucsc/$_ $fasta > ./STAR-out-ucsc/$pref.md.bam"); 
}
