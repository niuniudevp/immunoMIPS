#!/usr/bin/perl
my $fh;
open ($fh,"<sortbams.txt") || die "cant";
while (<$fh>){
	s/[\r\n]//g;
	my $line = $_;
	my $pref = $line;
	$pref =~ s/.bam//g;
	#my $fasta = "/ycga-ba/home/bioinfo/genomes/igenomes/Mus_musculus/UCSC/mm10/Sequence/WholeGenomeFasta/genome.fa";
	#system ("samtools mpileup -B -f ../nextera-lib-amplicons.fa $_ | java -jar VarScan.v2.3.9.jar mpileup2indel> $line.varscan.txt");
	system("samtools sort -m 8G -@ 12 ./sortbams/$line -o $pref.coord.bam");
	#system ("samtools index -b ./sortbams/$_"); 
}
