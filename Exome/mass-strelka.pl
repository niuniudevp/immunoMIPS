#!/usr/bin/perl
my $fh;
open ($fh,"<sortbams.txt") || die "cant";
while (<$fh>){
	s/[\r\n]//g;
	my $line = $_;
	my @lines = split ("\t",$line);
	my $pref = $line;
	$pref =~ s/.sort.bam//g;
	my $fadir = "/ycga-gpfs/home/bioinfo/genomes/igenomes/Mus_musculus/UCSC/mm10/Sequence/WholeGenomeFasta/genome.fa";
	#run Manta
	system("mkdir ./manta-out/$pref");
	system("manta-1.5.0.centos6_x86_64/bin/configManta.py --exome --normalBam ./sortbams/B6-Liver.sort.bam --tumorBam ./sortbams/$line --referenceFasta $fadir --runDir ./manta-out/$pref/");
	system("./manta-out/$pref/runWorkflow.py -m local -j 8");
	system("mkdir ./strelka-out/$pref");
	system("strelka-2.9.2.centos6_x86_64/bin/configureStrelkaSomaticWorkflow.py --exome --normalBam ./sortbams/B6-Liver.sort.bam --tumorBam ./sortbams/$line --referenceFasta $fadir --indelCandidates ./manta-out/$pref/results/variants/candidateSmallIndels.vcf.gz --runDir ./strelka-out/$pref/");
	system("./strelka-out/$pref/runWorkflow.py -m local -j 8"); 
}
