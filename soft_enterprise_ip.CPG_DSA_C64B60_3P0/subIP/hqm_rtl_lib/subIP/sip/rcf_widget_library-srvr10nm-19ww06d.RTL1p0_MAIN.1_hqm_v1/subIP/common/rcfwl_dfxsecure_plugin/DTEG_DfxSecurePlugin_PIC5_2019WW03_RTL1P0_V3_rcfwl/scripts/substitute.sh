#!/bin/csh -f

##DSP changes in scripts
foreach i ( `find $IP_ROOT/ -name "*.sv"`)
   echo $i
   $IP_ROOT/scripts/name_changes.txt $i tempp1
   \mv tempp1 $i
end
