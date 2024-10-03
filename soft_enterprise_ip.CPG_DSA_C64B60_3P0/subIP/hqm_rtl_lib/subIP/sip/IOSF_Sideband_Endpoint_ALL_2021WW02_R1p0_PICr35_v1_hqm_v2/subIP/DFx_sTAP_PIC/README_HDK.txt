###################################################################################################################
## This README is for sourcing and running the HDK commands and turnin to the repo using GK. 
## Note: Wash the unwanted groups and keep only the needed groups as below as HDK env sourcing will not happen 
## if the shell has more than 16 groups
##
## Below commands for HDK Environment.
##
## make set_wash
## setenv MODEL_ROOT $cwd 
## setenv IP_ROOT $cwd 
##
## To source the SIP HDK env
## source /p/hdk/rtl/hdk.rc -cfg sip
##
## This is the command if want to resource the env on the same shell
## source /p/hdk/rtl/hdk.rc -cfg sip -reentrant
##
## tsetup uvm 1.2
##
## To clone the repo and do the push
##
## dteg_clone -ip_name stap -server gar
## Run the script: $MODEL_ROOT/scripts/jtagbfm_version_update to update the JTAG_BFM_VER before running Simulation and Tools
## Example: source scripts/jtagbfm_version_update "/nfs/iind/badithya/disks"
##
## cd <clone repo> 
## git add < all the newly added/modified files along untracked files without logs and target folder> 
## git status   ( this will show now the actual files which are added, modified and renamed) 
## git commit
##
## To clean target directory
## make clean
##
## Below are the basic commands to run with simbuild/FEBE flow commands of HDK  
## To run with PWA folder, please add argument as PWA=<pwafoldername> 
##
## To compile the model with VCS:
## make run_vcs CUST=ADL
## make run_vcs CUST=ADP 
##
## To compile the converged model with VCS:
## make run_vcs_converged CUST=ADL
## make run_vcs_converged CUST=ADP 
##
## To compile the model with VCS with incremental:
## make run_vcs_incr CUST=ADL
## make run_vcs_incr CUST=ADP 
##
## To run the simulation on the default test
## make run_vcs_test CUST=ADL
## make run_vcs_test CUST=ADP
##
## To run the simulation on the default test with FSDB 
## make run_vcs_test_FSDB CUST=ADL
## make run_vcs_test_FSDB CUST=ADP 
##
## To run the simulation any test other than default test
## make run_vcs_test CUST=ADL TESTCASENAME=<testcasename>
## make run_vcs_test CUST=ADP TESTCASENAME=<testcasename>
##
## To run the simulation any test other than default test with FSDB
## make run_vcs_test_FSDB CUST=ADL TESTCASENAME=<testcasename>
## make run_vcs_test_FSDB CUST=ADP TESTCASENAME=<testcasename>
## 
## To run the simulation any test other than default test with GUI
## make run_vcs_test_GUI CUST=ADL TESTCASENAME=<testcasename>
## make run_vcs_test_GUI CUST=ADP TESTCASENAME=<testcasename>
## 
## To run the regressions
## make run_vcs_regress CUST=ADL 
## make run_vcs_regress CUST=ADP 
##
## To run the coverage
## make run_script RUN_SCRIPT="source scripts/get_coverage" CUST=ADL 
## make run_script RUN_SCRIPT="source scripts/get_coverage" CUST=ADP 
##
## To run the swcomp
## make run_script RUN_SCRIPT="source scripts/run_config_swcomp" CUST=ADL 
## make run_script RUN_SCRIPT="source scripts/run_config_swcomp" CUST=ADP 
##
## To run lintra  compile
## make run_lint_comp CUST=ADL
## make run_lint_comp CUST=ADP
## 
## To run lintra elab
## make run_lint_elab CUST=ADL
## make run_lint_elab CUST=ADP
##
## To open Lintra GUI 
## make run_lint_gui CUST=ADL
## make run_lint_gui CUST=ADP
##
## To run Spyglass lintra  compile
## make run_sglint_comp CUST=ADL
## make run_sglint_comp CUST=ADP
## 
## To run Spyglass lintra elab
## make run_sglint_elab CUST=ADL
## make run_sglint_elab CUST=ADP
##
## To open Spyglass Lintra GUI 
## make run_sglint_gui CUST=ADL
## make run_sglint_gui CUST=ADP
##
## To run collage 
## make run_collage CUST=ADL
## make run_collage CUST=ADP
##
## To run Emulation:
## make run_emulation CUST=ADL
## make run_emulation CUST=ADP
##
## FEB Lint Run command 
## make run_febe_lint CUST=ADL
## make run_febe_lint CUST=ADP
##
## DC & FEV Run command 
## make run_dc_fv CUST=ADL
## make run_dc_fv CUST=ADP
##
## FEBE, Lint DC & FEV Run command 
## make run_lint_dc_fv CUST=ADL
## make run_lint_dc_fv CUST=ADP
##
## CDC  Run
## make run_cdc_ADL 
## make run_cdc_ADP
##
## CDC Lint Run
## make run_cdc_lint CUST=ADL
## make run_cdc_lint CUST=ADP
##
## CDC Lint GUI Run
## make run_cdc_lint_gui CUST=ADL
## make run_cdc_lint_gui CUST=ADP
##
## To run Spyglass CDC  compile
## make run_sgcdc_comp CUST=ADL
## make run_sgcdc_comp CUST=ADP
## 
## To run Spyglass cdc test
## make run_sgcdc_test CUST=ADL
## make run_sgcdc_test CUST=ADP
##
## To open Spyglass CDC GUI 
## make run_sgcdc_gui CUST=ADL
## make run_sgcdc_gui CUST=ADP
##
## To open VCLP BUILD
## make run_vclp_build CUST=ADL
## make run_vclp_build CUST=ADP
## 
## To open VCLP test
## make run_vclp_test CUST=ADL
## make run_vclp_test CUST=ADP
##
## In FEBE there is dependency to run each tool
## febe -dut <ip_name> -printdeps
##
## To run ZIRCON  
## source tools/zirconqa/run_zircon
## source tools/zirconqa/run_zircon_ipdashboard
## source tools/zirconqa/run_zircon_socdashboard
## 
## Environment/tool version related DEBUG
## setenv CFG_DEBUG
## ToolConfig.pl -h
## ToolConfig.pl get_tool_path  <tool>
##
## Example:
## =======
## ToolConfig.pl get_tool_path ace

## Open GUI
/p/hdk/rtl/cad/x86-64_linux30/atrenta/spyglass/L2016.06-SP2_Jan23/SPYGLASS_HOME/bin/spyglass &

## Add Gatekeepr commands here
gk : turnin      -c stap  -proj dteg    -s main    -comment "Turnin 0" 

gk : turnininfo  -c stap  -proj dteg    -s main    -short

#Added this line to check IPX release
