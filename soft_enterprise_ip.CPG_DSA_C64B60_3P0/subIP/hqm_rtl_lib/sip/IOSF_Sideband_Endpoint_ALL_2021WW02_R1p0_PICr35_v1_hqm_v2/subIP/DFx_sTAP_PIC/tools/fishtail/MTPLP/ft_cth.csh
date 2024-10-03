#!/usr/intel/pkgs/tcsh/6.13.00/bin/tcsh -ef
echo '#--- setenv commands from project ----#'
setenv FISHTAIL_LICENSE_FILE "27030@fishtail01p.elic.intel.com"
#--- unsetenv commands from project ----#
#--- populate files ----#

setenv PROJ_FT /p/hdk/pu_tu/prd/proj_ft/19.04.16
setenv PATH /p/hdk/cad/fishtail/2019.09/bin:/p/hdk/cad/fishtail/2019.09/scripts:$PATH
setenv FISHTAIL_HOME /p/hdk/cad/fishtail/2019.09
#/bin/echo "FEBE: Running febe_populate.pl"
#$PROJ_FT/bin/run_ft.py --block sb_i3c_lite --ward $WARD --rtl_verification --rtl_list_type 1stage --verify gc,fp --sip_mode --config /nfs/iind/disks/iind_lpss_00013/msasikum/lpss_cheetah/ip-lss_working//target/lpss/CWV/mat1.5.3.p0_p1274.7/aceroot/results/DC/sb_i3c_lite/fishtail/rtl_verification/sb_i3c_lite/sb_i3c_lite.ft_hdk_cfg.json
$PROJ_FT/bin/run_ft.py --block sb_i3c_lite --ward `pwd` --rtl_verification --rtl_list_type 2stage --verify fp,gc,mcp --sip_mode --config /nfs/iind/disks/dteg_disk008/users/badithya/MAT_HDK/Cheetah_2Stage/dteg-stap/tools/fishtail/MTPLP/stap.ft_hdk_cfg.json
