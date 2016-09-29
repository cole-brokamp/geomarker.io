#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

# create temp directory
tmp_dir=`mktemp -d 2>/dev/null || mktemp -d -t 'mytmpdir'`

# deletes the temp directory
function cleanup {
  rm -rf "$tmp_dir"
}

# register the cleanup function to be called on the EXIT signal
trap cleanup EXIT

fl_name=${1%.*}
echo $fl_name

ffmpeg -i $1 -r 2 $tmp_dir/image.%05d.png &&
  convert -loop 0 -delay 30 $tmp_dir/* ${fl_name}.gif &&
  convert -geometry 800x ${fl_name}.gif ${fl_name}.gif &&
  convert -fuzz 10% -layers Optimize ${fl_name}.gif ${fl_name}.gif &&
  convert ${fl_name}.gif -shave 1x1 -bordercolor black -border 1 ${fl_name}.gif
