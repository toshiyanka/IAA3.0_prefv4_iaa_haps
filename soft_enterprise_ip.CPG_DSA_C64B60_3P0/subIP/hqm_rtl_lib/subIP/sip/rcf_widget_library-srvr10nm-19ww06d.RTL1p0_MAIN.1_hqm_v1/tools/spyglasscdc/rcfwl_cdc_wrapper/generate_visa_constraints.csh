#!/bin/csh
#!/bin/csh
echo "Testing Scrag"

mkdir $TEST_WORK_AREA/visa_constraints

/p/hdk/rtl/cad/x86-64_linux26/intel/VisaIT/4.2.7/bin/visa_gen_cdc_constraints.py -c $MODEL_ROOT/target/GenRTL/hqm_rcfwl/hqm_rcfwl_cdc_wrapper_rtl_lib_VISA_INSERTION/hqm_rcfwl_cdc_wrapper.sig.visa -o $TEST_WORK_AREA/visa_constraints/rcfwl_cdc_wrapper_visa.tcl -m /p/hdk/rtl/cad/x86-64_linux26/intel/VisaIT/4.2.7/etc/VisaModules.xml -e

ls -l $MODEL_ROOT/tools/spyglasscdc/rcfwl_cdc_wrapper/rcfwl_cdc_wrapper_visa.tcl
sleep 10
ls -l $MODEL_ROOT/tools/spyglasscdc/rcfwl_cdc_wrapper/rcfwl_cdc_wrapper_visa.tcl

$SPYGLASS_METHODOLOGY_CDC/scripts/visa_translation_sgcdc.tcl -model rcfwl_cdc_wrapper -o $TEST_WORK_AREA/visa_constraints -top_name hqm_rcfwl_cdc_wrapper

_SPYGLASS_EXE_COMMAND_
echo DONE_WITH_SPYGLASS_EXE_SCRAG_RECIPE
