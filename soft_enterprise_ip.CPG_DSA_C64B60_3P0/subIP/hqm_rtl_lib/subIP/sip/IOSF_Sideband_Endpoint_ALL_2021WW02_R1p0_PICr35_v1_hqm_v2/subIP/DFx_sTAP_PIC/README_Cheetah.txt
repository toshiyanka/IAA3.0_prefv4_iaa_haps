###################################################################################################################
## This README is for sourcing and running the HDK commands and turnin to the repo using GK. 
## Note: Wash the unwanted groups and keep only the needed groups as below as HDK env sourcing will not happen 
## if the shell has more than 16 groups
##
## Below commands for HDK Environment.
##
## wash -n intelall soc cdftsip cdft n7 n7blr n7fe mp_tech_n7
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


#To generate 2 stage RTL List

simbuild -dut stap -ace_args ace -ccud -elab_opts "-Xctdiag=cfgverbose" -vlog_opts "+define+INTEL_SVA_OFF" -ace_args- -1c -CUST MTPLP -1c-
febe -s all +s v2k_prep +s flg_v2k -1c -CUST MTPLP -1c-
febe -s all +s gen_collateral -1c -CUST MTPLP -1c-

#To enter to Cheetah environment and source the licenses
setenv MODEL_ROOT $cwd
setenv FEBE_ROOT $MODEL_ROOT/target/stap/MTPLP/mat1.6.1.p1_n7.0/aceroot/results/DC/badithya.febe/
/p/hdk/bin/cth_eps -groups n7fe,cdft,cdftsip,siphdk,soc,n7,n7blr,mp_tech_n7 -ward_root $FEBE_ROOT -type private -ward_id febe -scope sipcth,sipn6,a0,p00,2019.09,n7_tsmc_snps_h240_M13,scs
pte_setup -wfs r2g_tools -stage all
cth_r2g populate -id febe -block stap -init cig-block -febe_output_path $FEBE_ROOT/fe_collaterals

#For running DC using command line
cth_r2g autorun -id febe -block stap -run_flow dc_baseline

#For running FV using command line
cth_r2g autorun -id febe -block stap -run_flow fev_r2syn



