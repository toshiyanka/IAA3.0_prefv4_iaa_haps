#################################################################################################################
##################################################################################################################
## This README is for sourcing and running the HDK commands and turnin to the repo using GK. 
## Note: Wash the unwanted groups and keep only the needed groups as below as HDK env sourcing will not happen 
## if the shell has more than 16 groups
##  Revision: DTEG_DFx_Secure_Plugin_PIC3_2017WW02_RTL1P0_V2
##
## Below commands for HDK Environment.
##
## wash -n dfxsip sip soc dk1273 soc73 dk10nm hdk10nm siphdk cdft cdftsip
##
## To source the SIP HDK env
## source /p/hdk/rtl/hdk.rc -cfg sip 
##
## This is the command if want to resource the env on the same shell
## source /p/hdk/rtl/hdk.rc -cfg sip -reentrant
##
## To clone the repo and do the turnin using GK
##
## git clone $GIT_REPOS/<PROJECT>/<IP> (respective dfx IPs) 
##
## For example : 
##
## git clone $GIT_REPOS/dfxsip/ip-dfxsecure_plugin (respective dfx IPs) 
## setenv MODEL_ROOT $cwd
##
## cd <clone repo> 
## git add < all the newly added/modified files along untracked files without logs and target folder> 
## git status   ( this will show now the actual files which are added, modified and renamed) 
## git commit 
##
## turnin -proj dfxsip -c ip -s dfxsecure_plugin -comments "Enabling Gatekeeper on the HDK migrated DFx dfxsecure_plugin repo"
##
## turnininfo -short <turnin ID>  ( to see the status of the GK turnin) 
##
## Below are the basic commands to run with simbuild/FEBE flow commands of HDK  
##
## To compile the model with VCS: 
## simbuild -dut dfxsecure_plugin -ace_args ace -cc -ace_args- -1c -CUST TGL -1c-
## simbuild -dut dfxsecure_plugin -ace_args ace -cc -ace_args- -1c -CUST TGPLP -1c-
##
## To run the simulation on the default test
## simbuild -dut dfxsecure_plugin -ace_args ace -x -ace_args- -1c -CUST TGL -1c-
## simbuild -dut dfxsecure_plugin -ace_args ace -x -ace_args- -1c -CUST TGPLP -1c-
##
## To run the simulation any test other than default test
## simbuild -dut dfxsecure_plugin -ace_args ace -x -t <testcasename> -ace_args- -1c -CUST TGL -1c-
## simbuild -dut dfxsecure_plugin -ace_args ace -x -t <testcasename> -ace_args- -1c -CUST TGPLP -1c-
##
## To run the test case with FSDB
## simbuild -dut dfxsecure_plugin -ace_args ace -x -t <testcasename> -simv_args "+FSDB" -ace_args- -1c -CUST TGL -1c-
## simbuild -dut dfxsecure_plugin -ace_args ace -x -t <testcasename> -simv_args "+FSDB" -ace_args- -1c -CUST TGPLP -1c-
##
## To run lintra  compile
## simbuild -dut dfxsecure_plugin -ace_args ace -ccolt -ASSIGN -mc=dfxsecure_plugin_lint_model -pwa pwa_lint -lira_compile_opts -mfcu -lintra_exe_opts ' -r 50514 -r 60088 -r 68094 ' -ace_args- -1c -CUST TGL -1c-
## simbuild -dut dfxsecure_plugin -ace_args ace -ccolt -ASSIGN -mc=dfxsecure_plugin_lint_model -pwa pwa_lint -lira_compile_opts -mfcu -lintra_exe_opts ' -r 50514 -r 60088 -r 68094 ' -ace_args- -1c -CUST TGPLP -1c-
## To run lintra elab
## simbuild -dut dfxsecure_plugin -ace_args ace -sc -t lintra/dfxsecure_plugin -pwa pwa_lint -lintra_exe_opts " -r 50514  -r 60088  -r 68094 -r 68099 -r 68000" -ace_args- -1c -CUST TGL -1c-
## simbuild -dut dfxsecure_plugin -ace_args ace -sc -t lintra/dfxsecure_plugin -pwa pwa_lint -lintra_exe_opts " -r 50514  -r 60088  -r 68094 -r 68099 -r 68000" -ace_args- -1c -CUST TGPLP -1c-
##
# To open Lintra GUI 
## simbuild -dut dfxsecure_plugin -ace_args lintra_gui -ace_args- -1c -CUST TGL -1c-
## simbuild -dut dfxsecure_plugin -ace_args lintra_gui -ace_args- -1c -CUST TGPLP -1c-
#
#
## To run collage 
## simbuild -dut dfxsecure_plugin -s all +s collage -1c -CUST TGL -1c-
## simbuild -dut dfxsecure_plugin -s all +s collage -1c -CUST TGPLP -1c-
##
## To run Emulation:
## simbuild -dut dfxsecure_plugin -ace "setenv NBCLASS SLES11_EM64T_4G; ace -emul" -1c -CUST TGL -1c-
##
## To run CDC
## simbuild -dut dfxsecure_plugin -ace_args source $MODEL_ROOT/tools/cdc/TGL/run_cdc_1274 -ace_args- -1c -CUST TGL -1c-
##
## To run febe for running the RDT flow tools like ( DC, FEV)
## febe -dut dfxsecure_plugin -flow ip_turnin  -1c -CUST TGL -1c- 
## febe -dut dfxsecure_plugin -flow ip_turnin  -1c -CUST TGPLP -1c- 
##
##
## FEBE command to run specific tool DC/FEV/Caliber etc..
## This needs simbuild to be run one time & run lintra_build  lintra_elab , In case of LP/DFT sypglass LP/DFT also has to be run  
## febe -dut dfxsecure_plugin -s all +s <tool> -1c -CUST <CUST> -1c- 
## 
## Initialization of FEBE setup 
## febe -dut dfxsecure_plugin -s all +s build_blocksinfo +s lintra_build +s lintra_elab -1c -CUST TGL -1c-
## febe -dut dfxsecure_plugin -s all +s build_blocksinfo +s lintra_build +s lintra_elab -1c -CUST TGPLP -1c-
## 
## DC & FEV Run command 
## febe -dut dfxsecure_plugin -s all +s build_blocksinfo +s dc +s fv -1c -CUST TGL -1c-
## febe -dut dfxsecure_plugin -s all +s build_blocksinfo +s dc +s fv -1c -CUST TGPLP -1c-
##
## In FEBE there is dependency to run each tool
## febe -dut <ip_name> -printdeps
##
## To run XRPOP (XPROP enabled by default) 
## simbuild -dut dfxsecure_plugin -ace_args ace -cc -x -ace_args- -1c -CUST <CUST> -1c-
## 
## To run CDC  
## source tools/cdc/run_cdc.csh
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
##febe -dut dfxsecure_plugin -s all +s lintra_build +s .lintra_elab -1c -CUST TGPLP -1c-
##
##febe -dut dfxsecure_plugin -s all +s .pa_elab -1c -CUST TGPLP -1c-
##
##febe -dut dfxsecure_plugin -s all +s .pa_elab -pa_elab_args -pa_run -pa_elab_args- -1c -CUST TGPLP -1c-
##
###simbuild -dut dfxsecure_plugin -ace_args ace -cc -x -fsdb -ace_args- -1c -CUST TGPLP -1c-
##simbuild -dut dfxsecure_plugin -ace_args ace -ccod -ice -ace_args- -1c -CUST TGPLP -1c-
##
##febe -dut dfxsecure_plugin -s all +s .pa_avg_power -pa_avg_power_args -test DfxSecurePlugin_DefaultTest -stimTop DfxSecurePlugin_Tbtop.dfxsecure_top_inst -stimFile /nfs/iind/disks/mg_disk0866/skmoolax/DSP/ip-dfxsecure_plugin/pwa/results/tests/DfxSecurePlugin_DefaultTest/Dump.fsdb  -pace tools/power_artist/CNPLP/dfxsecure_plugin/PACE.tech -pa_run -pa_avg_power_args- -1c -CUST TGPLP -1c-

## Open GUI
/p/hdk/rtl/cad/x86-64_linux30/atrenta/spyglass/L2016.06-SP2_Jan23/SPYGLASS_HOME/bin/spyglass &
##################################################################################################################
##################################################################################################################
# To open a Verdi FSDB
#
simbuild -dut cltapc -ace_args ace -ccod -ice -view_debussy -verdi -ace_args- -1c CUST <CUST> -1c-
