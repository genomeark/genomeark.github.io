#!/usr/bin/perl

use strict;
use Time::Local;

#  Find seqrequester.
my $seqrequester = "./seqrequester/build/bin/seqrequester";

die "Didn't find seqrequester in '$seqrequester'.\n"   if (! -e $seqrequester);


#  If set to 0, do not download any genomic_data for coverage estimation.
my $downloadRAW = 1;
my $downloadASM = 1;

#  Thresholds for declaring contigs and scaffolds good or bad.
my $goodCTG = 1000000;
my $goodSCF = 10000000;

#  In memory cache of files in genomeark.
my @genomeArkEpoch;
my @genomeArkSizes;
my @genomeArkFiles;
my $genomeArkLength;

#  In memory cache of files in genomeark, filtered to the current species.
my @speciesEpoch;
my @speciesSizes;
my @speciesFiles;
my $speciesLength;

my %ccsPrefixes;

#  List of files we didn't know how to process
my @potentialErrors;
my @unknownFiles;

#
#  Discover species.
#

sub discoverDir ($) {
    my $dir = shift @_;
    my @speciesList;

    open(LS, "ls $dir/*.* |");
    while (<LS>) {
        chomp;

        if (m!genomeark/(\w+).md$!)   { push@speciesList, $1; }   #  For things in ../_genomeark/
        if (m!species/(\w+).yaml$!)   { push@speciesList, $1; }   #  For things in vgp-metadata/species/
    }
    close(LS);

    return(@speciesList);
}

sub discover (@) {
    my @species;

    if (scalar(@_) > 0) {
        @species = @_;
    }

    else {
        @species = (discoverDir("vgp-metadata/species"));
        #@species = (discoverDir("../_genomeark"));
    }

    print "Found ", scalar(@species), " species.\n";

    return(@species);
}


sub loadGenomeArk () {

    #  If no vgp-metadata directory, clone it.

    if (! -e "vgp-metadata") {
        print "FETCHING METADATA.\n";
        system("git clone git\@github.com:VGP/vgp-metadata.git");
    }

    #  If no genomeark.ls file list, fetch it AND update metadata.

    if (0) {
        print "UPDATING METADATA.\n";
        system("cd vgp-metadata ; git fetch ; git merge");
    }

    if (! -e "genomeark.ls.raw") {
        print "FETCHING AWS FILE LIST.\n";
        system("aws --no-sign-request s3 ls --recursive s3://genomeark/ > genomeark.ls.raw");
    }

    #  Pull in all the good bits from the file list, strip out the bad bits.

    if ((-e "genomeark.ls.raw") && (! -e "genomeark.ls")) {
        print "FILTERING AWS FILE LIST.\n";

        open(LSI, "< genomeark.ls.raw");
        open(LSO, "> genomeark.ls");

        while (<LSI>) {
            chomp;

            my ($filedate, $filetime, $filesize, $filename, $filesecs) = split '\s+', $_;

            my @fileComps   = split '/', $filename;
            my $speciesName = $fileComps[1];
            my $asmName     = $fileComps[3];
            my $seconds     = 0;

            next if ($filename =~ m!/$!);          #  Why are you giving me directories?

            next if ($filename =~ m!^working!);
            next if ($filename =~ m!^galaxy!);

            next if ($filename =~ m!.DS_Store$!);

            next if ($filename =~ m!.sh$!);

            next if ($filename =~ m!.log$!);
            next if ($filename =~ m!.log.gz$!);

            next if ($filename =~ m!mother$!);
            next if ($filename =~ m!father$!);

            next if ($filename =~ m!.md5$!);
            next if ($filename =~ m!md5sum!);

            next if ($filename =~ m!readme!i);
            next if ($filename =~ m!readme.txt!i);
            next if ($filename =~ m!report.txt!i);
            next if ($filename =~ m!version.txt!i);

            next if ($filename =~ m!summary!i);
            next if ($filename =~ m!summary.txt!i);

            next if ($filename =~ m!manifest.txt!i);

            next if ($filename =~ m!upload_report!i);

            next if ($filename =~ m!.pdf$!);

            next if ($filename =~ m!.csv$!);
            next if ($filename =~ m!.csv.gz$!);

            next if ($filename =~ m!.tsv$!);
            next if ($filename =~ m!.tsv.gz$!);

            next if ($filename =~ m!.zip$!);

            next if ($filename =~ m!.gff3$!);
            next if ($filename =~ m!.gff3.gz$!);

            next if ($filename =~ m!.yaml$!);

            next if ($filename =~ m!.tar$!);
            next if ($filename =~ m!.tar.gz$!);

            next if ($filename =~ m!/intermediate!i);
            next if ($filename =~ m!/Intermidiates!i);           #  One guy has this.

            next if ($filename =~ m!/Stats!);

            next if ($filename =~ m!/troubleshooting!i);
            next if ($filename =~ m!/annotation!i);
            next if ($filename =~ m!/test!i);
            next if ($filename =~ m!/analyses!i);
            next if ($filename =~ m!/comparative_analyses!i);

            next if ($filename =~ m!/busco!i);
            next if ($filename =~ m!/merfin!i);

            next if ($filename =~ m!/transcriptomic_data!i);
            next if ($filename =~ m!/evaluation!i);
            next if ($filename =~ m!/bam_to_fasta!i);            #  fAngAng1/assembly_vgp_standard_1.6/bam_to_fasta (and others)
            next if ($filename =~ m!additional_haplotigs!);

            next if ($filename =~ m!aligned.genomecov!);

            next if ($filename =~ m!/qc/logs!i);
            next if ($filename =~ m!/qc/mash!i);
            next if ($filename =~ m!/qc/meryl!i);
            next if ($filename =~ m!/qc/stats!i);
            next if ($filename =~ m!/qc/busco!i);
            next if ($filename =~ m!/qc/asm-stats!i);
            next if ($filename =~ m!/qc/genomescope!i);
            next if ($filename =~ m!/genomescope!i);
            next if ($filename =~ m!/meryl_genomescope!i);
            next if ($filename =~ m!/katplot!i);
            next if ($filename =~ m!mercury!i);

            next if ($filename =~ m!/assembly_v0/!);

            next if ($filename =~ m!bwgenome!i);

            next if ($filename =~ m!/aBomBom1/genomic_data/bionano/exp_refineFinal1/!);
            next if ($filename =~ m!/aBomBom1/genomic_data/pacbio/fasta!);
            next if ($filename =~ m!/bBucAby1/Test!);
            next if ($filename =~ m!/bCalAnn1/genomic_data/nanopore.*clean.fastq.gz!);
            next if ($filename =~ m!/bGeoTri1/genomic_data/pacbio/old/!);
            next if ($filename =~ m!/fAloSap1/vgp_assembly_2.0/evaluation!);
            next if ($filename =~ m!/fAngAng1/assembly_vgp_standard_1.6/Scaffolding!);
            next if ($filename =~ m!/mCalJac1/SDA/!);
            next if ($filename =~ m!/mZalCal1/assembly_rockefeller_1.6/longranger!);
            next if ($filename =~ m!/rCheMyd1/assembly_vgp_standard_1.6/evaluation!);    #  LOTS of BUSCO intermediates
            next if ($filename =~ m!/sCarCar1/rawData/!);
            next if ($filename =~ m!/bHirRus1/Hirundo/!);
            next if ($filename =~ m!/mCalJac1/chrY/!);
            next if ($filename =~ m!/bSylAtr1/bSylAtr1_s4.arrow!);
            next if ($filename =~ m!/bTaeGut1/assembly_mt_milan/temp!);
            next if ($filename =~ m!/sCarCar1/assemblies/white_shark_09Feb2016_V8sgr!);

            #  Random single files (some included above)

            next if ($filename eq "species/Alosa_sapidissima/fAloSap1/vgp_assembly/fAloSap1.pri.v0.fasta.gz");
            next if ($filename eq "species/Bos_taurus/mBosTau1/assembly_adelaide/bionano_joyce/mBosTau1_mat_Saphyr_DLE1.bnx.gz");
            next if ($filename eq "species/Bos_taurus/mBosTau1/assembly_adelaide/bionano_joyce/mBosTau1_mat_Saphyr_DLE1_nonhap_ES_sdb_m3.cmap.gz");
            next if ($filename eq "species/Callithrix_jacchus/mCalJac1/assembly_nhgri_rockefeller_trio_1.6/pretext/mCalJac1.mat.bam");
            next if ($filename eq "species/Callithrix_jacchus/mCalJac1/assembly_nhgri_rockefeller_trio_1.6/pretext/mCalJac1.pat.bam");
            next if ($filename eq "species/Callithrix_jacchus/mCalJac1/qc/mCalJac1.k21.hist");
            next if ($filename eq "species/Carcharodon_carcharias/sCarCar1/assemblies/bams_chicago/chicagoLibrary1.final.scaffolds.snap.md.sorted.bam");
            next if ($filename eq "species/Carcharodon_carcharias/sCarCar1/assemblies/gapfilled_assembly/jelly.out.fasta");
            next if ($filename eq "species/Carcharodon_carcharias/sCarCar2/assembly_vgp_standard_1.6/sCarCar2_pri.asm.20200727.fasta.gz");
            next if ($filename eq "species/Cariama_cristata/bCarCri1/purge_haplotigs/curated.artefacts.fasta.gz");
            next if ($filename eq "species/Chiroxiphia_lanceolata/bChiLan1/assembly_ru_canu_2.1/bChiLan1.contigs.fasta.gz");
            next if ($filename eq "species/Chiroxiphia_lanceolata/bChiLan1/assembly_ru_canu_2.1/bChiLan1.correctedReads.fasta.gz");
            next if ($filename eq "species/Chiroxiphia_lanceolata/bChiLan1/assembly_ru_canu_2.1/bChiLan1.unassembled.fasta.gz");
            next if ($filename eq "species/Choloepus_didactylus/mChoDid1/assembly_berlinSanger_vgp_1.6/mChoDid1.mito.fa.gz");
            next if ($filename eq "species/Choloepus_didactylus/mChoDid1/assembly_berlin_vgp_1.5/VGP1.5.mChoDid1.berlin.txt");
            next if ($filename eq "species/Corvus_hawaiiensis/bCorHaw1/assembly_vgp_standard_2.0/Export");
            next if ($filename eq "species/Falco_rusticolus/bFalRus1/assembly/bFalRus1.pri.asm.20200215.pretext");
            next if ($filename eq "species/Falco_rusticolus/bFalRus1/assembly/bFalRus1.pri.asm.20200401.pretext");
            next if ($filename eq "species/Melopsittacus_undulatus/bMelUnd1/pat_contigs_less20.fasta.gz");
            next if ($filename eq "species/Melopsittacus_undulatus/bMelUnd1/pat_contigs_over20.fasta.gz");
            next if ($filename eq "species/Nyctibius_grandis/bNycGra1/bNycGra1_c2p2.fasta.gz");
            next if ($filename eq "species/Pristis_pectinata/sPriPec2/assembly_vgp_standard_1.5/sPriPec2.pri.untrimmed.asm.20190802.fasta.gz");
            next if ($filename eq "species/Taeniopygia_guttata/bTaeGut1/bTaeGut1_s3q2.qv");
            next if ($filename eq "species/Zalophus_californianus/mZalCal1/assembly_rockefeller_1.6/mZalCal1_u1.fasta.gz");
            next if ($filename eq "species/Zalophus_californianus/mZalCal1/assembly_rockefeller_1.6/mZalCal1_u2.fasta.gz");

            #  These look like obsolete drafts.

            next if ($filename eq "species/Balaenoptera_musculus/mBalMus1/assembly_RU_repolished/mBalMus1.alt.cur.20200528.fasta");
            next if ($filename eq "species/Balaenoptera_musculus/mBalMus1/assembly_RU_repolished/mBalMus1.pri.cur.20200528.fasta");

            next if ($filename eq "species/Bos_taurus/mBosTau1/assembly_curated/mBosTau1.mat.alt.cur.20200213.fasta.gz");
            next if ($filename eq "species/Bos_taurus/mBosTau1/assembly_curated/mBosTau1.pat.alt.cur.20200213.fasta.gz");

            next if ($filename eq "species/Callithrix_jacchus/mCalJac1/assembly_nhgri_rockefeller_trio_1.6/VGP_mCalJac1_pat_X.fa.gz");

            next if ($filename eq "species/Corvus_hawaiiensis/bCorHaw1/assembly_vgp_standard_2.0/bCorHaw1.alt.asm.20212707.fasta");
            next if ($filename eq "species/Corvus_hawaiiensis/bCorHaw1/assembly_vgp_standard_2.0/bCorHaw1.pri.asm.20212907.fasta");

            next if ($filename eq "species/Falco_rusticolus/bFalRus1/assembly/bFalRus1.alt.asm.20200215.fasta");
            next if ($filename eq "species/Falco_rusticolus/bFalRus1/assembly/bFalRus1.alt.asm.20200401.fasta");
            next if ($filename eq "species/Falco_rusticolus/bFalRus1/assembly/bFalRus1.pri.asm.20200215.fasta");
            next if ($filename eq "species/Falco_rusticolus/bFalRus1/assembly/bFalRus1.pri.asm.20200401.fasta");

            next if ($filename eq "species/Pogoniulus_pusillus/bPogPus1/bPogPus1.alt.asm.20200207.fasta.gz");
            next if ($filename eq "species/Pogoniulus_pusillus/bPogPus1/bPogPus1.pri.asm.20200207.fasta.gz");

            next if ($filename eq "species/Scatophagus_argus/fScaArg1/assembly_vgp_standard_1.7/fScaArg1.alt.20210531.fa.gz");
            next if ($filename eq "species/Scatophagus_argus/fScaArg1/assembly_vgp_standard_1.7/fScaArg1.pri.20210531.fa.gz");

            next if ($filename eq "species/Sebastes_umbrosus/fSebUmb1/assembly_vgp_standard_1.6/fSebUmb1-t3.alt.asm.20200701.fasta.gz");
            next if ($filename eq "species/Sebastes_umbrosus/fSebUmb1/assembly_vgp_standard_1.6/fSebUmb1-t3.pri.asm.20200701.fasta.gz");

            #  A file we want to process!

            print LSO "$_\n";
        }

        close(LSO);
        close(LSI);
    }

    print "LOADING AWS FILE LIST.\n";

    open(LSI, "< genomeark.ls");
    while (<LSI>) {
        chomp;

        my ($filedate, $filetime, $filesize, $filename, $filesecs) = split '\s+', $_;

        my @fileComps   = split '/', $filename;
        my $speciesName = $fileComps[1];
        my $asmName     = $fileComps[3];
        my $seconds     = 0;

        if ("$filedate $filetime" =~ m/(\d\d\d\d)-(\d\d)-(\d\d)\s+(\d\d):(\d\d):(\d\d)/) {
            my ($yr, $mo, $da, $hr, $mn, $sc) = ($1, $2, $3, $4, $5, $6);

            $filesecs = timelocal($sc, $mn, $hr, $da, $mo-1, $yr); 
        } else {
            die "Failed to parse date ('$filedate') and time ('$filetime') for file '$filename'\n";
        }

        push @genomeArkEpoch, $filesecs;
        push @genomeArkSizes, $filesize;
        push @genomeArkFiles, $filename;

        $genomeArkLength++;
    }
    close(LSI);

    #  Fail if either doesn't exist.

    die "ERROR: 'genomeark.ls' doesn't exist, can't update.\n"   if (! -e "genomeark.ls");
    die "ERROR: 'vgp-metadata' doesn't exist, can't update.\n"   if (! -e "vgp-metadata");

    #  Return the time since epoch for the last change to genomeark.ls.

    return((stat("genomeark.ls"))[9]);
}



