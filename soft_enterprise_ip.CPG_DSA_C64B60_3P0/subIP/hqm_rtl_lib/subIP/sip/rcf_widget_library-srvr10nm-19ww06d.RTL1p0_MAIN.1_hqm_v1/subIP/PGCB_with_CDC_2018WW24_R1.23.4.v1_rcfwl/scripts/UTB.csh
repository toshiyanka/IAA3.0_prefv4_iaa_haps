#!/bin/csh -f
set modulename = $1
set filename = $2

if (! -d $MODEL_ROOT/tools/ult/utb/$modulename) then
	echo "Error: Please provide a valid module name for ULT!! "
    exit 1
endif

echo "UTB module name: $modulename"

source /p/cse/avc/models/abv/utb/latest/setup

cd $MODEL_ROOT/tools/ult
utb -m $modulename -filter_define DC

if (! -f utb/$modulename/dut_inf/bin/dInfo.pl) then
   	echo "UTB module build failed with compile issues\n"
    exit 1 
endif

if ( ${USER} == "gkpmc_hw" ) then
    set are_files_changed = `/p/cse/avc/models/abv/utb/latest/bin/dut_files_changed -dut_inf_file utb/$modulename/dut_inf/list/dut_build_info.pl` 
    if ( $are_files_changed < 1 ) then
        echo "No file required for module build has changed in this model - skipping UTB run\n" 
        exit 0 
    endif
endif

# User Defined types: 
# 1. If no utb_run specified, run all existing tasks and tests
# 2. If utb_run specified, try to match with an existing task or test 
#       2.a. UTB task prioritized over test
# 3. If an invalid utb_run specified, return Exit Status 1 

if ($filename == "") then 

    set num_subtasks=`ls -al utb/$modulename/tasks | grep -c ^d`
    if ($num_subtasks > 2 ) then 
        echo "UTB: Taskname not specified, running all existing tasks\n"
        make -C utb/$modulename/tasks clean
        make -C utb/$modulename/tasks/ QUIET=1
    endif # complete taskrun

    set num_subtests=`ls -al utb/$modulename/tests | grep -c ^d`
    if ($num_subtests > 2 ) then 
        echo "UTB: Testname not specified, running all existing tests\n"
        make -C utb/$modulename/tests clean
        make -C utb/$modulename/tests/ QUIET=1
    endif # complete testrun

else if(-d  $MODEL_ROOT/tools/ult/utb/$modulename/tasks/$filename) then
    echo "UTB: Taskname: $filename\n"
    make -C utb/$modulename/tasks/$filename clean
    make -C utb/$modulename/tasks/$filename QUIET=1

else if (-d $MODEL_ROOT/tools/ult/utb/$modulename/tests/$filename) then
    echo "UTB: Testname: $filename\n"
    make -C utb/$modulename/tests/$filename clean
    make -C utb/$modulename/tests/$filename QUIET=1 
else 
    echo "$filename is not a valid task or test"
#    echo "Test/Task Status : FAIL"
    exit 1
endif
