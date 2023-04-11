---
layout: documentation
title: HiFi Reads BAM tags
published: false
---

<!--
NOTE: For testing, set `published:` to `true`. Leave it set to `false` when
      committing changes until we're ready to launch this page.
-->

This is a **DRAFT**. Please send comments to `#data-coord` on Slack.

### HiFi Reads BAM tags

We _strongly_ encourage you to include kinetics tags in your `hifi_reads.bam`
file. This can be done automatically with the correct switch being toggled when
the run is performed.

We also encourage you to call methylation (e.g., with
Primrose), which will create a new BAM file with ML and MM tags.

To avoid
having multiple nearly-identical HiFi bams (i.e., `{movie}.hifi_reads.bam`,
`{movie}.hifi_reads.kinetics.bam`, and `{movie}.hifi_reads.5mC.bam`), you can
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