#  Return true/false if the filename looks like it's an assembly we should be reporting on.

sub isAssemblyFile ($$) {
    my $filename   = shift @_;
    my $ignoreMito = shift @_;

    return(0)   if ($filename =~ m!genomic_data!);
    return(0)   if ($filename !~ m!fasta.gz!);

    return(0)   if ($filename =~ m!additional_haplotigs!);

    return(0)   if ($filename =~ m!assembly_v0!);
    return(0)   if ($filename =~ m!bwgenome_!);
    return(0)   if ($filename =~ m!concatenated-!);

    return(0)   if (($filename !~ m![/_]assembly[/_]!));

    my $isMito = (($filename =~ m!species/(.*)/.*/(.*assembly.*)/(.......)(\d).MT.(\d\d\d\d)(\d\d)(\d\d).fasta.gz!i) ||
                  ($filename =~ m!species/(.*)/.*/(.*assembly.*)/(.......)(\d).\w+.\w+.(\d\d\d\d)(\d\d)(\d\d).MT.fasta.gz!i));

    my $isGeno = (($filename !~ m![\._]pri.*\.\d{8}.fasta.gz!) ||
                  ($filename !~ m![\._]alt.*\.\d{8}.fasta.gz!) ||
                  ($filename !~ m![\._]pat.*\.\d{8}.fasta.gz!) ||
                  ($filename !~ m![\._]mat.*\.\d{8}.fasta.gz!));

    return(0)   if ($isMito == 0) && ($isGeno == 0);
    return(0)   if ($isMito == 1) && ($ignoreMito == 1);

    return(1);
}

#
#  Load a mapping from assembly to genbank.
#

sub loadGenbank () {
    my %map;

    open(GB, "< genbank.map");
    while (<GB>) {
        chomp;

        if ($_ =~ m/^(GCA_\d+.\d+)\s+(.[A-Z].....)(\d)\s+(...)$/) {
            my $acc = $1;
            my $nam = $2;
            my $ind = $3;
            my $typ = $4;

            if (exists($map{"$nam$typ"})) {
                $map{"$nam$typ"} .= " $acc";
            } else {
                $map{"$nam$typ"}  =   $acc;
            }

            if (exists($map{"$nam$ind$typ"})) {
                die "Multiple genbank ACCs for '$nam$ind$typ'.\n";
            } else {
                $map{"$nam$ind$typ"} = $acc;
            }

            #print "GENBANK $nam$typ -> $acc\n";
        } else {
            die "Failed to match genbank line '$_'\n";
        }
    }

    return(%map);
}

#
#  Load the existing .md page for a species.
#

