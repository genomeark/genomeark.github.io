---
layout: documentation
title: HiFi Reads BAM tags
published: true
---

This is a **DRAFT**. Please send comments to `#data-coord` on Slack.

# HiFi Reads BAM tags

We _strongly_ encourage you to include kinetics tags in your `hifi_reads.bam`
file. This can be done automatically with the correct switch being toggled when
the run is performed. The purpose of retaining the kinetics tags is to enable
calling methylation in the future. Accordingly, we also encourage you to call
methylation (e.g., with Primrose), which will create a new BAM file with ML and
MM tags. If your core is willing and able to call methylation for you, it can be
done automatically with the correct run setup in SMRT Link. In such a case, we
recommend toggling the switch to keep the kinetics tags in the resultant BAM
file. In this situation, the final BAM file will have _both_ kinetics tags and
methylation tags. Why keep the kinetics tags in the final BAM file if you
already have methylation tags? If some future method (i.e., an update to
Primrose or a new tool) improves the methylation calling, you will have the
option to re-call methylation if you retained the kinetics tags.

From [PacBio's file format documentation](https://pacbiofileformats.readthedocs.io/en/12.0/),
you can learn more about
[kinetics tags](https://pacbiofileformats.readthedocs.io/en/12.0/BAM.html#use-of-read-tags-for-hifi-per-read-base-kinetic-information)
and [methylation tags](https://pacbiofileformats.readthedocs.io/en/12.0/BAM.html#use-of-read-tags-for-per-read-base-base-modifications)
for HiFi reads. In the
[SMRT Link User Guide (PDF)](https://www.pacb.com/wp-content/uploads/SMRT_Link_User_Guide_v11.1.pdf)
(v11.1 from Nov. 2022 is the most recent at the time of this writing), you can
find information about how to configure a run to include kinetics tags in the
HiFi BAM, call methylation with Primrose, and retain kinetics tags from the
original HiFi BAM in the resulting HiFi BAM with methylation information.

Depending on your setup and whether you or your core ran `ccs` and/or
`Primrose`, it is possible that you will have multiple nearly-identical HiFi
BAMs, differing only by which tags are present (e.g., `{movie}.hifi_reads.bam`,
`{movie}.hifi_reads.with-kinetics.bam`, and `{movie}.hifi_reads.5mC.bam`).
Assuming your final HiFi BAM has both kinetics and methylation tags, you can
save space by deleting the other variants with (a) no kinetics or methylation
tags, (b) only kinetics tags, or (c) only methylation tags.

Whatever you do, please document it in the README.

## Examples

### Least Efficient Process

Here is an example of how to use the most disk space and take the most time to
get all the tags (i.e., what not to do, if possible):
```shell
# 1. do the sequencing run w/o the toggle activated to keep the kinetics tags
# in the hifi bam. For most people, this step is done by the sequencing core.
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
# {movie}.hifi_reads.bam                 # <-- no tags
# {movie}.hifi_reads.with-kinetics.bam   # <-- kinetics tags only
# {movie}.hifi_reads.5mC.bam             # <-- methylation tags only
```

### More Efficient Process

Instead, you could do the following:
```shell
# 1. Do the sequencing run with the toggle activated to keep the kinetics tags
# in the hifi bam (effectively merges steps #1 & #2 above into a single step on
# the instrument or other connected computational resource). For most people,
# this step is done by the sequencing core.
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

This assumes your core is (a) willing to configure the run to add the kinetics
to the HiFi BAM (increases file size, but not computational load) and (b)
unwilling/unable to run Primrose for you on the instrument or other connected
computational resource (note that being unwilling to do this is probably a
computational or other resource constraint, not unhelpfulness). If your core is
able to call methylation (via Primrose) for you, ask them to configure the run
to keep the kinetics tags in the Primrose output BAM. The commands run by SMRT
Link &ldquo;under the hood&rdquo; will match steps #1 &amp; #2 in the provided
example; thus, having your core call methylation for you is not more
computationally efficient than you doing it yourself, but it is a lot more
convenient if you have the option. Note that they might still provide you with
two HiFi BAMs (i.e., one with kinetics tags and another with both kinetics tags
and methylation tags), but you can delete the unneeded version.

## Which tags do my files have?

&ldquo;Too late! My core already finished the run and sent me the files.&rdquo;
If you&rsquo;re wondering which tags are in your HiFi BAM file(s), you can check
with `samtools`. You can usually see which commands were run in the BAM header
via `@PG` tags. The most definitive way to identify which tags your file has is
by looking at the individual reads. If you find you are missing desired
information that you cannot generate yourself from the existing data, you can
always ask your core if they still have the needed prerequisites from your
sequencing run. You might get lucky!

### Checking the BAM Header

You can check the BAM header via the following command:
```shell
samtools head some_file.bam
```
Search for the `@PG` header(s), usually found near the end. Look for the `ccs`
command and check whether the `--hifi-kinetics` or `--all-kinetics` flags were
supplied; if so, your file probably has kinetics tags (unless methylation was
also called and the kinetics tags were not retained in that step). To determine
if methylation was called, look for the `primrose` command. The
`--keep-kinetics` flag will tell you that the kinetics tags were retained
alonside the methylation tags.

### Checking the Reads

The most definitive way to determine which tags your file has is by checking
the actual reads. We recommend looking at a subset of this output to avoid
getting many gigabytes worth of data sent to your output file or the screen. It
can also be helpful to replace tabs with newlines to avoid side-scrolling
through long columns.
```shell
samtools view some_file.bam | head -n 1 | tr '\t' '\n' | less -S
```
Search for the `MM` and `ML` tags to determine if you have methylation
information. To determine whether you have kinetics information, search for
either of the following tag sets: (a) `pw` and `ip` for single-stranded reads or
(b) `fi`, `ri`, `fp`, and `rp` otherwise.

## Misc. Notes

All this information applies to HiFi sequencing in the Sequel II era. Things may
be different for HiFi reads generated from a Revio instrument. Consider the
principles underlying the discussion on this page and consult with your
sequencing provider during the planning stage of your project.

