##################################################################################################################
##################################################################################################################
## This README is for sourcing and running the HDK commands and turnin to the repo using GK.                     # 
## Note: Wash the unwanted groups and keep only the needed groups as below as HDK env sourcing will not happen   #
## if the shell has more than 16 groups                                                                          #
##  Revision:  
##  DFx_sTAP_PIC3_2016WW28_RTL1P0_V1
##
## Below commands for HDK Environment.
##
## wash -n dfxsip sip soc dk1273 soc73 dk10nm hdk10nm siphdk cdftsip cdft
##
## To source the SIP HDK env
## source /p/hdk/rtl/hdk.rc -cfg sip 
## setenv MODEL_ROOT $cwd
## This is the command if want to resource the env on the same shell
## source /p/hdk/rtl/hdk.rc -cfg sip -reentrant
##
## git add < all the newly added/modified files along untracked files without logs and target folder> 
## git status   ( this will show now the actual files which are added, modified and renamed) 
## git commit 
##
## turnin -proj dfxsip -c ip -s <stepping>  -comments "user comments"
##
## For example: to turnin the changes to stap IP command is follows: 
##
## turnin -proj dfxsip -c ip -s stap -comments "Enabling Gatekeeper on the HDK migrated DFx stap repo"
#
#====================
## Secure-Git turnin command (Kepp & symble at the end0
#     perl dteg_secureturnin.pl -ip_name stap --comment 'Write your comment here' &
##
## turnininfo -short <turnin ID>  ( to see the status of the GK turnin) 
##
## Below are the basic commands to run with simbuild/FEBE flow commands of HDK  
##
## To compile the model with VCS: 
   simbuild -dut stap -ace_args ace -cc -ace_args- -1c -CUST <CUST_NAME> -1c-
## simbuild -dut stap -ace_args ace -cc -ace_args- -1c -CUST TGL -1c-
## simbuild -dut stap -ace_args ace -cc -ace_args- -1c -CUST TGPLP -1c-
##
## To run the simulation on the default test
   simbuild -dut stap -ace_args ace -x -ace_args- -1c -CUST <CUST_NAME> -1c-
## simbuild -dut stap -ace_args ace -x -ace_args- -1c -CUST TGL -1c-
## simbuild -dut stap -ace_args ace -x -ace_args- -1c -CUST TGPLP -1c-
##
## To run lintra  compile
   simbuild -dut stap -ace_args ace -ccolt -ASSIGN -mc=stap_lint_model -pwa pwa_lint -lira_compile_opts -mfcu -lintra_exe_opts ' -r 50514 -r 60088 -r 68094 ' -ace_args- -1c -CUST <CUST_NAME> -1c-
## simbuild -dut stap -ace_args ace -ccolt -ASSIGN -mc=stap_lint_model -pwa pwa_lint -lira_compile_opts -mfcu -lintra_exe_opts ' -r 50514 -r 60088 -r 68094 ' -ace_args- -1c -CUST TGL -1c-
## simbuild -dut stap -ace_args ace -ccolt -ASSIGN -mc=stap_lint_model -pwa pwa_lint -lira_compile_opts -mfcu -lintra_exe_opts ' -r 50514 -r 60088 -r 68094 ' -ace_args- -1c -CUST TGPLP -1c-
##   
## To run lintra elab
   simbuild -dut stap -ace_args ace -sc -t lintra/stap -pwa pwa_lint -lintra_exe_opts " -r 50514  -r 60088  -r 68094 -r 68099 -r 68000" -ace_args- -1c -CUST <CUST_NAME> -1c-
## simbuild -dut stap -ace_args ace -sc -t lintra/stap -pwa pwa_lint -lintra_exe_opts " -r 50514  -r 60088  -r 68094 -r 68099 -r 68000" -ace_args- -1c -CUST TGL -1c-
## simbuild -dut stap -ace_args ace -sc -t lintra/stap -pwa pwa_lint -lintra_exe_opts " -r 50514  -r 60088  -r 68094 -r 68099 -r 68000" -ace_args- -1c -CUST TGPLP -1c-