sub loadMeta ($$) {
    my $species = shift @_;
    my $meta    = shift @_;

    my  @keys;
    my  @lvls;

    my  $lvl = 0;

    undef %$meta;

    open(MD, "< vgp-metadata/species/$species.yaml");
    while (<MD>) {
        chomp;

        if (m/^(\s*)(\S*):\s*(.*)$/) {
            my $indent = $1;
            my $key    = $2;   $key   =~ s/^\s+//;  $key   =~ s/\s+$//;
            my $value  = $3;   $value =~ s/^\s+//;  $value =~ s/\s+$//;

            my $len    = length($indent);

            #print "\n";
            #print "WORK $len $lvl $key -> $value\n";

            if      ($len  < $lvl) {
                while ($len < $lvl) {
                    #print "pop     ", $keys[-1], " len=$len lvl=$lvl\n";
                    $lvl -= $lvls[-1];
                    pop @keys;
                    pop @lvls;
                }
            }

            if ($len == $lvl) {
                #print "replace ", $keys[-1], "\n";
                pop @keys;
                push @keys, $key;

            } elsif ($len >  $lvl) {
                #print "append  ", $keys[-1], "\n";
                push @keys, $key;
                push @lvls, $len - $lvl;

                $lvl = $len;
            }

            $key = join '.', @keys;

            #print "$key: $value\n";

            $$meta{$key} = $value;
        }
    }

    die "No meta{species.name} found?\n"  if ($$meta{"species.name"} eq "");

    my @n = split '\s+', $$meta{"species.name"};

    die "species.name '", $$meta{"species.name"}, "' has ", scalar(@n), " components, expected 2.\n" if (scalar(@n) < 2);

    return("$n[0]_$n[1]");      #  Return the proper Species_name for this species.
}



sub loadData ($$) {
    my $species = shift @_;
    my $data    = shift @_;

    my  @keys;
    my  @lvls;

    my  $lvl = 0;

    undef %$data;

    my $key;

    open(MD, "< ../_genomeark/$species.md");
    while (<MD>) {
        chomp;

        #  Match the YAML delimiters.
        if    (m!^---$!) {
            $key    = undef;
        }

        #  Match any multi-line pre-formatted parameters.
        elsif (m!(\w+):\s*\|$!) {
            $key = $1;
            $$data{$key} = "|\n";
        }

        #  Add data to multi-line parameters.
        elsif (defined($key) && (m!^\s\s\S!)) {
            $$data{$key} .= "$_\n";
        }

        #  Match any key-value pairs.
        elsif (m!(\w+):\s*(.*)$!) {
            $key      = undef;
            $$data{$1} = $2;
        }

        #  Match any extra stuff in the file.
        else {
            $$data{":"} .= "$_\n";
        }
    }
    close(MD);
}



sub saveData ($$) {
    my $species = shift @_;
    my $data    = shift @_;

    my @keys = keys %$data;

    @keys = sort @keys;

    open(MD, "> ../_genomeark/$species.md");

    print MD "---\n";
    foreach my $key (@keys) {
        next if ($key eq ":");

        chomp $$data{$key};   #  Remove the newline on multi-line data.

        if ($$data{$key} ne "") {             #  Just because the original didn't
            print MD "$key: $$data{$key}\n";  #  include a space when the data
        } else {                              #  was null.
            #print MD "$key:\n";
        }
    }
    print MD "---\n";
    print MD $$data{":"};

    close(MD);
}



sub printData ($$$) {
    my $species = shift @_;
    my $data    = shift @_;

    my @keys = keys %$data;

    @keys = sort @keys;

    foreach my $key (@keys) {
        next if ($key eq ":");

        chomp $$data{$key};   #  Remove the newline on multi-line data.

        if ($$data{$key} ne "") {
            print "$key: $$data{$key}\n";
        } else {
            print "$key:\n";
        }
    }
    print $$data{":"};
}



sub prettifyBases ($) {
    my $size = shift @_;

    if ($size eq "-")   { return("$size"); }   #  Empty row in N50 table.
    if ($size == 0)     { return(undef);   }   #  Unset genome size.

    #  Shows up to "### bp"
    if      ($size < 1000) {
        return("$size  bp");
    }

    #  Shows up to "##.## Kbp"
    elsif ($size < 100000) {
        $size = int($size / 10 + 0.5) / 100.0;
        return(sprintf("%.2f Kbp", $size));
    }

    #  Shows up to "500.## Mbp"
    elsif ($size < 500000000) {
        $size = int($size / 10000 + 0.5) / 100.0;
        return(sprintf("%.2f Mbp", $size));
    }

    #  Everything else.
    else {
        $size = int($size / 10000000 + 0.5) / 100.0;
        return(sprintf("%.2f Gbp", $size));
    }
}



sub generateAssemblySummary ($$$$) {
    my $filename   = shift @_;
    my $filesize   = shift @_;
    my $type       = shift @_;
    my $genomeSize = shift @_;
    my $split      = ($type eq "ctg") ? "-split-n" : "";

    unlink "$filename.$type.summary"   if (-z "$filename.$type.summary");

    if ((! -e "downloads/$filename.gz") &&
        (! -e "$filename.$type.summary")) {
        printf "FETCH asm - size %6.3f GB\n", $filesize / 1024 / 1024 / 1024;
        printf "  aws --no-progress --no-sign-request s3 cp \\\n";
        printf "    s3://genomeark/$filename.gz \\\n";
        printf "         downloads/$filename.gz\n";
        printf "\n";

        system("mkdir -p downloads")   if (! -e "downloads");
        system("aws --no-progress --no-sign-request s3 cp s3://genomeark/$filename.gz downloads/$filename.gz")   if ($downloadASM);
    }

    if ((  -e "downloads/$filename.gz") &&
        (! -e "$filename.$type.summary")) {
        my $cmd;

        $cmd  = "$seqrequester summarize $split -1x";
        $cmd .= " -size $genomeSize"                                  if ($genomeSize > 0);
        $cmd .= " downloads/$filename.gz > $filename.$type.summary";

        print "SUMMARIZING '$filename' with genome_size $genomeSize and options '$split'\n";

        system("mkdir -p $filename");   #  To build all the intermediate directories.
        system("rmdir    $filename");
        system($cmd);

        unlink "$filename.$type.summary"   if (-z "$filename.$type.summary");
    }

    die "FAILED TO FIND SIZES '$filename'\n"   if ((! -e "$filename.$type.summary") && ($downloadASM));
}



sub loadAssemblySummary ($$$$$$) {
    my $filename   = shift @_;
    my $ctgNG      = shift @_;
    my $ctgLG      = shift @_;
    my $ctgLEN     = shift @_;
    my $ctgCOV     = shift @_;
    my $genomeSize = shift @_;
    my $n50        = undef;
    my $size       = undef;

    if (! -e "$filename") {
        push @$ctgNG,  0;
        push @$ctgLG,  0;
        push @$ctgLEN, 0;
        push @$ctgCOV, 0;

        return(0);
    }

    open(SU, "< $filename");
    while (<SU>) {
        s/^\s+//;
        s/\s+$//;
        next if ($_ eq "");
        my ($a, $b) = split '||', $_;
        $a =~ s/^\s+//;
        $a =~ s/\s+$//;

        #  Usually:
        #    a = NG
        #    b = length
        #    c = index
        #    d = sum
        #  except on the last line where the is no length field.
        #
        my ($a, $b, $c, $d) = split '\s+', $_;

        #  If zero, the column was empty, or not a number.
        if ($a == 0) {
            next;
        }

        #  Save the n50 value before we prettify it.
        if (($a == 50) && ($b ne "-")) {
            $n50 = $b;
        }

        #  Add the values to the table, treating the summary line as a footer.
        if ($a =~ m!x!) {
            $size = $c;         #  Save the total size of the assembly.

            $a =~ s/^0+//;      #  Strip off leading zeros from "000.851x"
            $a =~ s/^\./0./;    #  But then add back one to get "0.851x"

            $c = prettifyBases($c);

            push @$ctgNG,  $a;
            push @$ctgLG,  $b;
            push @$ctgLEN, $c;
            push @$ctgCOV, $c;

            last;
        }

        else {
            $a =~ s/^0+//;
            $b = prettifyBases($b);
            $d = (($genomeSize == 0) || ($b eq "-")) ? "-" : sprintf("%.2f", $d / $genomeSize);

            push @$ctgNG,  $a;
            push @$ctgLG,  $c;
            push @$ctgLEN, $b;
            push @$ctgCOV, $d;

        }
    }
    close(SU);

    return($n50, $size);
}



