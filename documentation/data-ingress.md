---
layout: documentation
title: Genomeark Data Ingress
published: false
---

<!--
NOTE: For testing, set `published:` to `true`. Leave it set to `false` when
      committing changes until we're ready to launch this page.
-->

This is a **DRAFT**. Please send comments to `#data-coord` on Slack.

# Genomeark Data Ingress

To get your data added to Genomeark, you need the following:
- your data (obviously)
- an image of your species for the website (if not yet present)
- a Taxon Identifier (TaxID) from the NCBI Taxonomy database
- a Tree of Life Identifier (ToLID) for your specimen(s)
- certain metadata for the metadata.yaml file
- access to the Genomeark AWS S3 bucket
- an understanding of how the S3 bucket is organized

If you have any questions after reading this guide, please reach out for help.

## Your data

All the Genomeark data is stored on AWS S3 in the &ldquo;genomeark&rdquo; bucket.
This bucket is periodically crawled to populate the information on the
[Genomeark website](https://genomeark.github.io).
An S3 bucket can store any arbitrary file, thus Genomeark can (and often does)
store more files than are strictly necessary for data sharing and the website,
e.g., intermediate files generated during the assembly process.
However, the core files that Genomeark stores are the sequencing data and the
assemblies.
It&rsquo;s also good practice to have a README file in each major directory
describing the files and naming scheme and providing a history of the data.

Please upload (b)gzipped-compressed data whenever applicable,
especially if the files are large.
Specifically, all FASTA and FASTQ files should gzipped, preferably bgzipped
(for convenient indexing; upload the indexes if you generated them).
Upload BAM or CRAM formatted files instead of SAM. Bgzip VCF files.

Whenever possible, it&rsquo;s strongly preferred to have uniformity among
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

##  Tree of Life Identifier (ToLID)

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

## Other Metadata

Some other metadata is required to be added to a `metadata.yaml` file on
Genomeark. There is one such file per species (or cross, etc.) located at
`/species/${Genus}_${species}/metadata.yaml`. These files&rsquo; fields are not
presently standardized, but certain fields are _required_ to ensure populating
the website works correctly. Additional arbitrary fields can be added, and we
strongly encourage adding as much information as possible for your future
convenience when creating BioSamples and submitting reads and assemblies to NCBI
(or INSDC partner).

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
access. Please reach out to get access. Generally speaking, we will grant write
(not delete) access to a supplementary bucket (genomeark-test). Once
you&rsquo;ve uploaded your data there, notify us so we can move it to the
primary bucket (genomeark).

You will be required to upload the data in a specific structure. If a mistake is
made, please let us know so we can delete the offending file(s). Please see the
section on bucket structure to learn how your data must be organized.

## Bucket Structure

Please see [this discription](https://genomeark.github.io/structure.html)
of the bucket&rsquo;s structure. Please note the following other items:

### PacBio HiFi Data
Please see [these notes]({{ site.url }}/documentation/hifi-reads.html) about
kinetics and methylation tags in the `hifi_reads.bam` file.

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

