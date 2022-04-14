#!/usr/bin/env perl

#  Use genbank-fetch.sh to pull the genbank XML and parse out a few fields.
#  Use genbank-fixup.pl to clean up the result and write genbank.map.

use strict;

my %found;

open(F, "< genbank.map.raw") or die;
open(O, "> genbank.map") or die;
while (<F>) {
    chomp;

    if ($_ =~ m/^(GCA_\d+.\d+)\s+(\S+)\s+(.*)$/) {
        my $acc = $1;  #  Correct as is.
        my $lab = $2;  #  Minor mods needed.
        my $dsc = $3;  #  A mess.

        my $nam = "XXX";  #  Properly formatted VGP individual name
        my $suf = "XXX";  #  Rest of the name label
        my $typ = "XXX";  #  Type of this assembly (pri alt mat pat)

        #  Fix up obvious mistakes in the name.

        if ($lab =~ m/g(adMor.*)/)       { $lab = "fG$1"; }
        if ($lab =~ m/mCalJa(1.2.*)/)    { $lab = "mCalJac$1"; }

        if ($lab =~ m/mRatBN7/)          { next; }
        if ($lab =~ m/UOA_/)             { next; }
        if ($lab =~ m/ZJU/)              { next; }

        if ($lab =~ m/^([a-z][A-Z][a-z][a-z][a-zA-Z][A-Za-z][A-Za-z][0-9])(.*)$/) {
            $nam = $1;  #  matches fAaaAaa or fAaaaAa
            $suf = $2;
        } elsif ($lab =~ m/^[a-z][a-z][A-Z][a-z][a-z][A-Z][a-z][a-z][a-z][0-9]\.[0-9]$/) {
            #  Ignore - eaMarGlac1.1
            next;
        } else {
            printf "WARN: %-15s %-10s %-6s lab %-18s dsc %s\n", $acc, $nam, $typ, $lab, $dsc;
            next;
        }

        #  Use the suffix of the name to decide the type of this assembly.

        if    ($suf =~ m/mat\.[A-Z]/)   { $typ = "mgd"; }
        elsif ($suf =~ m/pat\.[A-Z]/)   { $typ = "mgd"; }

        elsif ($suf =~ m/pri/)          { $typ = "pri"; }
        elsif ($suf =~ m/alt/)          { $typ = "alt"; }

        elsif ($suf =~ m/mat/)          { $typ = "mat"; }
        elsif ($suf =~ m/pat/)          { $typ = "pat"; }

        #  If not decided, use the description.
        #
        #  There seem to only be three forms here:
        #    % cut -f 3 genbank.map.raw | sort | uniq -c
        #    258 alternate-pseudohaplotype
        #     57 haploid
        #    229 haploid (principal pseudohaplotype of diploid)

        if ($typ eq "XXX") {
            if    ($dsc =~ m/principal/)  { $typ = "pri"; }
            elsif ($dsc =~ m/alter/)      { $typ = "alt"; }

            elsif ($dsc =~ m/maternal/)   { $typ = "mat"; }
            elsif ($dsc =~ m/paternal/)   { $typ = "pat"; }

            elsif ($dsc =~ m/haploid/)    { $typ = "pri"; }
        }

        if ($typ eq "XXX") {
            printf "UNKN: %-15s %-10s %-6s lab %-18s dsc %s\n", $acc, $nam, $typ, $lab, $dsc;
        }

        #  Hardcode some ugly ones.

        #if ($lab eq "bTaeGut2.mat.v3")    { $typ = "mat"; }
        #if ($lab eq "bTaeGut2pat")        { $typ = "pat"; }

        #if ($lab eq "bTaeGut2.pri.v2")    { $typ = "pri"; }
        #if ($lab eq "bTaeGut2.p.v1.alt")  { $typ = "alt"; }

        #if ($lab eq "eAstRub1.3")   { $typ = "pri"; }
        #if ($lab eq "fAstCal1.2")   { $typ = "pri"; }
        #if ($lab eq "fBetSpl5.2")   { $typ = "pri"; }
        #if ($lab eq "fSalTru1.1")   { $typ = "pri"; }

        next   if ($lab eq "mRhiFer1_v1.h");
        next   if ($lab eq "mRhiFer1_v1.p");

        #  Emit output or fail.
        if ($typ eq "XXX") {
            printf "FAIL: %-15s %-10s %-6s lab %-18s dsc %s\n", $acc, $nam, $typ, $lab, $dsc;
        } else {
            #printf "PASS: %-15s %-10s %-6s lab %-18s dsc %s\n", $acc, $nam, $typ, $lab, $dsc;
            print O "$acc\t$nam\t$typ\n";
        }

        if (exists($found{"$nam$typ"})) {
            print "DUPL: acc '$acc' lab '$lab'\n";
        }
        $found{"$nam$typ"} = 1;
    }

    else {
        die "Failed to match '$_'\n";
    }
}
close(O);
close(F);