sub generateAssemblySummaryHTML ($$$$) {
    my $prialt     = shift @_;
    my $filename   = shift @_;
    my $filesize   = shift @_;
    my $genomeSize = shift @_;
    my $n50table   = "";

    $filename =~ s/.gz//;

    generateAssemblySummary($filename, $filesize, "ctg", $genomeSize);
    generateAssemblySummary($filename, $filesize, "scf", $genomeSize);

    $n50table .= "|\n";
    $n50table .= "  <table class=\"sequence-sizes-table\">\n";
    $n50table .= "  <thead>\n";

    $n50table .= "  <tr>\n";
    $n50table .= "  <th></th>\n";
    $n50table .= "  <th colspan=2 align=center>Contigs</th>\n";
    $n50table .= "  <th colspan=2 align=center>Scaffolds</th>\n";
    $n50table .= "  </tr>\n";

    $n50table .= "  <tr>\n";
    $n50table .= "  <th>NG</th>\n";
    $n50table .= "  <th>LG</th>\n";
    $n50table .= "  <th>Len</th>\n";
    $n50table .= "  <th>LG</th>\n";
    $n50table .= "  <th>Len</th>\n";
    $n50table .= "  </tr>\n";
    $n50table .= "  </thead>\n";
    $n50table .= "  <tbody>\n";

    #  Strip out the N50 chart

    my (@ctgNG, @ctgLG, @ctgLEN, @ctgCOV);
    my (@scfNG, @scfLG, @scfLEN, @scfCOV);

    my ($ctgn50, $ctgsize) = loadAssemblySummary("$filename.ctg.summary", \@ctgNG, \@ctgLG, \@ctgLEN, \@ctgCOV, $genomeSize);
    my ($scfn50, $scfsize) = loadAssemblySummary("$filename.scf.summary", \@scfNG, \@scfLG, \@scfLEN, \@scfCOV, $genomeSize);

    #  Ten rows of actual data.

    for (my $ii=0; $ii<10; $ii++) {
        my $ctgcolor = "";
        my $scfcolor = "";

        #  For non-alternate assemblies (primary, maternal, paternal) highlight the n-50 line.

        if (($ii == 4) && ($prialt ne "alt")) {
            $ctgcolor = ($ctgn50 <  $goodCTG) ? " style=\"background-color:#ff8888;\"" : " style=\"background-color:#88ff88;\"";
            $scfcolor = ($scfn50 <  $goodSCF) ? " style=\"background-color:#ff8888;\"" : " style=\"background-color:#88ff88;\"";
        }

        if ($ii == 4) {
            $n50table .= "  <tr style=\"background-color:#cccccc;\">";
        } else {
            $n50table .= "  <tr>";
        }

        $n50table .= "<td> $ctgNG[$ii] </td>";
        $n50table .= "<td> $ctgLG[$ii] </td><td$ctgcolor> $ctgLEN[$ii] </td>";  #<td> $ctgCOV[$ii] </td>
        $n50table .= "<td> $scfLG[$ii] </td><td$scfcolor> $scfLEN[$ii] </td>";  #<td> $scfCOV[$ii] </td>
        $n50table .= "</tr>";
    }

    #  And one row of summary.

    $n50table .= "  </tbody>\n";
    $n50table .= "  <tfoot>\n";
    $n50table .= "  <tr>";
    $n50table .= "<th> $ctgNG[10] </th>";
    $n50table .= "<th> $ctgLG[10] </th><th> $ctgLEN[10] </th>";
    $n50table .= "<th> $scfLG[10] </th><th> $scfLEN[10] </th>";
    $n50table .= "</tr>\n";
    $n50table .= "  </tfoot>\n";

    $n50table .= "  </table>\n";

    return($ctgn50, $scfn50, $scfsize, $n50table);
}




#  Returns 'S'  for normal subread
#          'H'  for actual hifi read
#          'HS' for hifi subread
#          'I'  for stuff to ignore (scraps, fastq, fasta)
#          ' '  for unknown
#
#  Adds "i" to the end if the file is an index.
#
sub isHifi ($) {
    my $filename = shift @_;
    my $prefix   = "";
    my $i        = "";

    return "I"   if ($filename =~ m/scraps\.bam/);
    return "I"   if ($filename =~ m/fastq/);
    return "I"   if ($filename =~ m/fasta/);

    if ($filename =~ m!/genomic_data/pacbio/(.*)!) {
        my @c = split '\.', $1;
        $prefix = $c[0];
    }

    return " "   if ($prefix eq "");

    $i = "i"   if ($filename =~ m/bam\.pbi/);
    $i = "i"   if ($filename =~ m/bam\.bai/);

    return("S$i")   if (($filename =~ m!subreads!) && ($ccsPrefixes{$prefix} == 0));
    return("HS$i")  if (($filename =~ m!subreads!) && ($ccsPrefixes{$prefix} == 1));

    return("H$i")   if (($filename =~ m!ccs!));
    return("H$i")   if (($filename =~ m!hifi!));

    return(" ");
}


sub processData ($$$$$) {
    my $filesize = shift @_;
    my $filename = shift @_;
    my $seqFiles = shift @_;
    my $seqBytes = shift @_;
    my $seqIndiv = shift @_;

    my $sTag = "";
    my $iTag = "";

    if ($filename =~ m!species/(.*)/(.*)/genomic_data!) {
        $sTag = $1;
        $iTag = $2;
    } else {
        die "failed to parse species name and individual from '$filename'\n";
    }


    #  Based on directory and filename, count stuff.

    if ($filename =~ m!/genomic_data/10x/!) {
        $$seqIndiv{"10x"} .= "$sTag/$iTag\0";

        if (($filename =~ m/fastq.gz/) ||
            ($filename =~ m/fq.gz/)) {
            $$seqFiles{"10x"} += 1;
            $$seqBytes{"10x"} += $filesize;
        } elsif ($filename =~ m/txt$/) {
        } else {
            print "processData()- unknown 10x file type in '$filename'\n";
        }
        return;
    }

    if ($filename =~ m!/genomic_data/arima/!) {
        $$seqIndiv{"arima"} .= "$sTag/$iTag\0";

        if (($filename =~ m/fastq.gz/) ||
            ($filename =~ m/fq.gz/)) {
            $$seqFiles{"arima"} += 1;
            $$seqBytes{"arima"} += $filesize;
        } elsif ($filename =~ m/re_bases.txt/) {
            #  Ignore.
        } else {
            print "processData()- unknown arima file type in '$filename'\n";
        }
        return;
    }

    if ($filename =~ m!/genomic_data/bionano/!) {
        $$seqIndiv{"bionano"} .= "$sTag/$iTag\0";

        if      ($filename =~ m/cmap/) {
            $$seqFiles{"bionano"} += 1;
            $$seqBytes{"bionano"} += $filesize;
        } elsif ($filename =~ m/bnx.gz/) {
            $$seqBytes{"bionano"} += $filesize;
        } elsif ($filename =~ m/txt$/) {
        } else {
            print "processData()- unknown bionano file type in '$filename'\n";
        }
        return;
    }

    if ($filename =~ m!/genomic_data/dovetail/!) {
        $$seqIndiv{"dovetail"} .= "$sTag/$iTag\0";

        if (($filename =~ m/fastq.gz/) ||
            ($filename =~ m/fq.gz/)) {
            $$seqFiles{"dovetail"} += 1;
            $$seqBytes{"dovetail"} += $filesize;
        } elsif ($filename =~ m/re_bases.txt/) {
            #  Ignore.
        } else {
            print "processData()- unknown dovetail file type in '$filename'\n";
        }
        return;
    }

    if ($filename =~ m!/genomic_data/illumina/!) {
        $$seqIndiv{"illumina"} .= "$sTag/$iTag\0";

        if (($filename =~ m/fastq.gz/) ||
            ($filename =~ m/fq.gz/)) {
            $$seqFiles{"illumina"} += 1;
            $$seqBytes{"illumina"} += $filesize;
        } elsif ($filename =~ m/txt$/) {
        } else {
            print "processData()- unknown illumina file type in '$filename'\n";
        }
        return;
    }


    if ($filename =~ m!/genomic_data/pacbio/!) {
        my $t = isHifi($filename);

        if    ($t eq "Si") {
            $$seqBytes{"pbsubreads"} += $filesize;
        }
        elsif ($t eq "S") {
            $$seqIndiv{"pbsubreads"} .= "$sTag/$iTag\0";
            $$seqFiles{"pbsubreads"} += 1;
            $$seqBytes{"pbsubreads"} += $filesize;
        }
        elsif ($t eq "Hi") {
            $$seqBytes{"pbhifi"} += $filesize;
        }
        elsif ($t eq "H") {
            $$seqIndiv{"pbhifi"} .= "$sTag/$iTag\0";
            $$seqFiles{"pbhifi"} += 1;
            $$seqBytes{"pbhifi"} += $filesize;
        }
        elsif ($t eq "HSi") {
            $$seqBytes{"pbhifisub"} += $filesize;
        }
        elsif ($t eq "HS") {
            $$seqIndiv{"pbhifisub"} .= "$sTag/$iTag\0";
            $$seqFiles{"pbhifisub"} += 1;
            $$seqBytes{"pbhifisub"} += $filesize;
        }

        elsif ($t eq "I") {
        }

        elsif ($filename =~ m/txt$/) {
        }

        else {
            print "processData()- unknown pacbio file type in '$filename'\n";
        }

        return;
    }

    if ($filename =~ m!/genomic_data/phase/!) {
        $$seqIndiv{"phase"} .= "$sTag/$iTag\0";

        if (($filename =~ m/fastq.gz/) ||
            ($filename =~ m/fq.gz/)) {
            $$seqFiles{"phase"} += 1;
            $$seqBytes{"phase"} += $filesize;
        } elsif ($filename =~ m/re_bases.txt/) {
        } else {
            print "processData()- unknown phase file type in '$filename'\n";
        }
        return;
    }


    if ($filename =~ m!/genomic_data/!) {
        print "processData()- unknown data type in '$filename'\n";
    }
}



