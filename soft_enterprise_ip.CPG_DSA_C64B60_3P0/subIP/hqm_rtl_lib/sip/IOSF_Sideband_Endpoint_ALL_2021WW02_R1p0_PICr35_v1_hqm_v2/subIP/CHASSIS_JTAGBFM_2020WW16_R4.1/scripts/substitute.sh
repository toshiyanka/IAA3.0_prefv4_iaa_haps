#!/bin/csh -f

##SCC changes in scripts
##foreach i ( `find $IP_ROOT/verif/tb/JtagBfm -name "*.sv"`)
foreach i ( `find $IP_ROOT/subIP/ip-tap-network/verif/tb -name "TapTop.sv"`)
   echo $i
   $IP_ROOT/scripts/name_changes.txt $i tempp1
   \mv tempp1 $i
end
