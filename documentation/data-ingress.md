---
layout: documentation
title: Genomeark Data Preparation
published: false
---

<!--
NOTE: For testing, set `published:` to `true`. Leave it set to `false` when
      committing changes until we're ready to launch this page.
-->

This is a **DRAFT**. Please send comments to `#data-coord` on Slack.

# Genomeark Data Preparation

All the Genomeark data is stored on AWS S3 in the &ldquo;genomeark&rdquo; bucket.
This bucket is periodically crawled to populate the information on the
[Genomeark website](https://genomeark.github.io).
An S3 bucket can store any arbitrary file, thus Genomeark can (and often does)
store more files than are strictly necessary for data sharing and the website,
e.g., intermediate files generated during the assembly process.
However, the core files that Genomeark stores are the sequencing data and the
assemblies. In order to get your sequencing data and/or assemblies into
Genomeark and ensure your project is represented correctly on the website, you
will need the following:
- an image of your species for the website (if not yet present)
- a Taxon Identifier (TaxID) from the NCBI Taxonomy database
- a Tree of Life Identifier (ToLID) for your specimen(s)
- certain metadata for the metadata.yaml file
- access to the Genomeark AWS S3 bucket
- an understanding of how the S3 bucket is organized
- familiarity with the AWS-CLI
- your data prepared for upload

If you have any questions after reading this guide, please reach out for help.

## A picture for the website

If you are the first to upload data for your species of interest,
congratulations!
To keep the website looking nice, we need a picture of your species.
If you are not the first for your species but you see the entry on the website
is missing an image (a picture of a landscape with a magnifying glass overlaid),
you have an opportunity to be a good citizen (and make your favorite image
famous).

Image requirements:
- JPG (please rename .jpeg to .jpg)
- Square 500x500 px at 72ppi
- Licensable (e.g., under CC BY) or permission for use provided

If you do not have a picture, you can search for one online (e.g., with Google);
with the correct search parameters, only licensable images will be displayed.
Here is an example search for a Siamang (_Symphalangus syndactylus_):
```shell
Genus="Symphalangus"
species="syndactylus"
echo 'https://www.google.com/search?as_st=y&tbm=isch&hl=en&as_q=&as_epq='"${Genus} ${species}"'&as_oq=&as_eq=&imgsz=&imgar=&imgc=&imgcolor=&imgtype=&cr=&as_sitesearch=&safe=active&as_filetype=&tbs=sur%3Acl'
```
Simply copy/paste the resulting link into your browser.

If the image is not square, you can crop it or add a solid color (preferably
black) above and below the image such that it becomes square. If the original
image is not at least 500px wide or at least 72ppi, it is not suitable. Larger
images (made square, if needed) can be scaled down in size and/or resolution to
match 500x500 px at 72ppi. If you need help doing this, please reach out.

Any image you take off the web must be licensable or you must obtain written
permission (e.g., by an email). Examples of valid licenses: public domain, CC0,
CC BY (and variants (e.g., CC BY-SA)), GNU GPL, etc. For CC licenses, NC
(non-commercial) variants are okay; ND (non-derivative) variants are not okay
because we change the size of the image dynamically on the website, which is
technically a derivative. Please note the license type, including the version,
and send that information in when you share the image file. Also note the
auther/artist/copyright holder and the location from which you sourced the
image. Most images come from Wikimedia or flickr. The username of the uploader
is sufficient, but if you can easily track down the actual name of the person,
that is preferred. Please also provide the link to the page with the original
image.

## Taxon Identifier

The NCBI Taxonomy database has a numerical identifier for every species from
which it hosts sequencing data. Most species are already in the database.
However, if yours is not, or if your organism is a hybrid (e.g.,
[between breeds](https://doi.org/10.1038/nbt.4277) or
[between species](https://doi.org/10.1093/gigascience/giaa029))
of cattle), you can
[request a new Taxon identifier](https://ena-docs.readthedocs.io/en/latest/faq/taxonomy_requests.html).

##  Tree of Life Identifier (ToLID) {#tolid}

Data is stored on Genomeark in &ldquo;directories&rdquo;
([why is this quoted?](https://www.ibm.com/topics/object-storage))
using the ToLIDs, so your data cannot be added until you have one for each
discrete individual (or pool of individuals - see more on pools below). Creating
a new ToLID requires an NCBI Taxon Identifier, so create one of these first if
one does not exist for your ogranism. To create a new ToLID, visit the
[ToLID website](https://id.tol.sanger.ac.uk) and follow the instructions. You
will need to create an account. Note that you cannot control the number
associated with your ToLID, they are provided on a first-come/first-serve basis,
beginning with 1.

To create a new ToLID, you will need to provide the scientific name (Genus &amp;
species) of your ogranism, the Taxon ID for your organism, and an internal
identifier. If you have more than one internal idenfier, you may provide
multiple separated by a sensible character (e.g., `/`, `;`, or `,`). If the
organism is named (e.g., &ldquo;Jim&rdquo; the Gorilla), please include this as an
identifier.

### ToLIDs for Hybrids and Pools

Creating a ToLID for a hybrid is usually straightforward once you have a Taxon
ID. Just read the instructions on the
[ToLID website](https://id.tol.sanger.ac.uk) and ask for help if needed. For
pools of individuals (e.g., a population of fruit flies), you may treat the
entire pool as if it were one individual for the purpose of the generating the
ToLID. A common reason for needing to sequence a pool of individuals is to get
enough genetic material from a small oragnism, such as an insect. If you used
multiple pools or a subset of a pool at different time points, each would
require separate ToLIDs. This is different from larger organisms, where samples
taken from a single individual but from different tissues and/or at different
developmental stages all share the same ToLID.

## Other Metadata {#other-metadata}

Some other metadata is required to be added to a `metadata.yaml` file on
Genomeark. There is one such file per species (or cross, etc.) located at
`/species/${Genus}_${species}/metadata.yaml`. These files&rsquo; fields are not
presently standardized, but certain fields are _required_ to ensure populating
the website works correctly. Additional arbitrary fields can be added, and we
strongly encourage adding as much information as possible for your future
convenience when creating BioSamples and submitting reads and assemblies to NCBI
(or INSDC partner).

These `metadata.yaml` files are stored on the S3 bucket, but these are actually
copies from
[a GitHub repository](https://github.com/genomeark/genomeark-metadata) that
stores them and a history of changes. A copy of the version in the GitHub
repository will be shadowed in the Genomeark S3 bucket, thus changes made to
only the version in the repository will eventually be reflected in the S3
bucket. Changes made to only the copy in the S3 bucket will likely be lost.

If a `metadata.yaml` file for your species already exists, please add your
information to a copy of it instead of creating a new one from scratch. You can
share your file via email or Slack or you can make a pull request with your
changes on the GitHub repository.

The following is a template containing the minimum requirements:
```yaml
---
species:
  short_name: cGenSpe
  name: Genus species
  common_name: common
  taxon_id: ####
  order:
    name: Order
  family:
    name: Family
  individuals:
  -
      short_name: cGenSpe1
      subspecies:                       # <-- only needed if applicable
        name: Genus species subspecies  # <-- only needed if applicable
        common_name: common name        # <-- only needed if applicable
        taxon_id: ######                # <-- only needed if applicable
  genome_size: ###########
  genome_size_method: method
```

Note that the `genome_size` must be an integer. Suffixes (e.g., K, Mb, etc.) are
_not_ supported. If you do not know the genome size, try looking it up on
[GoaT](https://goat.genomehubs.org).

The following are good examples you can emulate:
- [gorilla](https://genomeark.s3.amazonaws.com/species/Gorilla_gorilla/metadata.yaml)
- [chimpanzee](https://genomeark.s3.amazonaws.com/species/Pan_troglodytes/metadata.yaml)

Here is a more complete template you can use:
```yaml
---
species:
  short_name: cGenSpe
  name: Genus species
  common_name: common
  taxon_id: ####
  order:
    name: Order
  family:
    name: Family
  individuals:
  -
      short_name: cGenSpe1
      name: name
      strain: strain-name
      subspecies:
        name: Genus species subspecies
        common_name: common name
        taxon_id: ######
      alt_ids:
      - alt1
      - alt2
      sex: male
      description: >
        A longer description;
      provider: Name or inst, other name or inst, yet another name or inst
      father: null
      mother: null
      birth_date: date
      samples:
      -
          biosample_id: biosample
          tissue: tissue-type
          dev_stage: stage
          treatment: treatment
          storage_condition: condition
          collection_date: date
          collected_by: name or inst
          source_id: source_identifier
          lat_lon: coordinates

  -
      short_name: cGenSpe2
      name: name
      biosample_id: biosample
      strain: strain-name
      subspecies:
        name: Genus species subspecies
        common_name: common name
        taxon_id: ######
      alt_ids:
      - alt1
      - alt2
      sex: female
      description: >
        A longer description;
      provider: Name or inst, other name or inst, yet another name or inst
      father: null
      mother: null
      birth_date: date
  -
      short_name: cGenSpe3
      name: name
      biosample_id: biosample
      strain: strain-name
      subspecies:
        name: Genus species subspecies
        common_name: common name
        taxon_id: ######
      alt_ids:
      - alt1
      - alt2
      sex: (fe)male
      description: >
        A longer description;
      provider: Name or inst, other name or inst, yet another name or inst
      father: cGenSpe1
      mother: cGenSpe2
      birth_date: date
  genome_size: ###########
  genome_size_method: null
```

## Write access to the AWS S3 Bucket

In order to get your data onto the AWS S3 bucket, you&rsquo;ll need write
access. Please see our [AWS Credentials Guide](aws-credentials.html) and then
reach out to get access. Generally speaking, we will grant write access to a
supplementary bucket (genomeark-upload). Once you&rsquo;ve uploaded your data
there, notify us so we can move it to the primary bucket (genomeark).

You will be required to upload the data in a specific structure. If a mistake is
made, you can remove the offending file(s) using `aws s3 rm`; however, we urge
caution, especially with the use of the `--recursive` flag (akin to `rm -r` on
Linux). We _strongly_ encourage you to use the `--dryrun` flag to test your
commands before executing them since a  mistake could result in deleting the
data others are uploading too. Please see the section on bucket structure to
learn how your data must be organized.

## Bucket Structure

Please see [this discription](bucket-structure.html)
of the bucket&rsquo;s structure. Please note the following other items:

### PacBio HiFi Data
Please see [these notes](hifi-reads-bam-tags.html)
about kinetics and methylation tags in the `hifi_reads.bam` file.

We also encourage you to upload the subreads BAM files because they are helpful
for calling bases with DeepConsensus later. This is especially important if
DeepConsensus has never been run for your dataset; however, having the option to
re-call bases with an updated version of DeepConsensus in the future is also
nice.

### BAM/CRAM vs FASTQ

Many often provide FASTQs (gzipped) in addition to the BAMs, despite how
wasteful that is on space, for convenience &mdash; especially during the
analysis phase of the project. In some cases, it doesn&rsquo;t matter which
format is provided. However, some data types encode extra information in
BAM/CRAM files that aren&rsquo;t available in FASTQ (e.g., Methylation data in
PacBio HiFi or ONT data). In such cases, we prefer BAM/CRAM and leave it up to
you whether to also include FASTQ format. Please gzip (or more preferrably
bgzip) all FASTQ files.

## AWS Command-line Interface

The only practical way to get large data files and large data sets into the
Genomeark AWS S3 bucket is via the AWS CLI (Command-line Interface). You can
find documentation and other information about the software on
[Amazon&rsquo;s AWS website](https://aws.amazon.com/cli/). For the purposes of
getting your data on Genomeark, you can safely ignore most of the AWS CLI. See
our [brief AWS CLI primer](aws-cli-primer.html) for
the most relevant commands and a few examples. If you need assistance, please
reach out.

## Prepare your data for upload

Technically, you need not do any data preparation. You may copy every needed
file (using `aws s3 cp`) one at a time specifying the location and name of the
file on the S3 bucket. This requires no up-front work, but it results in a
time-consuming, error-prone copy procedure. In most cases, the best approach is
to organize your data in advance and copy it all in one go (using
`aws s3 sync`). This requires some up-front work, but makes the copy procedure
simple. In some cases, it may make more sense to split the data transfer into
multiple sync processes to (a) reduce transfer times via additional
parallelization and/or (b) copy large subsets of the data from disparate
locations. In this documentation, however, we&rsquo;ll assume it will be done
all at once.

The following is a description of the general process and a few miscellaneous
guidelines.

### Data Preparation &amp; Upload Process {#data-prep-upload-process}

These steps outline the data preparation and upload process:

1. Prepare a local directory with copies of your data with filenames and
   subdirectories matching exactly how it is expected to appear on Genomeark.
   - Instead of creating copies of your data, you can create links to your
     existing files using `ln -s`.
   - In most cases, this will mean creating and populating a directory that will
     correspond to the `/species/{Genus}_{species}/{ToLID}/` directory on Genomeark.
   - Do not create empty directories on Genomeark. For example, if you are
     uploading genomic DNA data and no transcriptome data, you should not create
     `/species/{Genus}_{species}/{ToLID}/transcriptomic_data/`.
2. Generate a UUID ([Universally Unique IDentifier](https://en.wikipedia.org/wiki/Universally_unique_identifier))
   and choose a descriptive name for your dataset.
   - You will upload your data to the Genomeark test bucket into `/incoming/`
     in a new directory named with your new UUID and descriptive name, separated
     by `--`. For example, if your UUID were &ldquo;1234&rdquo; (it will be
     longer than that) and your name were &ldquo;T2T-Hippogriff_Upload&rdquo;,
     the directory name would be
     `/incoming/1234--T2T-Hippogriff_Upload/`.
   - Generating a UUID is easy. You can find online tools or run `uuid-gen` on
     the command line.
   - Your descriptive name can be any string (no whitespace), though try to keep
     it short. The following are examples:
     - fCarIgn1_seq_data
     - stonefly_HiFi-ONT
     - JHU-Maize-Verkko-asm
3. Use `aws s3 sync` to mirror the local directory onto the S3 bucket in a
   aforementioned directory (named using the UUID and descriptive name). The
   destination S3-URI will be:
   `s3://genomeark-upload/incoming/1234--T2T-Hippogriff_Upload/`.

Please see this
[Easy Step-by-Step Guide](stepwise-guide.html).

### Misc. Data Preparation Guidelines {#misc-data-prep-guidelines}

Please note the following guidelines:

- It&rsquo;s good practice to have a README file in each major directory
  describing the files and naming scheme and providing a history of the data.
- It&rsquo;s also good practice to have a file (e.g., `files.md5`) with MD5
  sums for all data files. Having a single file with MD5 sums per directory is
  preferred over having a `*.md5` file per file (e.g., file1.fq.gz,
  file1.fq.gz.md5, file2.bam, file2.bam.md5, etc.).
- Please upload (b)gzipped-compressed data whenever applicable,
  especially if the files are large.
  Specifically, all FASTA and FASTQ files should gzipped, preferably bgzipped
  (for convenient indexing; upload the indexes if you generated them).
  Upload BAM or CRAM formatted files instead of SAM. Bgzip VCF files.
- Whenever possible, it&rsquo;s strongly preferred to have uniformity among
  similar files. For example, say you upload 3 cells of PacBio HiFi data.
  Try to name them consistently (e.g., `${movie}.hifi_reads.bam` instead of
  `${movie_1}.hifi_reads.bam`, `cell2.hifi-reads.bam`, &amp;
  `${species}.ccs.bam`). Similarly, if one file has methylation tags, another has
  kinetics tags, and the last has neither, this is confusing. At a minimum, such
  discrepancies should be noted in an accompanying README. Ideally, all files
  would be prepared identically such that they share the same types of
  information; if that means regenerating the HiFi BAM file to add kinetics
  and/or re-calling methylation with Primrose, please consider doing so. These
  examples are for HiFi data, but the same principles apply for other data
  types too.

