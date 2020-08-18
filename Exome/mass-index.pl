#!/usr/bin/perl
my $fh;
open ($fh,"<unsortbams.txt") || die "cant";
while (<$fh>){
	s/[\r\n]//g;
	my $line = $_;
	my $file = $line;
	#$file =~ s/.bam/.sort.bam/g;
	my $pref = $file;
	my $in = $file;
	$in =~ s/.bam/.sort.bam/g;
	#my $fasta = "/ycga-ba/home/bioinfo/genomes/igenomes/Mus_musculus/UCSC/mm10/Sequence/WholeGenomeFasta/genome.fa";
	#system ("samtools mpileup -B -f ../nextera-lib-amplicons.fa $_ | java -jar VarScan.v2.3.9.jar mpileup2indel> $line.varscan.txt");
	#system ("samtools index -b ./sortbams/$in"); 
	print "samtools index -b ./sortbams/$in";
}
