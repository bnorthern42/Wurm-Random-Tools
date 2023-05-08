#!/bin/bash
# Only works with newer dump files
cat $1 | sed -e '1,6d'| cut -d ':' -f1,2 --output-delimiter='' | awk  'BEGIN {print "Affinities Count, High, Low, Skill"} {printf "%.1d, %0.6f, %0.6f", $(NF), $(NF-1), $(NF-2)} {$(NF)=$(NF-2)=$(NF-1)=""; printf ", %-1s\n", $0}' | mlr --c2j --jlistwrap cat $xargs