## To open lintr gui
  simbuild -dut stap -ace_args lintra_gui -ace_args- -1c -CUST TGL -1c-
  simbuild -dut stap -ace_args lintra_gui -ace_args- -1c -CUST TGPLP -1c-

## To run collage 
   simbuild -dut stap -s all +s collage -1c -CUST <CUST_NAME> -1c-
## simbuild -dut stap -s all +s collage -1c -CUST TGL -1c-
## simbuild -dut stap -s all +s collage -1c -CUST TGPLP -1c-
##
## To run Emulation after running basic VCS simulation: 
   simbuild -dut stap -ace "setenv NBCLASS SLES11_EM64T_4G; ace -emul" -1c -CUST <CUST_NAME> -1c-
## simbuild -dut stap -ace "setenv NBCLASS SLES11_EM64T_4G; ace -emul" -1c -CUST TGL -1c-
## simbuild -dut stap -ace "setenv NBCLASS SLES11_EM64T_4G; ace -emul" -1c -CUST ICPLP -1c-


## To run CDC: 
   simbuild -dut stap -ace_args source tools/cdc/<CUST_NAME>/run_cdc<option> -ace_args- -1c -CUST <CUST_NAME> -1c-
## simbuild -dut stap -ace_args source tools/cdc/TGL/run_cdc_1274 -ace_args- -1c -CUST TGL -1c-
## simbuild -dut stap -ace_args source tools/cdc/TGPLP/run_cdc -ace_args- -1c -CUST TGPLP -1c-

## To run CDC-LINT and open the GUI after running CDC:
   source tools/cdcLint/TGL/run_cdcLint_TGL
   source tools/cdcLint/TGPLP/run_cdcLint_TGPLP

## To open GUI for CDC LINT
   simbuild -dut stap -ace_args lintra_gui -ov tools/cdcLint/TGL/stap_violations.xml -ace_args- -nf -1c -CUST TGL -1c-
   simbuild -dut stap -ace_args lintra_gui -ov tools/cdcLint/TGPLP/stap_violations.xml -ace_args- -nf -1c -CUST TGPLP -1c-
   
## To run XPROP (XPROP is enabled by default)
## simbuild -dut stap -ace_args ace -cc -x -ace_args- -1c -CUST <CUST_NAME> -1c-
##
## To run febe for running the RDT flow tools like ( DC, FEV)
## febe -dut stap -flow ip_turnin  -1c -CUST TGL -1c- 
## febe -dut stap -flow ip_turnin  -1c -CUST TGPLP -1c- 
##
##
## To run DC alone for TGL
   source tools/syn/TGL/stap/run_dc_alone_TGL

## To run DC alone for TGPLP
   source tools/syn/TGPLP/stap/run_dc_alone_TGPLP

## FEBE command to run specific tool DC/FEV/Caliber etc..
## This needs simbuild to be run one time & run lintra_build  lintra_elab , In case of LP/DFT sypglass LP/DFT also has to be run  
   febe -dut stap -s all +s <tool> -1c -CUST <CUST_NAME> -1c- 
## 
## FEV Run command
febe -dut stap -s all +s build_blocksinfo +s lintra_build +s lintra_elab -1c -CUST TGL -1c-

   febe -dut stap -s all +s build_blocksinfo +s dc +s fv -1c -CUST TGL -1c-
## febe -dut stap -s all +s fv -1c -CUST TGL -1c-
## febe -dut stap -s all +s fv -1c -CUST TGPLP -1c-
##
## In FEBE there is dependency to run each tool
## febe -dut <ip_name> -printdeps

## To run ZIRCON
## source tools/zirconqa/run_zircon
## source tools/zirconqa/run_zircon_upload_ipdashboard
## source tools/zirconqa/run_zircon_upload_socdashboard
##
## To run custum script: 
   simbuild -dut stap -ace_args /usr/intel/bin/tcsh <realpath of the script> -ace_args- -1c -CUST <CUST> -1c-
## 
## Environment/tool version related DEBUG
## setenv CFG_DEBUG
## ToolConfig.pl -h
## ToolConfig.pl get_tool_path  <tool>
##
## Example:
## =======
## ToolConfig.pl get_tool_path ace