sub parseAssemblyName ($$$) {
    my $filename = shift @_;
    my $filesecs = shift @_;
    my $verbose  = shift @_;

    my ($sName, $aLabel, $sTag, $sNum, $prialt, $date, $curated, $err) = undef;

    #  Handle mito first, because the second form also matches the generic 'an assembly' regex.

    if    ($filename =~ m!species/(.*)/.*/(.*assembly.+)/(.......)(\d)\.MT\.(\d\d\d\d)(\d\d)(\d\d).fasta.gz!i) {
        if ($verbose) {
            print "\n";
            print "$filename\n";
            print " - A mitochondrial assembly!\n";
        }

        $sName   = $1;
        $aLabel  = $2;
        $sTag    = $3;
        $sNum    = $4;
        $prialt  = "mito";
        $date    = "$5-$6-$7";
    }

    elsif ($filename =~ m!species/(.*)/.*/(.*assembly.+)/(.......)(\d)[\._](.*)\.(\d\d\d\d)(\d\d)(\d\d)\.MT.fasta.gz!i) {
        if ($verbose) {
            print "\n";
            print "$filename\n";
            print " - A mitochondrial assembly!\n";
        }

        $sName   = $1;
        $aLabel  = $2;
        $sTag    = $3;
        $sNum    = $4;
        $prialt  = "mito";
        $date    = "$6-$7-$8";
    }

    elsif ($filename =~ m!species/(.*)/.*/(.*assembly.+)/(.......)(\d)[\._]\w+\.[WXYZ]\.\w+\.(\d\d\d\d)(\d\d)(\d\d).fasta.gz!i) {
        if ($verbose) {
            print "\n";
            print "$filename\n";
            print " - A merged trio assembly!\n";
        }

        $sName   = $1;
        $aLabel  = $2;
        $sTag    = $3;
        $sNum    = $4;
        $prialt  = "mgd";
        $date    = "$5-$6-$7";
    }

    elsif ($filename =~ m!species/(.*)/.*/(.*assembly.+)/(.......)(\d)[\._](.*)\.(\d\d\d\d)(\d\d)(\d\d).fasta.gz!i) {
        if ($verbose) {
            print "\n";
            print "$filename\n";
            print " - An assembly!   \n";
        }

        #  To handle the correct "mat.cur" and "mat.asm" and incorrect "pri"
        #  (from aDisPic1.pri.20210803.fasta.gz) we extract the whole 'middle
        #  word' and split out the dotted parts.
        my @p = split '\.', $5;

        #  mBosTau1/assembly_curated/mBosTau1.mat.alt.cur.20200213.fasta.gz
        #  mBosTau1/assembly_curated/mBosTau1.pat.alt.cur.20200213.fasta.gz
        #
        #  We're expecting the first word to be 'pri', 'alt', 'mat' or 'pat'.
        #  If we see those in any other word, throw an error.
        if (($p[0] ne "pri") &&
            ($p[0] ne "alt") &&
            ($p[0] ne "mat") &&
            ($p[0] ne "pat")) {
            if ($verbose) {
                print " - Filename has '$p[0]' as first word; required 'pri', 'alt', 'mat' or 'pat'.\n";
            }
            $err = "  Filename '$3$4.$5.$6$7$8.fasta.gz' has '$p[0]' as first word; required 'pri', 'alt', 'mat' or 'pat'.\n";
        }

        if (($p[1] ne "asm") &&
            ($p[1] ne "cur") &&
            ($p[1] ne "decon") &&
            ($p[1] ne undef)) {
            if ($verbose) {
                print " - Filename has '$p[1]' as second word; required 'cur' or 'asm'.\n";
            }
            $err = "  Filename '$3$4.$5.$6$7$8.fasta.gz' has '$p[1]' as second word; required 'cur' or 'asm'.\n";
        }

        $sName   = $1;
        $aLabel  = $2;
        $sTag    = $3;
        $sNum    = $4;
        $prialt  = $p[0];
        $date    = "$6-$7-$8";
    }

    else {
        if ($verbose) {
            print "\n";
            print "$filename\n";
            print " - Failed to parse filename.\n";
        }

        $err = "  Failed to parse '$filename'.\n";
    }

    #  Note if we're a curated assembly, or a decon assembly.

    if ($filename =~ m/decon/) {
        if ($verbose) {
            print " - Decontaminated assembly!\n";
        }
        $curated = "decontaminated";
    }
    elsif ($aLabel eq "assembly_curated") {
        if ($verbose) {
            print " - Curated assembly!\n";
        }
        $curated = "curated";
    }
    else {
        $curated = "uncurated";
    }



    return($sName, $aLabel, $sTag, $sNum, $prialt, $date, $filesecs, $curated, $err);
}


#  On the first pass, we're just trying to find the assembly with the most
#  recent date.
#
#  To handle assemblies with multiple curations, we need to track both:
#    Is curated assembly available?
#    Which assembly to use?
#
sub processAssembly1 ($$$$) {
    my $filesecs = shift @_;
    my $filesize = shift @_;
    my $filename = shift @_;
    my $data     = shift @_;

    my ($sName, $aLabel, $sTag, $sNum, $prialt, $date, $secs, $curated, $err) = parseAssemblyName($filename, $filesecs, 1);

    if (defined($err)) {
        push @potentialErrors, $err;   #  Only save the error once.
        return;
    }

    #  If there isn't a date sete for this prialt, set it to whatever we have.

    if (!exists($$data{"${prialt}${sNum}__datesecs"})) {
        print " - Set ${prialt}${sNum} to $date ", ($curated) ? "($curated)" : "", "\n";
        $$data{"${prialt}${sNum}__datesecs"} = $secs;
        $$data{"${prialt}${sNum}__curated"}  = $curated;
        $$data{"${prialt}${sNum}__filename"} = $filename;
    }

    #  If we've seen a curated assembly, and this one isn't, skip it.

    if (($$data{"${prialt}${sNum}__curated"} eq "curated") && ($curated ne "curated")) {
        print " - Ignore $curated assembly\n";
        return;
    }

    #  If this assembly is curated, and it's the first, save it regardless.

    if (($$data{"${prialt}${sNum}__curated"} ne "curated") && ($curated eq "curated")) {
        print " - Set ${prialt}${sNum} to curated assembly $date\n";
        $$data{"${prialt}${sNum}date"}       = $date;
        $$data{"${prialt}${sNum}__datesecs"} = $secs;
        $$data{"${prialt}${sNum}__curated"}  = $curated;
        $$data{"${prialt}${sNum}__filename"} = $filename;
    }

    #  Ignore anything 'decon'.  We'll include it above if we see it first, but
    #  then prefer anything over it.

    #if ($curated eq "decon") {
    #    print " - Ignore $curated assembly\n";
    #    return;
    #}

    #  Now we're either both curated or both uncurated.

    die if ($$data{"${prialt}${sNum}__curated"} != $curated);

    #  Pick the later date.

    if ($secs < $$data{"${prialt}${sNum}__datesecs"}) {
        print " - Obsolete\n";
        return;
    }

    #  If the date of this file is newer than the date of our data, reset the date of our data
    #  and wipe out all the old data.

    if ($$data{"${prialt}${sNum}__datesecs"} < $secs) {
        print " - Update ${prialt}${sNum} to $date ", ($curated) ? "($curated)" : "", "\n";
        $$data{"${prialt}${sNum}__datesecs"} = $secs;
        $$data{"${prialt}${sNum}__curated"}  = $curated;
        $$data{"${prialt}${sNum}__filename"} = $filename;
    }
}


#  On the second pass, we process the assembly with the most recent date.
#
#  But if there are multiple assemblies with the same date, we get a little confused
#  and show only the last one encountered.

sub processAssembly2 ($$$$) {
    my $filesecs = shift @_;
    my $filesize = shift @_;
    my $filename = shift @_;
    my $data     = shift @_;

    my ($sName, $aLabel, $sTag, $sNum, $prialt, $date, $secs, $curated, $err) = parseAssemblyName($filename, $filesecs, 0);

    if (defined($err)) {
        return;
    }

    #return  if ($secs     ne $$data{"${prialt}${sNum}__datesecs"});
    return  if ($filename ne $$data{"${prialt}${sNum}__filename"});

    delete $$data{"${prialt}${sNum}__datesecs"};
    delete $$data{"${prialt}${sNum}__curated"};
    delete $$data{"${prialt}${sNum}__filename"};

    #  If more than 6 _layouts/genomeark.html needs updating.
    #  (style.scss might need updating, but I couldn't find anything to update)

    if ($sNum > 6) {
        die "Too many assemblies; update style.scss and _layouts/genomeark.html.\n";
    }

    #  Log that we're using this assembly.

    printf "  %8s <- %s\n", "$prialt$sNum", $filename;

    # Set date, assembly label, pretty-print file size, path to file, etc, etc.

    $$data{"${prialt}${sNum}date"}     = $date;
    $$data{"${prialt}${sNum}version"}  = $aLabel;

    if      ($filesize < 1024 * 1024) {
        $$data{"${prialt}${sNum}filesize"} = sprintf("%.0f KB", $filesize / 1024);
    } elsif ($filesize < 1024 * 1024 * 1024) {
        $$data{"${prialt}${sNum}filesize"} = sprintf("%.0f MB", $filesize / 1024 / 1024);
    } elsif ($filesize < 1024 * 1024 * 1024 * 1024) {
        $$data{"${prialt}${sNum}filesize"} = sprintf("%.0f GB", $filesize / 1024 / 1024 / 1024);
    } else {
        $$data{"${prialt}${sNum}filesize"} = sprintf("%.0f TB", $filesize / 1024 / 1024 / 1024 / 1024);
    }

    $$data{"${prialt}${sNum}seq"}      = "https://s3.amazonaws.com/genomeark/$filename";

    ($$data{"${prialt}${sNum}n50ctg"},
     $$data{"${prialt}${sNum}n50scf"},
     $$data{"${prialt}${sNum}length"},
     $$data{"${prialt}${sNum}sizes"})  = generateAssemblySummaryHTML($prialt, $filename, $filesize, $$data{"genome_size"});

    #  Update the assembly status based on the primary n50 and/or curation status.
    #
    #  This is complex.  If the assembly is "curated" or "merged" it is labeled
    #  as curated.  But if "decontaminated", even if it's in 'assembly_curated',
    #  it's still a draft.

    if (($prialt eq "pri") ||
        ($prialt eq "mat") || ($prialt eq "pat") ||
        ($prialt eq "mgd")) {

        if (($curated eq "curated") || ($prialt eq "mgd")) {
            printf "  %8s <- status=curated\n", "$prialt$sNum";
            $$data{"assembly_status"} = "curated";
        }

        elsif (($$data{"${prialt}${sNum}n50ctg"} >= $goodCTG) &&
               ($$data{"${prialt}${sNum}n50scf"} >= $goodSCF)) {
            if ($$data{"assembly_status"} ne "curated") {
                printf "  %8s <- status=high-quality-draft\n", "$prialt$sNum";
                $$data{"assembly_status"} = "high-quality-draft"
            }
        }

        else {
            if (($$data{"assembly_status"} ne "curated") &&
                ($$data{"assembly_status"} ne "high-quality-draft")) {
                printf "  %8s <- status=low-quality-draft\n", "$prialt$sNum";
                $$data{"assembly_status"} = "low-quality-draft";
            }
        }
    }
}



