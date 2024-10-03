#!/usr/intel/bin/tcsh -f

# According to
#   https://dtspedia.intel.com/GateKeeper/gkutils#JOB_PRE_EXEC
# When this prescript exits with 1, the job will go back into the NB pool
#
# The CWD for this script is the /GATEKEEPER/ subdirectory
#
# If a check fails, add a line like the following:
#   touch host.$HOST.REASON.fail
# replacing 'REASON' with a meaningful token.

echo "-- This JOB_PRE_EXEC script checks the health of the NetBatch host."
echo "--"

echo "---------------------------------------------------------------------------- ("
echo "-- Info about licences"
echo "LM_PROJECT is set to $LM_PROJECT"
set license = synopsys/coretools
set server_list = `/var/licenses/getLf $license`
echo "Licenses for $license are hosted by $server_list"
set servers = ($server_list:as/:/ /)
foreach server ($servers)
    set parts = ($server:as/@/ /)
    echo "Querying $server..."
    echo $parts[1] | netcat $parts[2] 744 | grep coreBuilder
end
echo "---------------------------------------------------------------------------- )"


#(
# Just curious what the environment is.
#
# For legibility
#  - sort variables
#  - split paths into separate lines

echo "---------------------------------------------------------------------------- ("
echo "-- Check #0."
echo "--    What environment are we using?"

set split_abs_paths = 's/:\(\/[^\/$]\)/\n    \1/g'
set split_dot_paths = 's/:\./\n    \./g'
env | sort | sed "$split_abs_paths" | sed "$split_dot_paths"

echo "---------------------------------------------------------------------------- )"
#)
#(
# Occassionally a job lands on a host where 'wash' has been botched.
# The result is that the tool we need to run is not visible.

echo "---------------------------------------------------------------------------- ("
echo "-- Check #1."
echo "--    Was 'wash' was effective?"

set groups      = `groups`
set group_count = `echo $groups | wc -w`
set group_list  = `echo $groups | sed 's/^/ /' | sed 's/ /\n    /g' | sort`

echo -n "Groups:"
echo $groups | sed 's/^/ /' | sed 's/ /\n    /g' | sort
echo ""

if ($group_count > 15) then
    echo "too many groups: $group_count"
    touch $GK_LOG_AREA/host.$HOST.wash.fail
    exit 1
endif
echo "---------------------------------------------------------------------------- )"
#)



echo "---------------------------------------------------------------------------- ("
echo "-- All checks passed!"
touch $GK_LOG_AREA/host.$HOST.pass
echo "---------------------------------------------------------------------------- )"