## Power Artist run
## For STAP TGPLP
##febe -dut stap -s all +s  lintra_build +s .lintra_elab -1c -CUST TGPLP -1c-
##
##febe -dut stap -s all +s .pa_elab -1c -CUST TGPLP -1c-
##
##febe -dut stap -s all +s .pa_elab -pa_elab_args -pa_run -pa_elab_args- -1c -CUST TGPLP -1c-
##
##simbuild -dut stap -ace_args ace -cc -x -simv_args "+FSDB" -ace_args- -1c -CUST TGPLP -1c-
##
##febe -dut stap -s all +s .pa_avg_power -pa_avg_power_args -test TapTestBypass -stimTop top.stap_top_inst -stimFile /nfs/iind/disks/mg_disk0866/skmoolax/STAP/ip-stap/target/stap/TGPLP/aceroot/pwa/results/tests/TapTestBypass/Dump.fsdb  -pace tools/power_artist/TGPLP/stap/PACE.tech -pa_run -pa_avg_power_args- -1c -CUST TGPLP -1c-

### STEPS TO OPEN POWER_ARTIST GUI
#alias tsetup 'source /p/com/env/psetup/prod/bin/setupTool'
#tsetup PowerArtist 2015.1.2
#setenv APACHEDA_LICENSE_FILE 1881@apacheda01p.elic.intel.com:1881@apacheda02p.elic.intel.com
#PowerArtist-PT


##To Run Test Case with Converged JtagBfm
##
##simbuild -dut stap -ace_args ace -cc -x -use_model_converged -t TapTestOnlySLVIDCODE_EBEL -ace_args- -1c -CUST TGPLP -1c-
##################################################################################################################
##################################################################################################################
# To open a Verdi FSDB
#
##simbuild -dut stap -ace_args ace -ccod -ice -ace_args- -1c CUST <CUST> -1c-
##simbuild -dut stap -ace_args ace -view_debussy -verdi -ace_args- -1c CUST <CUST> -1c-


############################################################
# SoC TAP HAS rev100_rc12 URL Path
######################################################
#https://sharepoint.amr.ith.intel.com/sites/MDGArchMain/Converged/DFxChassisWG/_layouts/WordViewer.aspx?id=/sites/MDGArchMain/Converged/DFxChassisWG/SoC%20DFx/2_DFT_IPs/TAP_JTAG_TestAccessPort/10_Spec/SoC_TAP_HAS/Chassis_DFx_2.1/Working/SoC%20TAP%20HAS%20rev100_rc13_CB.docx&Source=https%3A%2F%2Fsharepoint%2Eamr%2Eith%2Eintel%2Ecom%2Fsites%2FMDGArchMain%2FConverged%2FDFxChassisWG%2FSoC%2520DFx%2FForms%2FAllItems%2Easpx%3FRootFolder%3D%252Fsites%252FMDGArchMain%252FConverged%252FDFxChassisWG%252FSoC%2520DFx%252F2%255FDFT%255FIPs%252FTAP%255FJTAG%255FTestAccessPort%252F10%255FSpec%252FSoC%255FTAP%255FHAS%252FChassis%255FDFx%255F2%252E1%252FWorking%26FolderCTID%3D0x01200032EF0B3AEF55E04F9766D93D71CF11B4&DefaultItemOpen=1&DefaultItemOpen=1



##Command to run Spyglass
simbuild -dut stap -ace_args ace -ASSIGN -mc=stap_spyglass_model -ASSIGN -models_to_elab=stap_spyglass_model -ccsg -vlog_opts "+define+SVA_OFF+define+NO_PWR_PINS" -ASSIGN -static_check_cfg_file=tools/spyglass/ace_static_check.cfg -sc -t spyglass/stap -ace_args- -1c -CUST TGL -1c-
simbuild -dut stap -ace_args spyglass -ace_args- -1c -CUST TGL -1c-

### Spyglass CDC  Run
simbuild -dut stap -s all +s sgcdc +s sgcdc_test -1c -cust TGL -1c-

## Open GUI
/p/hdk/rtl/cad/x86-64_linux30/atrenta/spyglass/L2016.06-SP2_Jan23/SPYGLASS_HOME/bin/spyglass &
