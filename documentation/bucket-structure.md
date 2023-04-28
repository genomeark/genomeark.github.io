---
layout: documentation
title: GenomeArk AWS S3 bucket layout and file names
published: true
---

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
  Please see [these notes](hifi-reads-bam-tags.html)
  about kinetics and methylation tags in the `hifi_reads.bam` file.

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
It is acceptable to name the directory `assembly_curated{suffix}`, where the
suffix is an underscore followed by some informative string. This can be useful
when more than 1 assemblies were curated so that they can be easily
easily differentiated from each other. Examples of informative strings are the
location or institution that generated the assembly, a version, or a date.

The following specifications for assembly folders apply to the VGP pipeline version 2.0 assemblies. For more information about version 1.0 assemblies, please see the previous documentation.

### Uncurated Assemblies

#### vgp_standard_2.0 (primary/alternate)

  ```
  └── species
    └── {Genus_species}
        └── {ToLID}
            └── assembly_{pipeline}_{ver}
                ├── evaluation
                │   ├── busco
                │   │   ├── c
                │   │   │   └── {genome_id}_busco_[full_table.tab,missing_buscos.tab,busco_image.png,short_summary.txt]
                │   │   └── s1
                │   │       └── {genome_id}_busco_[full_table.tab,missing_buscos.tab,busco_image.png,short_summary.txt]
                │   ├── genomescope
                │   │   ├── {genome_id}_genomescope__[Linear,Log,Transformed_Linear,Transformed_Log]_Plot.png
                │   │   ├── {genome_id}_genomescope__[Model,Summary].txt
                │   │   └── {genome_id}_genomescope__Model_parameters.tsv
                │   ├── gfastats
                │   │   ├── c
                │   │   │   ├── {genome_id}_alt.tab
                │   │   │   └── {genome_id}_prim.tab
                │   │   ├── s1
                │   │   │   └── {genome_id}_.tab
                │   │   └── s2
                │   │       └── {genome_id}.tab
                │   ├── merqury
                │   │   ├── {genome_id}_png
                │   │   │   ├── output_merqury.assembly_[01,02].spectra-cn.[fl,ln,st].png
                │   │   │   ├── output_merqury.spectra-asm.[fl,ln,st].png
                │   │   │   └── output_merqury.spectra-cn.[fl,ln,st].png
                │   │   ├── {genome_id}_qv
                │   │   │   ├── otput_merqury.assembly_[01,02].tabular
                │   │   │   └── otput_merqury.tabular
                │   │   └── {genome_id}_stats
                │   │       └── output_merqury.completeness.tabular
                │   └── pretext
                │       ├── {genome_id}__s1.bed
                │       ├── {genome_id}__s1.heatmap.[png,pretext]
                │       ├── {genome_id}__s2.bed
                │       └── {genome_id}__s2.heatmap.[png,pretext]
                ├── intermediates
                │   ├── bionano
                │   │   ├── {genome_id}_NGS_contigs_not_scaffolded_NCBI_trimmed.fasta.gz
                │   │   ├── {genome_id}_NGS_contigs_scaffold_NCBI_trimmed.fasta.gz
                │   │   ├── {genome_id}_conflicts.txt
                │   │   ├── {genome_id}_hybrid_scaffold_report.txt
                │   │   └── {genome_id}_s1_AGP.agp
                │   ├── hifiasm
                │   │   ├── {genome_id}_alternate_assembly_contig_graph.gfa.gz
                │   │   ├── {genome_id}_haplotype_resolved_processed_unitig_graph.gfa.gz
                │   │   ├── {genome_id}_haplotype_resolved_raw_unitig_graph.gfa.gz
                │   │   └── {genome_id}_primary_assembly_contig_graph.gfa.gz
                │   ├── {genome_id}_c1.fasta.gz
                │   ├── {genome_id}_c2.fasta.gz
                │   ├── {genome_id}_p1.fasta.gz
                │   ├── {genome_id}_q2.fasta.gz
                │   ├── {genome_id}_s1.fasta.gz
                │   ├── meryl
                │   │   └── {genome_id}_.meryldb.tar.gz
                │   └── yahs
                │       ├── {genome_id}_{genome_id}_s2.agp
                │       └── {genome_id}_{genome_id}_s2.l og
                ├── {genome_id}.standard.alt.YYYYMMDD.fasta.gz
                ├── {genome_id}.standard.pri.YYYYMMDD.fasta.gz
                └── {genome_id}.yml
  ```

