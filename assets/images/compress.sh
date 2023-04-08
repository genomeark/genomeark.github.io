#!/bin/sh
#
#  Recompress .png and large .jpg to small .jpg.
#    sh compress.sh `find . -type f -iname \*.png`
#    sh compress.sh `find . -type f -iname \*.jpg -a -size +100k`
#

mkdir -p original-images

while [ $# -gt 0 ] ; do
  in=$1
  ot=$(echo $1 | sed s/.png/.jpg/)

  if   file $in | grep PNG ; then
    mv $in original-images/
    pngtopnm original-images/$in | cjpeg -optimize -progressive > $ot
    ls -l original-images/$in $ot

  elif file $in | grep JPEG ; then
    mv $in original-images/
    djpeg original-images/$in | cjpeg -optimize -progressive > $ot
    ls -l original-images/$in $ot

  else
    echo 'Failed to decide if input image is PNG or JPEG.'
  fi

  shift
done
