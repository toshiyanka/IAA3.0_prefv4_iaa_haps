#!/bin/csh -f

########################
# $1 -> SOC_variats
# $2 -> bits
# $3 -> command line
########################

echo HDK ENV SETUP ...
wash -n sip soc dk1273 soc73 dk10nm hdk10nm siphdk
source /p/hdk/rtl/hdk.rc -cfg sip -reentrant

unsetenv NB_WASH_GROUPS NB_WASH_ENABLED
## GK overrides of NB or other ENV after sourcing env ##
__NB_SETUP__

echo $3
$3
if ($status) then
       echo "wrapper run failed L: $3"
        exit 1
endif
