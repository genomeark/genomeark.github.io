---
layout: documentation
title: Genomeark AWS CLI Primer
published: false
---

<!--
NOTE: For testing, set `published:` to `true`. Leave it set to `false` when
      committing changes until we're ready to launch this page.
-->

This is a **DRAFT**. Please send comments to `#data-coord` on Slack.

# Genomeark AWS CLI Primer

For complete documentation and information about the AWS CLI, please visit
[Amazon&rsquo;s AWS website](https://aws.amazon.com/cli/). This primer assumes
you have the program installed on the machine where your data resides. If it is
not installed, please install it yourself or reach out to your system
administrator for installation assistance. The following topics are briefly
covered here:

- Command structure
- Man(ual) pages
- Relevant `aws` options
- Most useful `aws s3` commands
  - `ls`
  - `cp`
  - `rm`
  - `mv`
  - `sync`
- Doing a dryrun

After reviewing this primer, please visit
[this easy step-by-step guide](stepwise-guide.html).

## Command Structure

The AWS CLI program is called by the command `aws`, followed by options and a
subcommand:

```shell
aws [options] subcommand ...
```

We&rsquo;ll be using only the `s3` subcommand, which will in turn have
it&rsquo;s own subcommands and options:

```shell
aws [options] s3 subcommand [more options] ...
```

The most commonly used `aws s3` subcommands used for interacting with Genomeark
are the following:

- `ls`   (list contents of a directory)
- `cp`   (copy files)
- `rm`   (remove files)
- `mv`   (move files)
- `sync` (sync two directories)

## Man(ual) Pages

The AWS CLI has extensive documentation [online](https://aws.amazon.com/cli/)
and built into the software as man(ual) pages. You can type &ldquo;help&rdquo;
after any subcommand to trigger displaying the manual:

```shell
# show the man page for the aws command
aws help

# show the man page for the s3 subcommand
aws s3 help

# show the man page for the cp sub-subcommand
#    substitute "cp" with any other s3 subcommand
aws s3 cp help
```

## Relevant `aws` Options

Two options available to the `aws` command are critical: `--no-sign-request`
&amp; `--profile`. These options tell aws what kind of permissions you are using
for this command. It also helps Amazon know who to bill for certain operations,
but you can ignore that for everything we&rsquo;re talking about here.
The `--no-sign-request` flag is used to make your command anonymous. It is safe
to use for operations that download information (e.g., directory listings with
`ls`) or files (e.g., via `cp`, `mv`, or `sync`). Whereas operations that
require write permissions to the bucket (i.e., uploading data) cannot be done
anonymously. In those cases, you&rsquo;ll want to use `--profile` and provide it
with the name of the AWS &ldquo;profile&rdquo; associated with both the
Genomeark bucket and your account. If you followed our
[credentialing instructions](aws-credentials.html),
you would provide the string &ldquo;genomeark&rdquo;: `--profile=genomeark`. If
your Genomeark credientials are set to the &ldquo;default&rdquo; profile in
your `~/.aws/credentials` file, you can omit both of these options and `aws`
will behave as if you provided `--profile=default`. Note that
`--no-sign-request` &amp; `--profile` are mutually exclusive.

## Useful `aws s3` subcommands

The core `aws s3` subcommands for uploading data to Genomeark are `ls` (list
contents of a directory), `cp` (copy files), `mv` (move files), and `sync` (sync
two directories).

### `aws s3 ls`

This command is analagous to using Unix-like operating systems&rsquo; `ls` to
view directories and files in a traditional file system. You can view the
manual for full details (via `aws s3 ls help`), but the most common usage
looks like this:

```shell
aws --no-sign-request s3 ls [--recursive] S3-URI
```

### `aws s3 cp`

This command is analagous to Unix-like operating systems&rsquo; `cp` (or, more
accurately, `scp`) to copy files from one location to another, with either or
both locations being a remote location. By default, it copies only a single
file, but the `--recursive` option can be supplied to copy everything in a
directory, include subdirectories. The general usage looks like this:

```shell
aws --profile=genomeark s3 cp [--recursive] source destination
```

One or both of &ldquo;source&rdquo; and &ldquo;destination&rdquo; must be an
S3-URI, i.e., it cannot copy a local file to another local location, but it can
copy (a) a local file to the S3 bucket, (b) a file in the S3 bucket to a local
location, or (c) a file on the S3 bucket to another location in the S3 bucket.
You can view the manual for full details via `aws s3 cp help`.

### `aws s3 rm`

This command is analagous to Unix-like operating systems&rsquo; `rm` to
remove/delete files. By default, it removes only a single file, but the
`--recursive` option can be supplied to delete everything in a directory,
include subdirectories. You can view the manual for full details via
`aws s3 cp help`. The general usage looks like this:

```shell
aws --profile=genomeark s3 rm [--recursive] S3-URI
```

### `aws s3 mv`

This command is used to move files. While it is roughly analagous to using `mv`
on files in a traditional file system, it is implemented as a copy operation
followed by a remove operation instead of as a rename operation. In a
traditional file system (single physical drive), `mv` operations are very fast
because they are simply updating what amounts to metadata. In S3 object storage,
every byte of the file(s) must be read from disk and written to a new location.
The following are functionally identical:

```shell
# mv
aws --profile=${profile} s3 mv s3://${bucket}/path/to/file1.txt s3://${bucket}/other/path/to/file2.txt

# cp + rm
aws --profile=${profile} s3 cp s3://${bucket}/path/to/file1.txt s3://${bucket}/other/path/to/file2.txt
aws --profile=${profile} s3 rm s3://${bucket}/path/to/file1.txt
```

Accordingly, this command is used similarly to the `aws s3 cp` command:

```shell
aws --profile=genomeark s3 mv [--recursive] source destination
```

One or both of &ldquo;source&rdquo; and &ldquo;destination&rdquo; must be an
S3-URI, i.e., it cannot move a local file to another local location, but it can
move (a) a local file to the S3 bucket (the local copy will be deleted), (b) a
file in the S3 bucket to a local location (the copy on the S3 bucket will be
deleted), or (c) a file on the S3 bucket to another location in the S3 bucket.
You can view the manual for full details via `aws s3 mv help`.

### `aws s3 sync`

This command is analagous to using `rsync` to make a destination directory mimic
a source directory on traditional (possibly remote) file systems. The typical
command looks like this:

```shell
aws --profile=genomeark s3 sync [options] source destination
```

One or both of &ldquo;source&rdquo; and &ldquo;destination&rdquo; must be an
S3-URI, i.e., it cannot sync a local directory to another local location, but it
can sync (a) a local directory to the S3 bucket, (b) a directory on the S3
bucket to a local location, or (c) a directory on the S3 bucket to another
location in the S3 bucket. You can view the manual for full details via
`aws s3 sync help`. Common options are `--include` and `--exclude`. 

This command will probably be the most useful when uploading data to Genomeark
because the entire upload process can be handled by a single command if you
mirror expected directory structure and filenames on your machine. See the
[Easy Step-by-Step Guide](stepwise-guide.html)
for an example.

_caveat emptor_: the `aws s3 sync` `--include` and `--exclude` options to filter
files in the sync operation behave very differently from the same options in
`rsync`. Compare `aws s3 sync help` searching for the
&ldquo;Use of Exclude and Include Filters&rdquo; section with `man rsync`
searching for the &ldquo;FILTER RULES&rdquo; section.

## Doing a Dryrun

Each of these `aws s3` operations can have the `--dryrun` option supplied to
show what _would_ happen had you run the command for real. This can be really
helpful to test that your commands will do what you think, especially when
operating on many files (e.g., with `sync`, `cp --recursive`, or
`rm --recursive`).

```shell
# general case
aws [options] s3 subcommand --dryrun ...

# specific examples
aws --profile=genomeark s3 cp --dryrun myHifi/movie.hifi_reads.bam s3://genomeark-upload/path/to/somewhere/
aws --profile=genomeark s3 rm --dryrun --recursive s3://genomeark-upload/path/to/everythingIuploaded/
aws --profile=genomeark s3 sync --dryrun --exclude='*.sh' allMyStuff/ s3://genomeark-upload/some/path/
```

