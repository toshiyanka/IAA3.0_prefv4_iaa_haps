#!/usr/intel/bin/tcsh
source /p/cct/bin/volsim.dsa.env

echo VOLSIM3_CFG is set to $VOLSIM3_CFG
echo VOLSIM3_BIN is set to $VOLSIM3_BIN

echo "---------------------------------------------------------------------------- ("
echo "-- Preliminary Check:"
echo "--    What environment are we using?"
echo "--"
set split_abs_paths = 's/:\(\/[^\/$]\)/\n    \1/g'
set split_dot_paths = 's/:\./\n    \./g'
env | sort | sed "$split_abs_paths" | sed "$split_dot_paths"
echo "---------------------------------------------------------------------------- )"
echo "---------------------------------------------------------------------------- -"
echo "-- Validate YAML Syntax of Test Headers:"
echo "--"
set cmd="$VOLSIM3_BIN/ip_header_extractor.pl -gating -focus verif/tb/tests -noaudit"
echo running: $cmd
$cmd
