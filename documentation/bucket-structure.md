---
layout: default
title: GenomeArk AWS S3 bucket layout and file names
permalink: structure.html
published: false
---

<!--
NOTE: For testing, set `published:` to `true`. Leave it set to `false` when
      committing changes until we're ready to launch this page.
-->

This is a *DRAFT*. Please send comments to `#data-coord` on Slack.

AWS S3 is "object storage" and does not contain hierarchical directories or
folders like traditional file systems. However, the structure will be discussed
as if the data will be organized in directories for convenience.

The structure is based on
[this specification](https://github.com/VGP/vgp-assembly/blob/master/DNAnexus_and_AWS_data_structure.md),
with changes reflecting subsequent discussions and new data types. The following
is how the file tree looked before:
```
/
└── species/
    └── {Genus_species}/
        └── {ToLID}/
            ├── assembly_{name1}/   # ---------------------------------------------------------
            ├── assembly_{name2}/   # <-- zero or more assemblies, each in their own directory
            ├── assembly_{name3}/   # ---------------------------------------------------------
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

We will ignore the `assembly_*` directories here; refer to the previous
specification if needed. Not all data types are shown, especially under
`genomic_data`, but the pattern is visible. Each data type is named after the
company that generated it. This has changed slightly since multiple companies
are generating multiple types of data. Try not to let the inconsistency get to
you. Each directory will now be described in a bulletted list, with indentation
level as a reflection of directory depth. If you have a data type not specified,
please reach out for a discussion on naming.



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
                      ├── {movie}.hifi_reads.5mC.bam   <- what's this??
                      ├── {movie}.deepconsensus.bam
                      ├── README
                      └── files.md5
  ```
  We _strongly_ encourage you to include kinetics tags in your `hifi_reads.bam`
  file. This can be done automatically with the correct switch being toggled when
  the run is performed.

  We also encourage you to call methylation (e.g., with
  Primrose), which will create a new BAM file with ML and MM tags.

  To avoid
  having multiple nearly-identical HiFi bams (i.e., `{movie}.hifi_reads.bam`,
  `{movie}.hifi_reads.kinetics.bam`, and `{movie}.hifi_reads.5mC.bam`), you
  have the kinetics tags automatically added to `{movie}.hifi_reads.bam` (as
  mentioned previously) and carry them over into the bam that has the
  methylation tags. You could then remove the version(s) without all the
  information.

  Whatever you do, please document it in the README.

  Example of how to use the most disk space and take the most time to get all
  the tags (i.e., what not to do, if possible):
  ```shell
  # 1. do the sequencing run w/o the toggle activated to keep the
  # kinetics tags in the hifi bam.
  > ls
    # {movie}.subreads.bam
    # {movie}.subreads.bam.pbi
    # {movie}.hifi_reads.bam              # <-- no kinetics tags!
    # and some other files

  # 2. Re-run CCS to include kinetics tags
  > ccs --hifi-kinetics [other-options] {movie}.subreads.bam {movie}.hifi_reads.with-kinetics.bam
  > ls
    # {movie}.subreads.bam
    # {movie}.subreads.bam.pbi
    # {movie}.hifi_reads.bam
    # {movie}.hifi_reads.with-kinetics.bam # <-- new! Has kinetics tags
    # and some other files
  
  # 3. Run Primrose
  > primrose {movie}.hifi_reads.with-kinetics.bam {movie}.hifi_reads.5mC.bam
  > ls
    # {movie}.subreads.bam
    # {movie}.subreads.bam.pbi
    # {movie}.hifi_reads.bam
    # {movie}.hifi_reads.with-kinetics.bam
    # {movie}.hifi_reads.5mC.bam           # <-- new! Has methylation tags, but no kinetics tags
    # and some other files
  
  # 4. Observe that the following files are identical except for which tags are/aren't present:
  # {movie}.hifi_reads.bam
  # {movie}.hifi_reads.with-kinetics.bam
  # {movie}.hifi_reads.5mC.bam
  ```
  Instead, you could do the following:
  ```shell
  # 1. Do the sequencing run with the toggle activated to keep the
  # kinetics tags in the hifi bam (effectively causes step #2 above
  # to be run instead of omitting the --hifi-kinetics flag.
  > ls
    # {movie}.subreads.bam
    # {movie}.subreads.bam.pbi
    # {movie}.hifi_reads.bam             # <-- w/ kinetics tags this time!
    # and some other files

  # 2. Run primrose, passing through the kinetics tags
  > primrose --keep-kinetics {movie}.hifi_reads.with-kinetics.bam {movie}.hifi_reads.5mC.bam
  > ls
    # {movie}.subreads.bam
    # {movie}.subreads.bam.pbi
    # {movie}.hifi_reads.bam             # <-- Has kinetics tags
    # {movie}.hifi_reads.5mC.bam         # <-- new! Has methylation and kinetics tags
    # and some other files

  # 3. Remove version w/o all tags, possibly renaming the final file
  > rm {movie}.hifi_reads.bam
  # and/or
  > mv {movie}.hifi_reads.5mC.bam {movie}.hifi_reads.bam
  > ls
    # {movie}.subreads.bam
    # {movie}.subreads.bam.pbi
    # {movie}.hifi_reads[.5mC].bam     # <-- Has methylation and kinetics tags
    # and some other files

  # 4. Record what tags are available in each file in the README
  > vim README
  ```
  Many often provide fastq (gzipped) in addition to the BAMs, despite how
  wasteful that is on space, for convenience - especially during the
  analysis phase of the project.
  Keeping the subreads BAM files is helpful for calling bases with DeepConsensus
  later, especially if it hasn't already been done.








### Simplex and/or duplex with any pore or chemistry from Oxford Nanopore Technologies

  ONT data can be tricky to keep organized because there is such variation
  between runs, depending on choice of machine, pore, library prep, chemistry,
  etc. Most of this information will just be metadata that you should include in
  a README. You are encouraged to call methylation too, please note in the
  README what is and isn't available in each file. Keeping the fast5s is
  also encouraged for future re-calling of bases and/or methylation.
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
                      ├── {runID}_S1_L001_I1_001.fastq.gz   <- what's this?
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


