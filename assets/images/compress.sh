#!/bin/sh

mkdir -p original-images

while [ $# -gt 0 ] ; do
  in=$1
  ot=$(echo $1 | sed s/.png/.jpg/)

  if   file $in | grep PNG ; then
    mv $in original-images/
    pngtopnm original-images/$in | cjpeg -optimize -progressive > $ot

  elif file $in | grep JPEG ; then
    mv $in original-images/
    djpeg original-images/$in | cjpeg -optimize -progressive > $ot

  else
    echo 'Failed to decide if input image is PNG or JPEG.'
  fi

  shift
done
