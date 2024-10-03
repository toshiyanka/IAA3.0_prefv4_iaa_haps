.PHONY: all clean run_vcs run_vcs_nb run_lintra run_lintra_nb run_collage run_collage_nb
DUT = stap
CUST = ADL
TESTCASENAME = TapTestBypass
RUN_SCRIPT = source scripts/get_coverage

ifndef PWA
   PWA_CMD =
else
   PWA_CMD = -pwa $(PWA)
endif

ifndef SVA_OFF
   SVA_CMD =
else
   SVA_CMD = -vlog_opts "+define+INTEL_SVA_OFF"
endif
## To source the SIP HDK env
set_wash:
	wash -n soc dk1273 soc73 dk10nm hdk10nm srvr10nm siphdk cdftsip cdft

set_root:
	setenv MODEL_ROOT $cwd

clean:
	rm -rf target pwa

set_hdk:
	source /p/hdk/rtl/hdk.rc -cfg sip

set_hdk_pre:
	source /p/hdk/rtl/hdk.rc -cfg sip -reentrant

## To run any script
run_script:
	simbuild -dut $(DUT) -ace_args $(RUN_SCRIPT) -ace_args- -1c -CUST $(CUST) -1c- 

## To compile the model with VCS
run_vcs:
	simbuild -dut $(DUT) -ace_args ace -ccud $(PWA_CMD) $(SVA_CMD) -ace_args- -1c -CUST $(CUST) -1c- 

## To compile the converged model with VCS
run_vcs_converged:
	simbuild -dut $(DUT) -ace_args ace -ccud $(PWA_CMD) $(SVA_CMD) -x -use_model_converged -t TapTestOnlySLVIDCODE_EBEL $(PWA_CMD) -ace_args- -1c -CUST $(CUST) -1c- 

## To compile the model with VCS with incremenal compilation
run_vcs_incr:
	simbuild -dut $(DUT) -ace_args ace -cud $(PWA_CMD) $(SVA_CMD) -ace_args- -1c -CUST $(CUST) -1c- 

## To run the simulation on the default test
run_vcs_test:
	simbuild -dut $(DUT) -ace_args ace -x $(TESTCASENAME) $(PWA_CMD) -ace_args- -1c -CUST $(CUST) -1c-

## To run the simulation on the default test
run_vcs_test_nb:
	simbuild -dut $(DUT) -ace_args ace -x $(TESTCASENAME) $(PWA_CMD) -nb -nbmon -ace_args- -1c -CUST $(CUST) -1c-

## To run the simulation on the default test with FSDB
run_vcs_test_FSDB:
	simbuild -dut $(DUT) -ace_args ace -x $(TESTCASENAME) $(PWA_CMD) -simv_args "+FSDB" -ace_args- -1c -CUST $(CUST) -1c-

## To run the simulation on the default test with VPD
run_vcs_test_VPD:
	simbuild -dut $(DUT) -ace_args ace -x $(TESTCASENAME) $(PWA_CMD) -simv_args "+VPD" -ace_args- -1c -CUST $(CUST) -1c-

## To run the simulation on the default test with GUI
run_vcs_test_GUI:
	simbuild -dut $(DUT) -ace_args ace -x $(TESTCASENAME) $(PWA_CMD) -sd verdi -ace_args- -1c -CUST $(CUST) -1c- &

## To run VERDI
run_verdi:
	simbuild -dut $(DUT) -ace_args ace -ccod -ice -view_debussy -verdi -ace_args- -1c -CUST $(CUST) -1c- &

## To run the simulation on the default test
run_vcs_regress:
	simbuild -dut $(DUT) -ace_args source scripts/run_all_configs -ace_args- -1c -CUST $(CUST) -1c- 

## To run lintra  compile
run_lint_comp:
	simbuild -dut $(DUT) -ace_args ace -ccolt -ASSIGN -mc=$(DUT)_lint_model -pwa pwa_lint -lira_compile_opts -mfcu -lintra_exe_opts ' -r 50514 -r 60088 -r 68094 ' -ace_args- -1c -CUST $(CUST) -1c- 

