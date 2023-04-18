---
layout: documentation
title: Genomeark Data Upload &ndash; Step-by-Step Guide
published: false
---

<!--
NOTE: For testing, set `published:` to `true`. Leave it set to `false` when
      committing changes until we're ready to launch this page.
-->

This is a **DRAFT**. Please send comments to `#data-coord` on Slack.

# Easy, Step-by-Step Data Upload Guide

This guide follows the general recipe described in
[these data ingress instructions](data-ingress.html#data-prep-upload-process).

## Step 0 &ndash; Pre-Upload Tasks {#step-0}

Before your data can go on Genomeark, you will need to obtain a Tree of Life
Identifier ([ToLID](https://id.tol.sanger.ac.uk)), as described in the
[data ingress instructions](data-ingress.html#tolid).
You can still upload your data onto the test bucket without one, but we will not
be able to move it to the primary bucket and display it on the website until a
ToLID is assigned. Please start the process before or concurrent with data
upload.

You will also need information for various `README`s
([described here](data-ingress.html#misc-data-prep-guidelines)) and the
`metadata.yaml` file ([described here](data-ingress.html#other-metadata)).

## Step 1 &ndash; Data Organization {#step-1}

This step demonstrates organizing your data, and you must extrapolate to your
specific data and circumstances. The objective here is to create a directory
with contents that can eventually be placed on Genomeark without modification in
the following location: `/species/{Genus}_{species}/{ToLID}/`. For this example,
we will assume you are uploading PacBio HiFi data, ONT simplex data, Arima Hi-C
data, and PacBio Iso-seq (RNA) data. We assume you have not yet generated any
assemblies. We assume all data is from the same individual, and that the RNA
data is generated from brain tissue. Not sure how to organize the data for your
specific project? Please review the documentation on
[bucket structure](bucket-structure.html). 

### Step 1.1 &ndash; Create Directories {#step-1.1}

```shell
mkdir genomeark-upload
cd genomeark-upload
mkdir -p genomic_data/{pacbio_hifi,ont,arima} transcriptomic_data/brain/pacbio
```

### Step 1.2 &ndash; Localize Files {#step-1.2}

Copy (`cp`/`rsync`), move (`mv`), or link (`ln -s`) all data files. We will
demonstrate using linking under the assumption that you have the data available
on your system already in some organization that already works for you.

```shell
# beginning inside the genomeark-upload directory

####################
# PacBio HiFi data #
####################
cd genomic_data/pacbio_hifi
ln -s /path/to/movie-1-name.subreads.bam ./
ln -s /path/to/movie-1-name.subreads.bam.pbi ./
ln -s /path/to/movie-1-name.hifi_reads.bam ./
ln -s /path/to/movie-1-name.hifi_reads.fastq.gz ./
ln -s /path/to/movie-1-name.deepconsensus-1.2.0.fastq.gz ./
# repeat for any other cells
cd ..

############
# ONT data #
############
cd ont
ln -s /path/to/flowcell-1-name.guppy-6.4.6.bam ./
ln -s /path/to/flowcell-1-name.guppy-6.4.6.fastq.gz ./
mkdir -p fast5/flowcell-1-name
cd fast5/flowcell-1-name
for FAST5 in /path/to/fast5s/flowcell-1-name_*.fast5
do
	ln -s ${FAST5} ./
done
cd ../..
# repeat for any other flowcells
cd ..

#############
# Hi-C data # (from Arima Genomics in this example)
#############
cd arima
ln -s /path/to/library-and-lane-1-name_1.fastq.gz ./
ln -s /path/to/library-and-lane-1-name_2.fastq.gz ./
# repeat for any other lanes and/or libraries
cd ..

#######################
# PacBio Iso-Seq data #
#######################
cd ../transcriptomic_data/brain/pacbio
ln -s /path/to/movie-1-name.subreads.bam ./
ln -s /path/to/movie-1-name.subreads.bam.pbi ./
ln -s /path/to/movie-1-name.subreadset.xml ./
ln -s /path/to/isoseq-output-name.bam ./
ln -s /path/to/isoseq-output-name.bam ./
cd ../../..
```

### Step 1.3 &ndash; Provide Checksums {#step-1.3}

Provide MD5 checksums for all data files. If you have them already, copy them
locally, possibly renaming the internal file names if the local filenames to not
match the source names. Please provide one checksum file per datatype
directory. Sometimes it is reasonable to provide separate files for
subdirectories, e.g., for each flowcell&rsquo;s worth of ONT signal data
(usually in FAST5 format, chunked into many files). In this example, that would
be 4 files, one per data type. Possibly one more file for each ONT flowcell if
FAST5s were provided. Use a reasonable filename for the checksums file, e.g.,
`files.md5`. This example will assume you need to generate all the MD5 sums,
but copying existing ones would obviously be faster if you have them.

```shell
# beginning inside the genomeark-upload directory

####################
# PacBio HiFi data #
####################
cd genomic_data/pacbio_hifi
md5sum *.bam *.pbi *.fastq.gz > files.md5
cd ..

############
# ONT data #
############
cd ont
md5sum *.bam *.fastq.gz > files.md5
cd fast5
cd flowcell-1-name
md5sum *.fast5 > files.md5
cd ..
# repeat for any other flowcells
cd ../..

#############
# Hi-C data # (from Arima Genomics in this example)
#############
cd arima
md5sum *.fastq.gz > files.md5
cd ..

#######################
# PacBio Iso-Seq data #
#######################
cd ../transcriptomic_data/brain/pacbio
md5sum *.bam *.pbi *.xml *.fastq.gz > files.md5
cd ../../..
```

### Step 1.4 &ndash; Write READMEs {#step-1.4}

Provide relevant details in `README` files, one (or more as needed) in each
data type directory.

```shell
# beginning inside the genomeark-upload directory

for DATATYPE_DIR in genomic_data/{pacbio_hifi,ont,arima} transcriptomic_data/brain/pacbio
do
	vim ${DATATYPE_DIR}/README
done
```

## Step 2 &ndash; UUID &amp; Descriptive Name {#step-2}

### Step 2.1 &ndash; UUID {#step-2.1}

Generate a UUID. You can search the web to find an online tool to do this for
you. However, it is simple to accomplish on the command line, e.g., with
`uuidgen` from the
[util-linux package](https://github.com/util-linux/util-linux). macOS provides
it&rsquo;s own binary for this purpose. Simply run the following command and
record the result.

```shell
uuidgen
```

Future steps in this guide will assume the UUID you generated is available in
the variable `${UUID}`.

### Step 2.2 &ndash; Descriptive Name {#step-2.2}

Choose a short, descriptive name and record it. Consider using your
institution&rsquo;s abbreviation, ToLID, species name (common or some
abbreviation of the scientific name), specimen/sample name, data type(s), date,
tissue(s), and/or assembly name or method when crafting the descriptive name.
Do _not_ include any personally-identifiable information. Use only alphanumeric
ASCII characters, dashes, periods, and underscores. By definition, that means
_no_ whitespace is permitted. Here are a few examples:
&ldquo;fCarIgn1\_seq\_data&rdquo;, &ldquo;stonefly\_HiFi-ONT&rdquo;, &amp;
&ldquo;JHU-Maize-Verkko-asm&rdquo;. Future steps in this guide will assume your
chosen name is available in the variable `${NAME}`.

## Step 3 &ndash; Upload the Data {#step-3}

### Step 3.1 &ndash; Share `metadata.yaml` {#step-3.1}

You can share the metadata.yaml file you generated via Slack or email. If you
are comfortable with git, you can instead make a pull request with the new
information in the
[genomeark/genomeark-metadata](https://github.com/genomeark/genomeark-metadata)
GitHub repository.

### Step 3.2 &ndash; Sync the Local Directory to the S3 Bucket {#step-3.2}

```shell
# beginning inside the genomeark-upload directory

aws --profile=genomeark s3 sync ./ s3://genomeark-upload/incoming/${UUID}--${NAME}/
```

