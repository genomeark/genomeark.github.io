---
layout: documentation
title: Genomeark AWS Credentials
published: true
---

<!--
NOTE: For testing, set `published:` to `true`. Leave it set to `false` when
      committing changes until we're ready to launch this page.
-->

This is a **DRAFT**. Please send comments to `#data-coord` on Slack.

# Genomeark AWS Credentials {#genomeark-aws-creds}

To upload data to an S3 bucket, you need AWS credentials. Unless you already
have credentials for the Genomeark bucket(s), you will need new ones, even if
you already have your own AWS account. In most cases, you will be assigned a
username and furnished with an Access Key ID and associated Secret Access Key.
In most cases, these will grant you access to only the
&ldquo;genomeark-upload&rdquo; bucket via the
[AWS-CLI](https://aws.amazon.com/cli/). Please see our
[AWS-CLI Primer](aws-cli-primer.html) for guidance
in uploading your data to the bucket after you have established your
credentials.

## Obtaining Credentials {#obtaining-creds}

To obtain your credentials, please reach out via email or Slack. Please specify
your preferred username in your initial request. Note, you will not need your
username on a day-to-day basis when working with the AWS-CLI, but you cannot
obtain access keys without one. Unless you are granted access to the online
console, you will not have a password. The credentials you are sent will be a
paired Access Key Identifier and Secret Access Key. You should not share these
with anyone, and you should delete the correspondance you received after you
have noted their values.

### Installing Your Credentials {#installing-creds}

On each machine you intend to use these credentials, you will need to create (or
edit) the `~/.aws/credentials` file.

```shell
# create the directory, if needed
mkdir -p ~/.aws

# create/edit the file
vim ~/.aws/credentials
```

You will need to insert the following lines, replacing the placeholders with the
Access Key ID and Secret Access Key you obtained.
```
[genomeark]
aws_access_key_id = your_access_key_id
aws_secret_access_key = your_super_secret_access_key
```

The value in the square brackets is the name of the &ldquo;profile&rdquo; for
use with the `--profile` option to `aws`. This is useful if you have multiple
AWS accounts and are using various credentials on the same machine. If you
expect to use only these AWS credentials, you can use the name
&ldquo;default&rdquo; and omit the `--profile` option in your `aws` commands.

## Rotating Your Credentials {#rotating-creds}

If you accidentally shared your credentials with someone else or a data breach
involving your machine, HPC, email account where your credentials were not
deleted, etc. occurs, you will need to get a new Access Key ID/Secret Access Key
pair &mdash; just like resetting your password after a hack. We may also ask
you to rotate your credentials if they are too old. Once you have new
credentials, simply replace the old values in `~/.aws/credentials` with the new
ones.

The least technical way to obtain new credentials is to ask for new ones via
email or Slack. The most technical way to obtain new credentials is to use the
AWS CLI. The AWS console can be used instead if you have access to it (you would
need your username and password &ndash; if you do not have a password, this
option is not presently available to you).

### Rotating Credentials Using the CLI {#rotating-creds-cli}

If you choose to rotate your credentials yourself using the AWS CLI,
you should read [this guide](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html#Using_RotateAccessKey).
In short, you&rsquo;ll do the following (assuming your profile and username were
respectively `genomeark` &amp; `billythekid`):
```shell
# Create a new access key
aws --profile=genomeark iam create-access-key --user-name billythekid

# note the new Access Key ID and Secret Access Key 

# delete the old access key
#    replacing your_access_key_id with the Access Key ID
#    of the credential pair you want to delete
aws --profile-genomeark iam delete-access-key --user-name billythekid --access-key-id your_access_key_id

# replace the old credential pair with the new one
vim ~/.aws/credentials
```

## Accessing the AWS Console {#accessing-aws-console}

If you have access to the
[AWS Console for Genomeark](https://vgp-g10k.signin.aws.amazon.com/console),
you can login to it with your username and password. If you do not have a
password, you cannot presently access it. If you would like access to it, you
can request access via email or Slack. For most data uploaders, the only purpose
to gain access to the console would be to rotate your access credentials using
the GUI instead of the CLI. For those who do have access, click
&ldquo;Sign in&rdquo; after entering &ldquo;vgp-g10k&rdquo; in the
&ldquo;Account ID (12 digits) or account alias&rdquo; box, your username in the
&ldquo;IAM user name&rdquo; box, and your password in the &ldquo;Password&rdquo;
box.

<img id="aws-console-login-img" src="/assets/documentation/aws-console-login.png" alt="Screenshot of the AWS Console login screen" width=242 height=398>