## To run lintra elab
run_lint_elab:
	simbuild -dut $(DUT) -ace_args ace -sc -t lintra/$(DUT) -pwa pwa_lint -lintra_exe_opts " -r 50514  -r 60088  -r 68094 -r 68099 -r 68000" -ace_args- -1c -CUST $(CUST) -1c- 

## To open lintra gui
run_lint_gui:
	simbuild -dut $(DUT) -ace_args lintra_gui -ace_args- -1c -CUST $(CUST) -1c- 

## To run Spyglass lintra  compile
run_sglint_comp:
	simbuild -dut $(DUT) -1c -CUST $(CUST) -1c- -s all +s sglint_build -sglint_build "-ASSIGN -mc=$(DUT)_lint_model"

## To run Spyglass lintra elab
run_sglint_elab:
	simbuild -dut $(DUT) -1c -CUST $(CUST) -1c- -s all +s sglint_test -sglint_test "-t spyglass_lint/$(DUT)" 

## To open Spyglass lintra gui
run_sglint_gui:
	simbuild -dut $(DUT) -1c -CUST $(CUST) -1c- -s all +s sglint_gui -sglint_gui "-t spyglass_lint/$(DUT) -noepi" 

## To run collage
run_collage:
	simbuild -dut $(DUT) -s all +s collage -1c -CUST $(CUST) -1c- 

## To run Emulation
run_emulation:
	 simbuild -dut $(DUT) -ace "setenv NBCLASS SLES11_EM64T_4G; ace -emul" -1c -CUST $(CUST) -1c-

## To run CDC for ADL 
run_cdc_ADL:
	simbuild -dut $(DUT) -ace_args source tools/cdc/ADL/run_cdc_1274 -ace_args- -1c -CUST ADL -1c- 

## To run CDC for ADP 
run_cdc_ADP:
	simbuild -dut $(DUT) -ace_args source tools/cdc/ADP/run_cdc -ace_args- -1c -CUST ADP -1c- 

## To run CDC Lint 
run_cdc_lint:
	source tools/cdcLint/$(CUST)/run_cdcLint_$(CUST) 

## To run CDC Lint 
run_cdc_lint_gui:
	simbuild -dut $(DUT) -ace_args lintra_gui -ov tools/cdcLint/$(CUST)/stap_violations.xml -ace_args- -1c -CUST $(CUST) -1c- 

## To Run Spyglass CDC Build
run_sgcdc_comp:
	simbuild -dut $(DUT) -1c -CUST $(CUST) -1c- -s all +s sgcdc_build -sgcdc_build "-ASSIGN -mc=sgcdc_stap_model"

#To Run Spyglass CDC test
run_sgcdc_test:
	simbuild -dut $(DUT) -1c -CUST $(CUST) -1c- -s all +s sgcdc_test -sgcdc_test "-t spyglasscdc/$(DUT)/"

#To Run Spyglass CDC test with Debug mode (GUI) 
run_sgcdc_gui:
	simbuild -dut $(DUT) -1c -CUST $(CUST) -1c- -s all +s sgcdc_test -sgcdc_test "-t spyglasscdc/$(DUT)/ -spyglass_debug"

## FEBE Lint command
run_febe_lint:
	febe -dut $(DUT) -s all +s lintra_build +s lintra_elab -1c -CUST $(CUST) -1c- 

##  FEBE DC and FV command
run_dc_fv:
	febe -dut $(DUT) -s all +s build_blocksinfo +s dc +s fv -1c -CUST $(CUST) -1c- 

##  FEBE LINT, DC and FV command
run_lint_dc_fv:
	febe -dut $(DUT) -s all +s build_blocksinfo +s lintra_build +s lintra_elab +s gen_collateral +s dc +s fv -1c -CUST $(CUST) -1c- 

## SPYGLASS CDC command
run_sgcdc:
	simbuild -dut $(DUT)-s all +s sgcdc +s sgcdc_test -1c -CUST $(CUST) -1c- 

## VCLP BUILD COMMAND
run_vclp_build:
	 simbuild -dut $(DUT) -1c -CUST $(CUST) -1c- -s all +s vclp_build -vclp_build "-ASSIGN -mc=stap_vclp_model"

## VCLP TEST COMMAND
run_vclp_test:
	simbuild -dut $(DUT) -1c -CUST $(CUST) -1c- -s all +s vclp_test -vclp_test "-t vclp/$(DUT)"
