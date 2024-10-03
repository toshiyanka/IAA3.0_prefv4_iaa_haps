#!/bin/csh -f

set SRC=$IP_ROOT/results/DC/sbendpoint/syn/outputs/sbendpoint.syn_final.vg
set DST=$MODEL_ROOT
echo "Copying $SRC to $DST"
set CP=/bin/cp
$CP $SRC $DST