sub downloadAndSummarize ($$$) {
    my $name  = shift @_;
    my $size  = shift @_;
    my $file  = shift @_;
    my $bases = 0;

    unlink "$name.summary"   if (-z "$name.summary");

    if ((! -e "downloads/$name") &&
        (! -e "$name.summary")) {
        printf "FETCH data - size %6.3f GB\n", $size / 1024 / 1024 / 1024;
        printf "  aws --no-progress --no-sign-request s3 cp \\\n";
        printf "    s3://genomeark/$name \\\n";
        printf "         downloads/$name\n";
        printf "\n";

        system("mkdir -p downloads")   if (! -e "downloads");
        system("aws --no-progress --no-sign-request s3 cp s3://genomeark/$name downloads/$name")  if ($downloadRAW);
    }

    #  If a bam, convert to fastq then summarize.

    if ($name =~ m/bam$/) {
        if ((  -e "downloads/$name") &&
            (! -e "$name.summary")) {
            printf "EXTRACT and SUMMARIZE $name.summary\n";

            system("mkdir -p $name");
            system("rmdir    $name");
            system("samtools fasta downloads/$name | $seqrequester summarize - > $name.summary");
        }
    }

    #  Otherwise, summarize directly.

    else {
        if ((  -e "downloads/$name") &&
            (! -e "$name.summary")) {
            printf "SUMMARIZE $name.summary\n";

            system("mkdir -p $name");
            system("rmdir    $name");
            system("$seqrequester summarize downloads/$name > $name.summary");
        }
    }

    #  Parse the summary to find the number of bases in the dataset.

    if (  -e "$name.summary") {
        open(ST, "< $name.summary");
        while (<ST>) {
            if (m/^G=(\d+)\s/) {
                $bases = $1;
                last;
            }
        }
        close(ST);
    }

    if (($bases == 0) && ($downloadRAW == 0)) {
        return($size);
    }

    return($bases);
}



sub estimateRawDataScaling ($$) {
    my $name    = shift @_;
    my $type    = shift @_;
    my @files;

    for (my $ii=0; $ii<$speciesLength; $ii++) {
        my $filesize = $speciesSizes[$ii];
        my $filename = $speciesFiles[$ii];

        push @files, "$filesize\0$filename"   if (($type eq "10x")        && ($filename =~ m!genomic_data/10x/.*q.gz$!));
        push @files, "$filesize\0$filename"   if (($type eq "arima")      && ($filename =~ m!genomic_data/arima/.*q.gz$!));
        push @files, "$filesize\0$filename"   if (($type eq "dovetail")   && ($filename =~ m!genomic_data/dovetail/.*q.gz$!));
        push @files, "$filesize\0$filename"   if (($type eq "illumina")   && ($filename =~ m!genomic_data/illumina/.*q.gz$!));
        push @files, "$filesize\0$filename"   if (($type eq "phase")      && ($filename =~ m!genomic_data/phase/.*q.gz$!));

        push @files, "$filesize\0$filename"   if (($type eq "pbsubreads") && (isHifi($filename) eq "S"));
        push @files, "$filesize\0$filename"   if (($type eq "pbhifi")     && (isHifi($filename) eq "H"));
        push @files, "$filesize\0$filename"   if (($type eq "pbhifisub")  && (isHifi($filename) eq "HS"));
    }

    @files = sort { $a <=> $b } @files;

    #foreach my $f (@files) {
    #    printf "FILE %12d - '%s'\n", split '\0', $f;
    #}

    my $nFiles = scalar(@files);

    return(1.0)   if ($nFiles == 0);

    my $f1 = int(1 * $nFiles / 4);
    my $f2 = int(2 * $nFiles / 4);
    my $f3 = int(3 * $nFiles / 4);

    my ($size1, $name1, $bases1, $seqs1) = split '\0', @files[$f1];
    my ($size2, $name2, $bases2, $seqs2) = split '\0', @files[$f2];
    my ($size3, $name3, $bases3, $seqs3) = split '\0', @files[$f3];

    $bases1 = downloadAndSummarize($name1, $size1, $f1);
    $bases2 = downloadAndSummarize($name2, $size2, $f2);
    $bases3 = downloadAndSummarize($name3, $size3, $f3);

    if (($bases1 == 0) ||
        ($bases2 == 0) ||
        ($bases3 == 0)) {
        print "FAILED TO ESTIMATE SIZES.\n";
        print "  1 - $bases1 - $name1\n";
        print "  2 - $bases2 - $name2\n";
        print "  3 - $bases3 - $name3\n";
        die "\n";
    }

    #print "\n";
    #print "SCALING 1:  size $size1 -- bases $bases1 -- $name1\n";
    #print "SCALING 2:  size $size2 -- bases $bases2 -- $name2\n";
    #print "SCALING 3:  size $size3 -- bases $bases3 -- $name3\n";

    my $scaling = ($bases1 + $bases2 + $bases3) / ($size1 + $size2 + $size3);

    $scaling = int($scaling * 10000) / 10000;  #  Prevent churn by limiting precision of final value.

    return($scaling);
}



sub computeBionanoBases ($) {
    my $name    = shift @_;
    my @files;

    for (my $ii=0; $ii<$speciesLength; $ii++) {
        my $filesize = $speciesSizes[$ii];
        my $filename = $speciesFiles[$ii];

        push @files, "$filesize\0$filename"   if ($filename =~ m!$name.*genomic_data/bionano/.*bnx.gz$!);
    }

    #foreach my $f (@files) {
    #    printf "BIONANO %12d - '%s'\n", split '\0', $f;
    #}

    #  Download all the cmap files.

    foreach my $f (@files) {
        my ($size, $name) = split '\0', $f;

        if ((! -e "downloads/$name") &&
            (! -e "$name.summary")) {
            printf "FETCH bionano - size %6.3f GB\n", $size / 1024 / 1024 / 1024;
            printf "  aws --no-progress --no-sign-request s3 cp \\\n";
            printf "    s3://genomeark/$name \\\n";
            printf "         downloads/$name\n";
            printf "\n";

            system("mkdir -p downloads/$name");
            system("rmdir    downloads/$name");
            system("aws --no-progress --no-sign-request s3 cp s3://genomeark/$name downloads/$name")  if ($downloadRAW);
        }
    }

    #  Parse each bnx to find the molecule sizes

    foreach my $f (@files) {
        my ($size, $name) = split '\0', $f;

        next  if (! -e "downloads/$name");
        next  if (  -e "$name.summary");

        print "PARSING $name\n";

        my $nMolecules = 0;
        my $sLength    = 0;

        system("mkdir -p $name");
        system("rmdir    $name");

        open(B, "gzip -dc downloads/$name |");
        while (<B>) {
            if (m/^0\s/) {
                my @v = split '\s+', $_;

                $nMolecules += 1;
                $sLength    += $v[2];
            }
        }
        close(B);

        open(S, "> $name.summary") or die "Failed to open '$name.summary' for writing: $!\n";;
        print S "Molecules: $nMolecules\n";
        print S "Length:    $sLength\n";
        close(S);
    }

    #  Read the summaries to find the bases.

    my $bases = 0;

    foreach my $f (@files) {
        my ($size, $name) = split '\0', $f;

        if (-e "$name.summary") {
            open(S, "< $name.summary") or die "Failed to open '$name.summary' for reading: $!\n";
            while (<S>) {
                $bases += $1   if (m/Length:\s+(.*)$/);
            }
            close(S);
        }
    }

    return($bases);
}



#
#  Main
#

my $lastUpdate = loadGenomeArk();

my @speciesList = discover(@ARGV);
#my %asmToShow   = loadAssemblyStatus();

my %genbankMap  = loadGenbank();

#  Rebuild each species.md file.