#### vgp_HiC_2.0 (hap1/hap2)

  ```
  └── species
    └── {Genus_species}
        └── {ToLID}
            └── assembly_vgp_HiC_2.0
                ├── evaluation
                │   ├── busco
                │   │   └── c
                │   │       └── {genome_id}_HiC__busco_[hap1/hap2]_[full_table.tab,missing_buscos.tab,busco_image.png,short_summary.txt]
                │   ├── genomescope                                                     Folder has same content as described in the primary/alternate guide
                │   ├── gfastats
                │   │   └── c
                │   │       ├── {genome_id}__hap1.tab
                │   │       └── {genome_id}__hap2.tab
                │   ├── hap1
                │   │   ├── busco
                │   │   │   └── s1
                │   │   │       └── {genome_id}__[full_table.tab,missing_buscos.tab,busco_image.png,short_summary.txt]
                │   │   ├── gfastats
                │   │   │   ├── s1
                │   │   │   │   └── {genome_id}.tab
                │   │   │   └── s2
                │   │   │       └── {genome_id}.tab
                │   │   └── pretext
                │   │       ├── {genome_id}_hap1__[s1,s2].bed
                            └── {genome_id}_hap1__[s1,s2]_heatmap.[png,pretext]
                │   ├── hap2
                │   │   ├── busco
                │   │   │   └── s1
                │   │   │       └── {genome_id}__[full_table.tab,missing_buscos.tab,busco_image.png,short_summary.txt]
                │   │   ├── gfastats
                │   │   │   ├── s1
                │   │   │   │   └── {genome_id}.tab
                │   │   │   └── s2
                │   │   │       └── {genome_id}.tab
                │   │   └── pretext
                │   │       ├── {genome_id}_hap2__[s1,s2].bed
                            └── {genome_id}_hap2__[s1,s2]_heatmap.[png,pretext]
                │   ├── merqury
                │   │   ├── {genome_id}_png                                             Folder has same content as described in the primary/alternate guide
                │   │   ├── {genome_id}_qv                                              Folder has same content as described in the primary/alternate guide
                │   │   └── {genome_id}_stats                                           Folder has same content as described in the primary/alternate guide
                │   ├── {genome_id}.HiC.hap1.YYYYMMDD.fasta.gz                          Scaffolded draft assembly of hap1 that goes to curation
                │   ├── {genome_id}.HiC.hap2.YYYYMMDD.fasta.gz                          Scaffolded draft assembly of hap2 that goes to curation
                │   └── {genome_id}.yml                                                 Assembly metadata file that is used for curation submission to Sanger
                └── intermediates
                    ├── hap1
                    │   ├── bionano
                    │   │   ├── {genome_id}_NGS_contigs_scaffold_NCBI_trimmed.fasta.gz
                    │   │   ├── {genome_id}_NGS_contigs_not_scaffolded_NCBI_trimmed.fasta.gz
                    │   │   ├── {genome_id}_conflicts.txt
                    │   │   ├── {genome_id}_hybrid_scaffold_report.txt
                    │   │   └── {genome_id}_s1_AGP.agp
                    │   ├── salsa
                    │   │   └── {genome_id}_{genome_id}_s2.agp
                    │   └── {genome_id}_s1.fasta.gz                                     Hap1 bionano scaffolds and unscaffolded contigs
                    ├── hap2
                    │   ├── bionano
                    │   │   ├── {genome_id}_NGS_contigs_scaffold_NCBI_trimmed.fasta.gz
                    │   │   ├── {genome_id}_NGS_contigs_not_scaffolded_NCBI_trimmed.fasta.gz
                    │   │   ├── {genome_id}_conflicts.txt
                    │   │   ├── {genome_id}_hybrid_scaffold_report.txt
                    │   │   └── {genome_id}_s1_AGP.agp
                    │   ├── salsa
                    │   │   └── {genome_id}_{genome_id}_s2.agp
                    │   └── {genome_id}_s1.fasta.gz                                     Hap2 bionano scaffolds and unscaffolded contigs
                    ├── hifiasm
                    │   ├── {genome_id}__hifiasm.log
                    │   ├── {genome_id}__raw_unitig.gfa.gz
                    │   ├── {genome_id}_hap1_contig_graph.gfa.gz
                    │   └── {genome_id}_hap2_contig_graph.gfa.gz
                    ├── meryl
                    │   └── {genome_id}_.meryldb.tar.gz
                    ├── {genome_id}_hap1_c.fasta.gz                                     Hap1 contigs
                    └── {genome_id}_hap2_c.fasta.gz                                     Hap2 contigs
  ```

#### assembly_vgp_standard_1.0

  ```
  /
  └── species/
      └── {Genus_species}/
          └── {ToLID}/
              └── assembly_{pipeline}_{ver}/     (pipeline: vgp_standard, vgp_HiC, vgp_trio, cambridge, ...)
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


#### Detailed intermediate assembly names and rules for v2

| intermediate_name	| full_verbal | description |
|:------------- | :---------- | :-----------|
|c1	| primary	| hifiasm primary contigs |
|c2	| alternate	| hifiasm alternate contigs |
|hap1	| haplotype 1 | hifiasm haplotype 1 contigs, generated from hifiasm with HiC-phasing |
|hap2	| haplotype 2 | hifiasm haplotype 2 contigs, generated from hifiasm with HiC-phasing |
|p1	| purged primary contigs	| purged primary contigs |
|p2	| purged haplotigs	| haplotigs removed from primary contigs during purging |
|q2	| purged alternate contigs	| p2 concatenated to c2, and then undergone purging |
|s1	| bionano scaffolds	| hybrid scaffolds and un-scaffolded contigs from bionano |
|s2	| Hi-C scaffolds	| Hi-C scaffolds, which can be generated from contigs or from bionano scaffolds |


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
differentiated from each other. Examples of informative strings are the location
or institution that generated the assembly, a version, or a date.
