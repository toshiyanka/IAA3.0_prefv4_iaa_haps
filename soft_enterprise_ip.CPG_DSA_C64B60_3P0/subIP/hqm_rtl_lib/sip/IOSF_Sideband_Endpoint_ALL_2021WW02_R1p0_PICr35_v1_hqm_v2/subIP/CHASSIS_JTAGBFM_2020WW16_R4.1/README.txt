#####################################################################################
Date:2020WW08   Release Version: 4.1

Release name :CHASSIS_JTAGBFM_2020WW16_R4.1
-------------------------------------------------------------------------------------
Intergation Guide            : ./doc/ 
Source Code                  : ./verif/tb/JtagBfm/ 
Sample Tests, Sequences, Env : ./verif/tb/SampleTests/
More command help            : ./scripts/command_help
-------------------------------------------------------------------------------------
To source the utility

   setenv IP_ROOT  $cwd
   cd $IP_ROOT/scripts
   source setup
 ###############################
##By default source setup picks SLES12 machine
##To run on SLES11:
   setenv NBCLASS "8G&&SLES11"
 ################################  
   ace -ccud -x
   ace -ccud -x -sd verdi
   ace -ccud -x -sd gui 
#####################################################################################
To run Regressions

source scripts/run_all_configs
#####################################################################################
To run Converged JTAGBFM

gcc -m64 -fPIC -DVCS -g -W -shared -x c -I$VCS_HOME/include $UVM_HOME/src/dpi/uvm_dpi.cc -o $IP_ROOT/scripts/uvm_dpi.so
$IP_ROOT/verif/tb/Converged_JtagBfm/Converged_SampleTests/compile_and_run _A_TAP_BFM_ dfx_tap_sip_api_sequence
#####################################################################################
To run JTAGBFM with UVM 

##ace -cc -ASSIGN -mc=jtagbfm_UVM_model -ASSIGN -models_to_elab=jtagbfm_UVM_model -m jtagbfm_UVM_model -vlog_opts "+define+UVM_OBJECT_DO_NOT_NEED_CONSTRUCTOR" -elab_opts '-CFLAGS "-D VCS" -CFLAGS "-I ${VCS_HOME}/include" ${UVM_HOME}/src/dpi/uvm_dpi.cc' -x -simv_args "+UVM_TESTNAME=TapTestAllPrimary" -simv_args "+verbosity=100"

ace -cc -use_model_JtagBfm_UVM -vlog_opts "+define+UVM_NO_DPI" -x -simv_args "+UVM_TESTNAME=TapTestAllPrimary" -simv_args "+verbosity=100"

### OVM to UVM conversion:
Steps:
1) $IP_ROOT/scripts/intel_ovm_to_uvm.pl --top_dir=verif/tb/JtagBfm --backup --write --all_text_files
2) Copy the verif/tb/JtagBfm to verif/tb/JtagBfm_UVM
    \cp verif/tb/JtagBfm/* verif/tb/JtagBfm_UVM/. -rf
3) Then we need to add pre_body and post_body in verif/tb/JtagBfm_UVM/JtagBfmAPIs.sv by referring previous version from central path
4) Please git co verif/tb/JtagBfm_UVM/JtagBfmTi.hdl and verif/tb/JtagBfm_UVM/JtagBfmPkg.hdl unless you have new changes
5) If you have new changes, manually get changes from OVM for both verif/tb/JtagBfm_UVM/JtagBfmTi.hdl and verif/tb/JtagBfm_UVM/JtagBfmPkg.hdl
5) Do gvimdiff verif/tb/JtagBfm_UVM/JtagBfmPkg.sv verif/tb/JtagBfm_UVM/JtagBfmPkg_UVM.sv and copy new changes from OVM
6) rm -rf verif/tb/JtagBfm_UVM/JtagBfmPkg.sv
7) Please review before commit
 
#########################################################################
# TAPLink
# Compile repo with following defines for TAPLink
# Note: Macro +define+JTAG_BFM_DEBUG_MSG during compile time is optional.

ace -ccud -vlog_opts "+define+JTAG_BFM_DEBUG_MSG+define+JTAG_BFM_TAPLINK_MODE"

#########################################################################