foreach my $species (@speciesList) {
    my %seqFiles;
    my %seqBytes;
    my %seqIndiv;
    my %meta;
    my %data;

    #
    #  Load metadata and copy the good bits.
    #

    my $name = loadMeta($species, \%meta);

    $data{"name"}                = $meta{"species.name"};         #  Name with a space:     'Species_name'
    $data{"name_"}               = $name;                         #  Name with underscore:  'Species_name'
    $data{"short_name"}          = $meta{"species.short_name"};

    $data{"common_name"}         = $meta{"species.common_name"};
    $data{"taxon_id"}            = $meta{"species.taxon_id"};

    $data{"genome_size"}         = $meta{"species.genome_size"};
    $data{"genome_size_display"} = prettifyBases($meta{"species.genome_size"});  #  Updated later, too.
    $data{"genome_size_method"}  = $meta{"species.genome_size_method"};

    $data{"data_status"}         = "none";  #<em style=\"color:red\">no data</em>";
    $data{"assembly_status"}     = "none";  #<em style=\"color:red\">no assembly</em>";

    #data{"last_raw_data"}       = Do not set here; should only be present if data exists.
    $data{"last_updated"}        = 0;

    #
    #  Track down any link to NCBI.
    #

    {
        my $n = $data{"short_name"};

        if (exists($genbankMap{"${n}pri"}))    { $data{"genbank_pri"} = $genbankMap{"${n}pri"}; }
        if (exists($genbankMap{"${n}alt"}))    { $data{"genbank_alt"} = $genbankMap{"${n}alt"}; }
        if (exists($genbankMap{"${n}mat"}))    { $data{"genbank_mat"} = $genbankMap{"${n}mat"}; }
        if (exists($genbankMap{"${n}pat"}))    { $data{"genbank_pat"} = $genbankMap{"${n}pat"}; }
    }

    #
    #  Find and save only the files related to this species.
    #  Also remember the prefix of any pacbio ccs files, so we
    #  can exclude those from the normal pacbio list.
    #

    undef @speciesEpoch;
    undef @speciesSizes;
    undef @speciesFiles;
    undef %ccsPrefixes;

    $speciesLength = 0;

    for (my $ii=0; $ii<$genomeArkLength; $ii++) {
        next   if ($genomeArkFiles[$ii] !~ m!$name!);

        push @speciesEpoch, $genomeArkEpoch[$ii];
        push @speciesSizes, $genomeArkSizes[$ii];
        push @speciesFiles, $genomeArkFiles[$ii];

        if ($genomeArkFiles[$ii] =~ m!genomic_data/pacbio/(.*).ccs(\..*){0,1}\.bam!) {
            $ccsPrefixes{$1} = 1;
        }

        $speciesLength++;
    }

    #
    #  Scan all the files, estimating sizes and generating statistics.
    #

    print "\n";
    print "----------------------------------------\n";
    print "Processing species  $name\n";

    #  Determind the date of the last file change.
    #  This is shown on the web page as 'last updated'.

    for (my $ii=0; $ii<$speciesLength; $ii++) {
        my $filesecs = $speciesEpoch[$ii];
        my $filesize = $speciesSizes[$ii];
        my $filename = $speciesFiles[$ii];

        if ($data{"last_updated"} < $filesecs) {
            $data{"last_updated"} = $filesecs;
        }
    }

    #  Process all genomic_data.

    print "\n";
    print "----------\n";
    print "Genomic Data\n";

    for (my $ii=0; $ii<$speciesLength; $ii++) {
        my $filesecs = $speciesEpoch[$ii];
        my $filesize = $speciesSizes[$ii];
        my $filename = $speciesFiles[$ii];

        if ($filename =~ m!genomic_data!) {
            if ($data{"last_raw_data"} < $filesecs) {     #  If this isn't set, Raw Data shows
                $data{"last_raw_data"} = $filesecs;       #  "No data.".
            }

            processData($filesize, $filename, \%seqFiles, \%seqBytes, \%seqIndiv);
        }
    }

    #  Process all genomes.  This needs two passes.  The first pass finds the
    #  date of the latest assembly, then the second pass processes that file
    #  to find and save n50's and etc.

    print "\n";
    print "----------\n";
    print "Assemblies, pass 1\n";

    for (my $ii=0; $ii<$speciesLength; $ii++) {
        my $filesecs = $speciesEpoch[$ii];
        my $filesize = $speciesSizes[$ii];
        my $filename = $speciesFiles[$ii];

        if (isAssemblyFile($filename, 0)) {
            processAssembly1($filesecs, $filesize, $filename, \%data);
        }
    }

    print "\n";
    print "----------\n";
    print "Assemblies, pass 2\n";

    for (my $ii=0; $ii<$speciesLength; $ii++) {
        my $filesecs = $speciesEpoch[$ii];
        my $filesize = $speciesSizes[$ii];
        my $filename = $speciesFiles[$ii];

        if (isAssemblyFile($filename, 0)) {
            processAssembly2($filesecs, $filesize, $filename, \%data);
        }
    }

    #  A third (or is this fourth) pass through, to report any unprocessed
    #  files.  A bit clunky this one, since we need to duplicate all the
    #  checks from the cases above.

    #  Reported at the end of the script.

    #print "\n";
    #print "----------\n";
    #print "Unknown files:\n";

    for (my $ii=0; $ii<$speciesLength; $ii++) {
        my $filesecs = $speciesEpoch[$ii];
        my $filesize = $speciesSizes[$ii];
        my $filename = $speciesFiles[$ii];

        next  if ($filename =~ m!genomic_data!);
        next  if (isAssemblyFile($filename, 0));

        #print "  UNKNOWN $filename\n";

        push @unknownFiles, "  $filename\n";
    }

    print "\n";


    #
    #  Finalize the genomic_data by adding to %data.
    #

    $seqFiles{"dovetail"} /= 2;
    $seqFiles{"illumina"} /= 2;
    $seqFiles{"phase"}    /= 2;

    foreach my $type (qw(10x arima bionano dovetail illumina pbsubreads pbhifi pbhifisub phase)) {
        if ($seqBytes{$type} > 0) {
            $data{"data_${type}_bytes"}    = sprintf("%.3f GB", $seqBytes{$type} / 1024 / 1024 / 1024);
            $data{"data_${type}_coverage"} = "N/A";
            $data{"data_${type}_bases"}    = "N/A";
            $data{"data_${type}_files"}    = $seqFiles{$type};
        }
    }

    #  Update genome size if not set.

    if ($data{"genome_size"} == 0)   { $data{"genome_size"} = $data{"pri1length"}; }
    if ($data{"genome_size"} == 0)   { $data{"genome_size"} = $data{"pri2length"}; }
    if ($data{"genome_size"} == 0)   { $data{"genome_size"} = $data{"pri3length"}; }
    if ($data{"genome_size"} == 0)   { $data{"genome_size"} = $data{"pri4length"}; }

    $data{"genome_size_display"} = prettifyBases($data{"genome_size"});

    #
    #  Estimate the number of bases in all the raw data files.
    #    BIONANO is totally different and not supported.
    #    HiFi subreads aren't computed either, not useful and big.
    #

    $data{"data_10x_scale"}        = estimateRawDataScaling($name, "10x")          if ($data{"data_10x_scale"}        == 0);
    $data{"data_arima_scale"}      = estimateRawDataScaling($name, "arima")        if ($data{"data_arima_scale"}      == 0);
    $data{"bionano_scale"}         = 0;
    $data{"data_dovetail_scale"}   = estimateRawDataScaling($name, "dovetail")     if ($data{"data_dovetail_scale"}   == 0);
    $data{"data_illumina_scale"}   = estimateRawDataScaling($name, "illumina")     if ($data{"data_illumina_scale"}   == 0);
    $data{"data_pbsubreads_scale"} = estimateRawDataScaling($name, "pbsubreads")   if ($data{"data_pbsubreads_scale"} == 0);
    $data{"data_pbhifi_scale"}     = estimateRawDataScaling($name, "pbhifi")       if ($data{"data_pbhifi_scale"}     == 0);
    #data{"data_pbhifisub_scale"}  = estimateRawDataScaling($name, "pbhifisub")    if ($data{"data_pbhifisub_scale"}  == 0);
    $data{"data_pbhifisub_scale"}  = 0;
    $data{"data_phase_scale"}      = estimateRawDataScaling($name, "phase")        if ($data{"data_phase_scale"}      == 0);

    #  Figure out how much and what types of data exist.

    my $dataPac = 0;
    my $data10x = 0;
    my $dataHIC = 0;
    my $dataBio = 0;

    sub uniquifyStringArray ($) {    #  Split a \0 delimited string into an
        my @a = split '\0', $_[0];   #  array of unique elements.
        my %a;

        foreach my $a (@a) {
            $a{$a}++;
        }

        return(sort keys %a);
    }


    if (($seqBytes{"10x"} > 0)) {
        foreach my $k (uniquifyStringArray($seqIndiv{"10x"})) {
            $data{"data_10x_links"} .= "aws s3 --no-sign-request sync s3://genomeark/species/$k/genomic_data/10x/ .<br>";
        }

        if (($data{"data_10x_scale"} > 0) && ($data{"genome_size"} > 0)) {
            $data{"data_10x_coverage"}        = sprintf("%.2fx", $seqBytes{"10x"} * $data{"data_10x_scale"} / $data{"genome_size"});
            $data{"data_10x_bases"}           = prettifyBases($seqBytes{"10x"} * $data{"data_10x_scale"});
        }
        $data10x++;
    }

    if (($seqBytes{"arima"} > 0)) {
        foreach my $k (uniquifyStringArray($seqIndiv{"arima"})) {
            $data{"data_arima_links"} .= "aws s3 --no-sign-request sync s3://genomeark/species/$k/genomic_data/arima/ .<br>";
        }

        if (($data{"data_arima_scale"} > 0) && ($data{"genome_size"} > 0)) {
            $data{"data_arima_coverage"}      = sprintf("%.2fx", $seqBytes{"arima"} * $data{"data_arima_scale"} / $data{"genome_size"});
            $data{"data_arima_bases"}         = prettifyBases($seqBytes{"arima"} * $data{"data_arima_scale"});
        }
        $dataHIC++;
    }

    if (($seqBytes{"bionano"} > 0)) {
        foreach my $k (uniquifyStringArray($seqIndiv{"bionano"})) {
            $data{"data_bionano_links"} .= "aws s3 --no-sign-request sync s3://genomeark/species/$k/genomic_data/bionano/ .<br>";
        }

        if ($data{"genome_size"} > 0) {    #  No scaling for bionano!
            my $b = computeBionanoBases($name);
            $data{"data_bionano_coverage"}    = sprintf("%.2fx", $b / $data{"genome_size"});
            $data{"data_bionano_bases"}       = prettifyBases($b);
        }
        $dataBio++;
    }

    if (($seqBytes{"dovetail"} > 0)) {
        foreach my $k (uniquifyStringArray($seqIndiv{"dovetail"})) {
            $data{"data_dovetail_links"} .= "aws s3 --no-sign-request sync s3://genomeark/species/$k/genomic_data/dovetail/ .<br>";
        }

        if (($data{"data_dovetail_scale"} > 0) && ($data{"genome_size"} > 0)) {
            $data{"data_dovetail_coverage"}   = sprintf("%.2fx", $seqBytes{"dovetail"} * $data{"data_dovetail_scale"} / $data{"genome_size"});
            $data{"data_dovetail_bases"}      = prettifyBases($seqBytes{"dovetail"} * $data{"data_dovetail_scale"});
        }
        $dataHIC++;
    }

    if (($seqBytes{"illumina"} > 0)) {
        foreach my $k (uniquifyStringArray($seqIndiv{"illumina"})) {
            $data{"data_illumina_links"} .= "aws s3 --no-sign-request sync s3://genomeark/species/$k/genomic_data/illumina/ .<br>";
        }

        if (($data{"data_illumina_scale"} > 0) && ($data{"genome_size"} > 0)) {
            $data{"data_illumina_coverage"}   = sprintf("%.2fx", $seqBytes{"illumina"} * $data{"data_illumina_scale"} / $data{"genome_size"});
            $data{"data_illumina_bases"}      = prettifyBases($seqBytes{"illumina"} * $data{"data_illumina_scale"});
        }
    }

    if (($seqBytes{"pbsubreads"} > 0)) {
        foreach my $k (uniquifyStringArray($seqIndiv{"pbsubreads"})) {
            $data{"data_pbsubreads_links"} .= "aws s3 --no-sign-request sync s3://genomeark/species/$k/genomic_data/pacbio/ . --exclude \"*ccs*bam*\"<br>";
        }

        if (($data{"data_pbsubreads_scale"} > 0) && ($data{"genome_size"} > 0)) {
            $data{"data_pbsubreads_coverage"} = sprintf("%.2fx", $seqBytes{"pbsubreads"} * $data{"data_pbsubreads_scale"} / $data{"genome_size"});
            $data{"data_pbsubreads_bases"}    = prettifyBases($seqBytes{"pbsubreads"} * $data{"data_pbsubreads_scale"});
        }
        $dataPac++;
    }

    if (($seqBytes{"pbhifi"} > 0)) {
        foreach my $k (uniquifyStringArray($seqIndiv{"pbhifi"})) {
            $data{"data_pbhifi_links"} .= "aws s3 --no-sign-request sync s3://genomeark/species/$k/genomic_data/pacbio/ . --exclude \"*subreads.bam*\"<br>";
        }

        if (($data{"data_pbhifi_scale"}) && ($data{"genome_size"} > 0)) {
            $data{"data_pbhifi_coverage"} = sprintf("%.2fx", $seqBytes{"pbhifi"} * $data{"data_pbhifi_scale"} / $data{"genome_size"});
            $data{"data_pbhifi_bases"}    = prettifyBases($seqBytes{"pbhifi"} * $data{"data_pbhifi_scale"});
        }
        $dataPac++;
    }

    if (($seqBytes{"pbhifisub"} > 0)) {
        #foreach my $k (uniquifyStringArray($seqIndiv{"pbhifisub"})) {
        #    $data{"data_pbhifisub_links"} .= "aws s3 ......<br>";   #  NOT listed on the page.
        #}

        if (($data{"data_pbhifisub_scale"} > 0) && ($data{"genome_size"} > 0)) {
            $data{"data_pbhifisub_coverage"} = sprintf("%.2fx", $seqBytes{"pbhifisub"} * $data{"data_pbhifisub_scale"} / $data{"genome_size"});
            $data{"data_pbhifisub_bases"}    = prettifyBases($seqBytes{"pbhifisub"} * $data{"data_pbhifisub_scale"});
        }
        $dataPac++;
    }

    if (($seqBytes{"phase"} > 0)) {
        foreach my $k (uniquifyStringArray($seqIndiv{"phase"})) {
            $data{"data_phase_links"} .= "aws s3 --no-sign-request sync s3://genomeark/species/$k/genomic_data/phase/ .<br>";
        }

        if (($data{"data_phase_scale"} > 0) && ($data{"genome_size"} > 0)) {
            $data{"data_phase_coverage"}      = sprintf("%.2fx", $seqBytes{"phase"} * $data{"data_phase_scale"} / $data{"genome_size"});
            $data{"data_phase_bases"}         = prettifyBases($seqBytes{"phase"} * $data{"data_phase_scale"});
        }
        $dataHIC++;
    }

    #  Set the classification.
    #  If no assembly, put it under either "some data" or "all data".
    #  Otherwise, put it under the assembly classification.

    if (($dataPac > 0) ||
        ($data10x > 0) ||
        ($dataHIC > 0) ||
        ($dataBio > 0)) {
        $data{"data_status"} = "some";
    }

    if (($dataPac > 0) &&
        ($data10x > 0) &&
        ($dataHIC > 0) &&
        ($dataBio > 0)) {
        $data{"data_status"} = "all";
    }

    #  Create symlinks to the categories.
    #
    #  Name changes should change:
    #  1)  the label used in this script ("low-quality-draft")
    #  2)  the directory name in the symlink
    #  3)  the actual directories (both "_genomeark-low-quality-draft" and "genomeark-low-quality-draft")
    #  4)  the index.html in genomeark-low-quality-draft/  (both the title and the collection name)
    #  5)  _config.yml (in two places) and index.html in the root directory.

    unlink("../_genomeark-curated-assembly/$name.md");
    unlink("../_genomeark-high-quality-draft-assembly/$name.md");
    unlink("../_genomeark-low-quality-draft-assembly/$name.md");
    unlink("../_genomeark-complete-data/$name.md");
    unlink("../_genomeark-incomplete-data/$name.md");

    if    ($data{"assembly_status"} eq "curated") {
        system("mkdir -p ../_genomeark-curated-assembly");
        symlink("../_genomeark/$name.md", "../_genomeark-curated-assembly/$name.md") or die "Failed to make symlink for curated assembly: $!.\n";
    }

    elsif ($data{"assembly_status"} eq "high-quality-draft") {
        system("mkdir -p ../_genomeark-high-quality-draft-assembly");
        symlink("../_genomeark/$name.md", "../_genomeark-high-quality-draft-assembly/$name.md") or die "Failed to make symlink for high-quality-draft assembly: $!.\n";
    }

    elsif ($data{"assembly_status"} eq "low-quality-draft-assembly") {
        system("mkdir -p ../_genomeark-low-quality-draft");
        symlink("../_genomeark/$name.md", "../_genomeark-low-quality-draft-assembly/$name.md") or die "Failed to make symlink for low-quaity-draft assembly: $!.\n";
    }

    elsif ($data{"data_status"} eq "all") {
        system("mkdir -p ../_genomeark-complete-data");
        symlink("../_genomeark/$name.md", "../_genomeark-complete-data/$name.md") or die "Failed to make symlink for complete data: $!.\n";
    }

    elsif ($data{"data_status"} eq "some") {
        system("mkdir -p ../_genomeark-incomplete-data");
        symlink("../_genomeark/$name.md", "../_genomeark-incomplete-data/$name.md") or die "Failed to make symlink for incomplete data: $!.\n";
    }

    else {
        system("mkdir -p ../_genomeark-incomplete-data");
        symlink("../_genomeark/$name.md", "../_genomeark-incomplete-data/$name.md") or die "Failed to make symlink for incomplete data (catch all): $!.\n";
    }

    #  And reset the classifications to strings we can use in the display.

    $data{"data_status"}     = "<em style=\"color:red\">no data</em>"                          if ($data{"data_status"}) eq "none";
    $data{"data_status"}     = "<em style=\"color:orange\">some data</em>"                     if ($data{"data_status"}) eq "some";
    $data{"data_status"}     = "<em style=\"color:green\">all data</em>"                       if ($data{"data_status"}) eq "all";

    $data{"assembly_status"} = "<em style=\"color:red\">no assembly</em>"                      if ($data{"assembly_status"} eq "none");
    $data{"assembly_status"} = "<em style=\"color:red\">low-quality draft assembly</em>"       if ($data{"assembly_status"} eq "low-quality-draft");
    $data{"assembly_status"} = "<em style=\"color:orange\">high-quality draft assembly</em>"   if ($data{"assembly_status"} eq "high-quality-draft");
    $data{"assembly_status"} = "<em style=\"color:green\">curated assembly</em>"               if ($data{"assembly_status"} eq "curated");

    #  If no date set -- no raw data, no assemblies, no anything -- set it to the
    #  date of this update (genomeark.ls's date).

    if ($data{"last_updated"} == 0) {
        print "WARNING: no files; last_updated set to 'now'.\n";
        $data{"last_updated"} = $lastUpdate;
    }

    #  Done.  Write the output.

    if ($name ne $species) {
        print "WARNING: species '$species' is not the same as name '$name' (using name instead)\n";
    }

    #printData($species, \%data);
    saveData($name, \%data);
}


#  And whatever errors we saved.

if (scalar(@potentialErrors > 0)) {
    print "\n";
    print "----------------------------------------\n";
    print "Potential errors found:\n";
    foreach my $l (sort @potentialErrors) {
        print "  $l";
    }
    print "\n";
}


if (scalar(@unknownFiles > 0)) {
    print "\n";
    print "----------------------------------------\n";
    print "Unknown files:\n";
    foreach my $l (sort @unknownFiles) {
        print "  $l";
    }
    print "\n";
}
