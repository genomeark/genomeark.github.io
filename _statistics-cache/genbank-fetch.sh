#!/bin/sh

#  Use genbank-fetch.sh to pull the genbank XML and parse out a few fields.
#  Use genbank-fixup.pl to clean up the result and write genbank.map.

if [ -z $NCBI_API_KEY ] ; then
  echo NCBI_API_KEY not set.
  exit
fi

#  Versions:
#    edirect/8.60
#    edirect/10.0
#    edirect/14.5 - doesn't know the -q option.

module load edirect/10.0

if [ ! -e genbank.xml ] ; then
  echo Fetching genbank.xml.

  esearch -db bioproject -q 'PRJNA489243' \
  | \
  elink -db bioproject -target assembly -name bioproject_assembly_all \
  | \
  esummary \
  > genbank.xml
fi

if [ ! -e genbank.xml.map ] ; then
  echo Parsing genbank.xml.

  #  Extract elements 'Genbank', 'AssemblyName' and 'AssemblyType' from all
  #  'DocumentSummary' elements IF it contains a `Synonym` element (which is
  #  where the 'Genbank' element is).

  xtract \
    -input genbank.xml \
    -pattern DocumentSummary -if Synonym -element Genbank AssemblyName AssemblyType \
  | \
  sort -k2,2 \
  > genbank.map.raw
fi

exit 0
