#!/bin/csh -f

##STAP changes in scripts
foreach i ( `find $IP_ROOT/scripts -name "*.pl"`)
   echo $i
   $IP_ROOT/scripts/name_changes.txt $i tempp1
   \mv tempp1 $i
end
