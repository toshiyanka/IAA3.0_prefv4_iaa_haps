######################################################################################################################
######################################################################################################################
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
## To clone the repo and do the push
##
## dteg_clone -ip_name dfxsecure_plugin -server gar
##
## cd <clone repo> 
## git add < all the newly added/modified files along untracked files without logs and target folder> 
## git status   ( this will show now the actual files which are added, modified and renamed) 
## git commit
## git push 
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
## To compile the UVM model with VCS:
## make run_vcs ENV=UVM CUST=ADL
## make run_vcs ENV=UVM CUST=ADP 
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
## To run the regressions
## make run_script RUN_SCRIPT='source scripts/get_coverage' CUST=ADL 
## make run_script RUN_SCRIPT='source scripts/get_coverage' CUST=ADP 
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

## To open Spyglass Lintra GUI 
## make run_sglint_gui CUST=ADL
## make run_sglint_gui CUST=ADP

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
## make run_cdc CUST=ADL
##
## In FEBE there is dependency to run each tool
## febe -dut <ip_name> -printdeps
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
## To run fishtail
## make run_fishtail CUST=ADL
## make run_fishtail CUST=ADP
##
## To run ZIRCON  
## source tools/zirconqa/run_zircon
## source tools/zirconqa/run_zircon_ipdashboard
## source tools/zirconqa/run_zircon_socdashboard
## 
## To run custum script: 
## simbuild -dut dfxsecure_plugin -ace_args /usr/intel/bin/tcsh <realpath of the script> -ace_args- -1c -CUST <CUST> -1c-
## 
## Environment/tool version related DEBUG
## setenv CFG_DEBUG
## ToolConfig.pl -h
## ToolConfig.pl get_tool_path  <tool>
##
## Example:
## =======
## ToolConfig.pl get_tool_path ace

# Power artist run
##febe -dut dfxsecure_plugin -s all +s lintra_build +s .lintra_elab -1c -CUST ADP -1c-
##
##febe -dut dfxsecure_plugin -s all +s .pa_elab -1c -CUST ADP -1c-
##
##febe -dut dfxsecure_plugin -s all +s .pa_elab -pa_elab_args -pa_run -pa_elab_args- -1c -CUST ADP -1c-
##
###simbuild -dut dfxsecure_plugin -ace_args ace -cc -x -fsdb -ace_args- -1c -CUST ADP -1c-
##simbuild -dut dfxsecure_plugin -ace_args ace -ccod -ice -ace_args- -1c -CUST ADP -1c-
##
##febe -dut dfxsecure_plugin -s all +s .pa_avg_power -pa_avg_power_args -test DfxSecurePlugin_DefaultTest -stimTop DfxSecurePlugin_Tbtop.dfxsecure_top_inst -stimFile /nfs/iind/disks/mg_disk0866/skmoolax/DSP/ip-dfxsecure_plugin/pwa/results/tests/DfxSecurePlugin_DefaultTest/Dump.fsdb  -pace tools/power_artist/CNPLP/dfxsecure_plugin/PACE.tech -pa_run -pa_avg_power_args- -1c -CUST ADP -1c-


## Open GUI
/p/hdk/rtl/cad/x86-64_linux30/atrenta/spyglass/L2016.06-SP2_Jan23/SPYGLASS_HOME/bin/spyglass &

## Add Gatekeepr commands here
gk : turnin      -c dfxsecure_plugin    -proj dteg    -s main    -comment "Turnin 0" 


