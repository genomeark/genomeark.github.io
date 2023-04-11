---
layout: documentation
title: GenomeArk AWS S3 bucket layout and file names
permalink: structure.html
published: false
---

<!--
NOTE: For testing, set `published:` to `true`. Leave it set to `false` when
      committing changes until we're ready to launch this page.
-->

This is a **DRAFT**. Please send comments to `#data-coord` on Slack.

# Data Structure

All data for Genomeark is stored in an AWS S3 bucket. The data can be browsed
using a web browser
[here](https://s3.amazonaws.com/genomeark/index.html?prefix=species/). This page
describes how the data are organized. Note that AWS S3 is "object storage" and
does not contain hierarchical directories or folders like traditional file
systems. However, the structure will be discussed as if the data will be
organized in directories for convenience.

The structure is based on
[this specification](https://github.com/VGP/vgp-assembly/blob/master/DNAnexus_and_AWS_data_structure.md),
with changes reflecting subsequent discussions and new data types. The following
is how the file tree looked before:
```
/
└── species/
    └── {Genus_species}/
        └── {ToLID}/
            ├── assembly_{pipeline}_{ver}/
            ├── assembly_curated/
            ├── assembly_MT/
            ├── genomic_data/
            │   ├── ont/
            │   │   ├── reads1.bam
            │   │   ├── reads1.fastq.gz
            │   │   ├── reads2.bam
            │   │   └── reads2.fastq.gz
            │   └── pacbio/
            │       ├── reads1.fastq.gz
            │       ├── reads2.fastq.gz
            │       └── reads3.fastq.gz
            └── transcriptomic_data/
                └── {tissue_id}/
                    ├── illumina/
                    │   ├── reads1_1.fastq.gz
                    │   ├── reads1_2.fastq.gz
                    │   ├── reads2_1.fastq.gz
                    │   └── reads2_2.fastq.gz
                    └── pacbio/
                        ├── reads1.fastq.gz
                        ├── reads2.fastq.gz
                        └── reads3.fastq.gz
```

The primary changes to this structure are the addition of new directories under
`genomic_data`. Generally, each data type is named after the company that
generated it. This has changed slightly since multiple companies are generating
multiple types of data. Try not to let the inconsistency get to you. Each
directory will now be described. If you have a data type not specified, please
reach out for a discussion on naming. The following is how the file tree looks
now (omitting individual files):
```
/
└── species/
    └── {Genus_species}/
        └── {ToLID}/
            ├── assembly_{pipeline}_{ver}/
            ├── assembly_curated/
            ├── assembly_MT/
            ├── genomic_data/
            │   ├── arima/
            │   ├── bionano/
            │   ├── dovetail/
            │   ├── ont_duplex/
            │   ├── ont/
            │   ├── pacbio_hifi/
            │   ├── pacbio/
            │   └── 10x/
            └── transcriptomic_data/
                └── {tissue_id}/
                    ├── illumina/
                    └── pacbio/
```

Once we visit a project (i.e., ToLID directory), the top-level directory is
expected to have:

- genomic\_data
- transcriptomic\_data
- assembly\_{pipeline}\_{ver}
- assembly\_curated
- assembly\_MT

-----
## Genomic Data


### CCS/HiFi data from Pacific Biosciences
  ```
  /
  └── species/
      └── {Genus_species}/
          └── {ToLID}/
              └── genomic_data/
                  └── pacbio_hifi/
                      ├── {movie}.subreads.bam      # optional, but recommended
                      ├── {movie}.subreads.bam.pbi  # optional, but recommended
                      ├── {movie}.hifi_reads.bam
                      ├── {movie}.hifi_reads.fastq.gz
                      ├── {movie}.hifi_reads.5mC.bam
                      ├── {movie}.deepconsensus.bam
                      ├── README
                      └── files.md5
  ```
  Please see [these notes]({{ site.url }}/documentation/hifi-reads.html) about
  kinetics and methylation tags in the `hifi_reads.bam` file.

  Many often provide fastq (gzipped) in addition to the BAMs, despite how
  wasteful that is on space, for convenience &mdash; especially during the
  analysis phase of the project.
  Keeping the subreads BAM files is helpful for calling bases with DeepConsensus
  later, especially if it hasn't already been done.


### Simplex and/or duplex with any pore or chemistry from Oxford Nanopore Technologies
  ```
  /
  └── species/
      └── {Genus_species}/
          └── {ToLID}/
              └── genomic_data/
                  ├── ont/
                  │   ├── {flowcell_id}_{basecaller}-{version}.bam
                  │   ├── {flowcell_id}_{basecaller}-{version}.fastq.gz
                  │   ├── README
                  │   ├── files.md5
                  │   └── fast5/     (optional, but recommended)
                  │       └── {flowcell_id}
                  │           ├── {prefix}.fast5
                  │           └── files.md5
                  └── ont_duplex/
                      ├── {flowcell_id}_{basecaller}-{version}.bam
                      ├── {flowcell_id}_{basecaller}-{version}.fastq.gz
                      ├── README
                      ├── files.md5
                      └── fast5/     (optional, but recommended)
                          └── {flowcell_id}
                              ├── {prefix}.fast5
                              └── files.md5
  ```

  ONT data can be tricky to keep organized because there is such variation
  between runs, depending on choice of machine, pore, library prep, chemistry,
  etc. Most of this information will just be metadata that you should include in
  a README. You are encouraged to call methylation too, please note in the
  README what is and isn't available in each file. Keeping the fast5s is
  also encouraged for future re-calling of bases and/or methylation.


### Hi-C from Arima Genomics
  ```
  /
  └── species/
      └── {Genus_species}/
          └── {ToLID}/
              └── genomic_data/
                  └── arima/
                      ├── {prefix}_{runID}_R1.fastq.gz
                      ├── {prefix}_{runID}_R2.fastq.gz
                      ├── re_bases.txt
                      ├── README
                      └── files.md5
  ```
  Unmapped BAM/CRAM files can be provided instead of fastq.


### dovetail (Hi-C and/or Omni-C from Dovetail Genomics)
  ```
  /
  └── species/
      └── {Genus_species}/
          └── {ToLID}/
              └── genomic_data/
                  └── dovetail/
                      ├── {prefix}_{runID}_R1.fastq.gz
                      ├── {prefix}_{runID}_R2.fastq.gz
                      ├── re_bases.txt
                      ├── README
                      └── files.md5
  ```
  Unmapped BAM/CRAM files can be provided instead of fastq.


### Whole Genome Shotgun from Illumina
  ```
  /
  └── species/
      └── {Genus_species}/
          └── {ToLID}/
              └── genomic_data/
                  └── illumina/
                      ├── {prefix}_{runID}_R1.fastq.gz
                      ├── {prefix}_{runID}_R2.fastq.gz
                      ├── README
                      └── files.md5
  ```
  Unmapped BAM/CRAM files can be provided instead of fastq.


### Irys/Saphyr optical mapping from BioNano Genomics
  ```
  /
  └── species/
      └── {Genus_species}/
          └── {ToLID}/
              └── genomic_data/
                  └── bionano/
                      ├── {prefix}_{platform}_{enzyme}[_{jobid}].bnx.gz
                      ├── {prefix}_{platform}_{enzyme}.cmap.gz
                      ├── README
                      └── files.md5
  ```


## Legacy Genomic Data

Older projects can also include the following legacy data.

### Linked-reads from 10X Genomics
  ```
  /
  └── species/
      └── {Genus_species}/
          └── {ToLID}/
              └── genomic_data/
                  └── 10x/
                      ├── {runID}_S1_L001_I1_001.fastq.gz
                      ├── {runID}_S1_L001_R1_001.fastq.gz
                      ├── {runID}_S1_L001_R2_001.fastq.gz
                      ├── README
                      └── files.md5
  ```

### CLR data from Pacific Biosciences
  ```
  /
  └── species/
      └── {Genus_species}/
          └── {ToLID}/
              └── genomic_data/
                  └── pacbio/
                      ├── {movie}.subreads.bam 
                      ├── {movie}.subreads.bam.pbi
                      ├── {movie}.scraps.bam
                      ├── README
                      └── files.md5
  ```
  The 'scraps' have been purged from GenomeArk.


-----
## Transcriptomic Data

### RNA-seq from Illumina
  ```
  /
  └── species/
      └── {Genus_species}/
          └── {ToLID}/
              └── transcriptomic_data/
                  └── illumina/
                      └── {tissue_type}
                          ├── {prefix}_{runID}_R1.fastq.gz
                          ├── {prefix}_{runID}_R2.fastq.gz
                          ├── README
                          └── files.md5
  ```

### ISO-seq from Pacific Biosciences
  ```
  /
  └── species/
      └── {Genus_species}/
          └── {ToLID}/
              └── transcriptomic_data/
                  └── pacbio/
                      └── {tissue_type}
                          ├── {movie}.subreads.bam
                          ├── {movie}.subreads.bam.pbi
                          ├── {movie}.subreadset.xml
                          ├── {prefix}_hq_isoforms_{#}.{#}.bam    # processed iso-seq file
                          ├── README
                          └── files.md5
  ```

-----

## Assemblies

### Final Curated Assembly
  ```
  /
  └── species/
      └── {Genus_species}/
          └── {ToLID}/
              └── assembly_curated/
                  ├── {genome_id}.pri.cur.YYYYMMDD.fasta.gz       Final curated assembly (primary)
                  ├── {genome_id}.alt.cur.YYYYMMDD.fasta.gz       Final curated assembly (alternate haplotigs)
                  ├── {genome_id}.pri.cur.YYYYMMDD.agp            Chromosome assignments for {genome_id}.pri.cur.YYYYMMDD.fasta.gz
                  └── {genome_id}.pri.cur.YYYYMMDD.MT.fasta.gz    Mitochondrial genome assembly (optional)
  ```
It is accecptable to name the directory `assembly_curated{suffix}`, where the
suffix is an underscore followed by some informative string. This can be useful
when more than 1 assemblies were curated so that they can be easily
easily differentiated from eachother. Examples of informative strings are the
location or institution that generated the assembly, a version, or a date.

### Uncurated Assemblies
  ```
  /
  └── species/
      └── {Genus_species}/
          └── {ToLID}/
              └── assembly_{pipeline}_{ver}/     (pipeline: vgp_standard, cambridge, ...)
                  ├── intermediates/
                  │   ├── falcon_unzip/                            FALCON unzip intermediate files
                  │   ├── purge_haplotigs/                         purge_haplotigs intermediate files
                  │   ├── scaff10x/                                Scaff10X intermediate files
                  │   ├── bionano/                                 Bionano TGH intermediate files
                  │   ├── salsa/                                   Salsa intermediate files
                  │   ├── arrow/                                   Arrow polishing intermediate files
                  │   ├── longer_freebayes_round1/                 Longranger freebayes polishing intermediate files (round1)
                  │   ├── longer_freebayes_round2/                 Longranger freebayes polishing intermediate files (round2)
                  │   ├── {genome_id}_c1.fasta.gz                  Pacbio FALCON-Unzip assembly primary contigs (haplotype 1)
                  │   ├── {genome_id}_c2.fasta.gz                  Pacbio FALCON-Unzip assembly associated haplotigs (haplotype 2)
                  │   ├── {genome_id}_p1.fasta.gz                  purge_haplotigs curated primary assembly (taking c1 as input)
                  │   ├── {genome_id}_p2.fasta.gz                  purge_haplotigs curated haplotigs (purged out from c1)
                  │   ├── {genome_id}_q2.fasta.gz                  c2 + q2 for future polishing
                  │   ├── {genome_id}_s1.fasta.gz                  2-rounds of scaff10x; scaffolding p1.fasta
                  │   ├── {genome_id}_s2.fasta.gz                  Bionano TGH; hybrid scaffold of 2 enzymes over s1.fasta
                  │   ├── {genome_id}_s3.fasta.gz                  Salsa scaffolding with Arima hiC libraries over s2.fasta
                  │   ├── {genome_id}_t1.fasta.gz                  Arrow polishing over s3 + q2
                  │   ├── {genome_id}_t2.fasta.gz                  1 round of longranger_freebayes polishing over t1.fasta
                  │   └── {genome_id}_t3.fasta.gz                  2nd round of longranger_freebayes polishing over t2.fasta
                  ├── {genome_id}.pri.asm.YYYYMMDD.fasta.gz        Final assembly (primary)
                  └── {genome_id}.alt.asm.YYYYMMDD.fasta.gz        Final assembly (alternate haplotigs)
  ```

#### Detailed intermediate assembly names and rules for v1

| intermediate_name	| full_verbal | description |
|:------------- | :---------- | :-----------|
|c1	| pac_fcnz_hap1	| pac_fcnz_hap1: Pacbio FALCON-Unzip assembly primary contigs |
|c2	| pac_fcnz_hap2	| pac_fcnz_hap2: Pacbio FALCON-Unzip assembly alternate haplotigs |
|p1	| pac_fcnz_hap1_purg_prim	| prim: purge_haplotigs curated primary |
|p2	| pac_fcnz_hap1_purg_alt	| purg: purged haplotigs |
|q2	| pac_fcnz_hap2_pac_fcnz_hap1_purg_alt	| concatinate c2 and q2, with '\|' replaced to '_' |
|s1	| pac_fcnz_hap1_10x_scaff10x	|scaff10x: 2-rounds of scaff10x |
|s2	| pac_fcnz_hap1_10x_scaff10x_bio_tgh	|tgh: bionano TGH; hybrid scaffold of 2 enzymes. *Make sure to include the NOT_SCAFFOLDED leftovers.*|
|s3	| pac_fcnz_hap1_10x_scaff10x_bio_tgh_arim_salsa | arim_salsa: maximum 5-round of Salsa scaffolding from Arima hiC libraries |
|s4	| s3_q2 | intermediate file generated with s3 + q2 |
|t1	| pac_fcnz_hap1_10x_scaff10x_bio_tgh_arim_salsa_arrow	| arrow: arrow polishing with gap filling on s4 |
|t2 |	pac_fcnz_hap1_10x_scaff10x_bio_tgh_arim_salsa_arrow_frb1 |	longranger + freebayes polishing round 1 |
|t3 |	pac_fcnz_hap1_10x_scaff10x_bio_tgh_arim_salsa_arrow_frb2 |	longranger + freebayes polishing round 2 |


### Mitochondrial Assemblies
  ```
  /
  └── species/
      └── {Genus_species}/
          └── {ToLID}/
              └── assembly_MT/
                └── {genome_id}.MT.YYYYMMDD.fasta.gz
  ```
It is accecptable to name the directory `assembly_MT{suffix}`, where the suffix
is an underscore followed by some informative string. This can be useful when
more than 1 mitochondrial assemblies were generated so that they can be easily
differentiated from eachother. Examples of informative strings are the location
or institution that generated the assembly, a version, or a date.
