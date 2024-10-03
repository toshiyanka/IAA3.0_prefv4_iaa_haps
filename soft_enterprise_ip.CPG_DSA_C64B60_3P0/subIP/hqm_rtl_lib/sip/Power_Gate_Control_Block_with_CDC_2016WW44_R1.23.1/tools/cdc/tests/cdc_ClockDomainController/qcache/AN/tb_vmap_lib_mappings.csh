#!/bin/csh -f


set vlib_exec = "/p/com/eda/mentor/questaCDC/V10.3c_2/linux_x86_64/modeltech/plat/vlib"
if (! -e $vlib_exec) then
  echo "** ERROR: vlib path '$vlib_exec' does not exist"
  exit 1
endif

set vmap_exec = "/p/com/eda/mentor/questaCDC/V10.3c_2/linux_x86_64/modeltech/plat/vmap"
if (! -e $vmap_exec) then
  echo "** ERROR: vmap path '$vmap_exec' does not exist"
  exit 1
endif

cp -f /nfs/fm/disks/fm_pmc_00089/ssing18/PGCB/ip-pwrmisc-tgl/tools/cdc/tests/cdc_ClockDomainController/qcache/AN/modelsim.ini .

# $vlib_exec /nfs/fm/disks/fm_pmc_00089/ssing18/PGCB/ip-pwrmisc-tgl/tools/cdc/tests/cdc_ClockDomainController/pgcb_collection_cdc_testlib
# if($status == 0) then
#   $vmap_exec -modelsimini modelsim.ini pgcb_collection_cdc_testlib /nfs/fm/disks/fm_pmc_00089/ssing18/PGCB/ip-pwrmisc-tgl/tools/cdc/tests/cdc_ClockDomainController/pgcb_collection_cdc_testlib
# else
#   echo "** Error: Library mapping failed. (Command: 'vlib /nfs/fm/disks/fm_pmc_00089/ssing18/PGCB/ip-pwrmisc-tgl/tools/cdc/tests/cdc_ClockDomainController/pgcb_collection_cdc_testlib')"
# endif
# $vlib_exec /nfs/fm/disks/fm_pmc_00089/ssing18/PGCB/ip-pwrmisc-tgl/target/pgcb_collection/cdc_lib/V10.3c_2/cdc_tooltb_lib
# if($status == 0) then
#   $vmap_exec -modelsimini modelsim.ini cdc_tooltb_lib /nfs/fm/disks/fm_pmc_00089/ssing18/PGCB/ip-pwrmisc-tgl/target/pgcb_collection/cdc_lib/V10.3c_2/cdc_tooltb_lib
# else
#   echo "** Error: Library mapping failed. (Command: 'vlib /nfs/fm/disks/fm_pmc_00089/ssing18/PGCB/ip-pwrmisc-tgl/target/pgcb_collection/cdc_lib/V10.3c_2/cdc_tooltb_lib')"
# endif
# $vlib_exec /nfs/fm/disks/fm_pmc_00089/ssing18/PGCB/ip-pwrmisc-tgl/target/pgcb_collection/cdc_lib/V10.3c_2/cdc_synccell_lib
# if($status == 0) then
#   $vmap_exec -modelsimini modelsim.ini cdc_synccell_lib /nfs/fm/disks/fm_pmc_00089/ssing18/PGCB/ip-pwrmisc-tgl/target/pgcb_collection/cdc_lib/V10.3c_2/cdc_synccell_lib
# else
#   echo "** Error: Library mapping failed. (Command: 'vlib /nfs/fm/disks/fm_pmc_00089/ssing18/PGCB/ip-pwrmisc-tgl/target/pgcb_collection/cdc_lib/V10.3c_2/cdc_synccell_lib')"
# endif
# $vlib_exec /nfs/fm/disks/fm_pmc_00089/ssing18/PGCB/ip-pwrmisc-tgl/target/pgcb_collection/cdc_lib/V10.3c_2/cdc_pgcbcg_lib
# if($status == 0) then
#   $vmap_exec -modelsimini modelsim.ini cdc_pgcbcg_lib /nfs/fm/disks/fm_pmc_00089/ssing18/PGCB/ip-pwrmisc-tgl/target/pgcb_collection/cdc_lib/V10.3c_2/cdc_pgcbcg_lib
# else
#   echo "** Error: Library mapping failed. (Command: 'vlib /nfs/fm/disks/fm_pmc_00089/ssing18/PGCB/ip-pwrmisc-tgl/target/pgcb_collection/cdc_lib/V10.3c_2/cdc_pgcbcg_lib')"
# endif
# $vlib_exec /nfs/fm/disks/fm_pmc_00089/ssing18/PGCB/ip-pwrmisc-tgl/target/pgcb_collection/cdc_lib/V10.3c_2/cdc_ClockDomainController_lib
# if($status == 0) then
#   $vmap_exec -modelsimini modelsim.ini cdc_ClockDomainController_lib /nfs/fm/disks/fm_pmc_00089/ssing18/PGCB/ip-pwrmisc-tgl/target/pgcb_collection/cdc_lib/V10.3c_2/cdc_ClockDomainController_lib
# else
#   echo "** Error: Library mapping failed. (Command: 'vlib /nfs/fm/disks/fm_pmc_00089/ssing18/PGCB/ip-pwrmisc-tgl/target/pgcb_collection/cdc_lib/V10.3c_2/cdc_ClockDomainController_lib')"
# endif
# $vlib_exec /nfs/fm/disks/fm_pmc_00089/ssing18/PGCB/ip-pwrmisc-tgl/target/pgcb_collection/cdc_lib/V10.3c_2/cdc_pgcbunit_lib
# if($status == 0) then
#   $vmap_exec -modelsimini modelsim.ini cdc_pgcbunit_lib /nfs/fm/disks/fm_pmc_00089/ssing18/PGCB/ip-pwrmisc-tgl/target/pgcb_collection/cdc_lib/V10.3c_2/cdc_pgcbunit_lib
# else
#   echo "** Error: Library mapping failed. (Command: 'vlib /nfs/fm/disks/fm_pmc_00089/ssing18/PGCB/ip-pwrmisc-tgl/target/pgcb_collection/cdc_lib/V10.3c_2/cdc_pgcbunit_lib')"
# endif
# $vlib_exec /nfs/site/eda/data/eda508/mentor/questaCDC/V10.3c_2/common/share/modeltech/linux_x86_64/../ieee
# if($status == 0) then
#   $vmap_exec -modelsimini modelsim.ini ieee /nfs/site/eda/data/eda508/mentor/questaCDC/V10.3c_2/common/share/modeltech/linux_x86_64/../ieee
# else
#   echo "** Error: Library mapping failed. (Command: 'vlib /nfs/site/eda/data/eda508/mentor/questaCDC/V10.3c_2/common/share/modeltech/linux_x86_64/../ieee')"
# endif
# $vlib_exec /nfs/site/eda/data/eda508/mentor/questaCDC/V10.3c_2/common/share/modeltech/linux_x86_64/../vital2000
# if($status == 0) then
#   $vmap_exec -modelsimini modelsim.ini vital2000 /nfs/site/eda/data/eda508/mentor/questaCDC/V10.3c_2/common/share/modeltech/linux_x86_64/../vital2000
# else
#   echo "** Error: Library mapping failed. (Command: 'vlib /nfs/site/eda/data/eda508/mentor/questaCDC/V10.3c_2/common/share/modeltech/linux_x86_64/../vital2000')"
# endif
# $vlib_exec /nfs/site/eda/data/eda508/mentor/questaCDC/V10.3c_2/common/share/modeltech/linux_x86_64/../verilog
# if($status == 0) then
#   $vmap_exec -modelsimini modelsim.ini verilog /nfs/site/eda/data/eda508/mentor/questaCDC/V10.3c_2/common/share/modeltech/linux_x86_64/../verilog
# else
#   echo "** Error: Library mapping failed. (Command: 'vlib /nfs/site/eda/data/eda508/mentor/questaCDC/V10.3c_2/common/share/modeltech/linux_x86_64/../verilog')"
# endif
# $vlib_exec /nfs/site/eda/data/eda508/mentor/questaCDC/V10.3c_2/common/share/modeltech/linux_x86_64/../std_developerskit
# if($status == 0) then
#   $vmap_exec -modelsimini modelsim.ini std_developerskit /nfs/site/eda/data/eda508/mentor/questaCDC/V10.3c_2/common/share/modeltech/linux_x86_64/../std_developerskit
# else
#   echo "** Error: Library mapping failed. (Command: 'vlib /nfs/site/eda/data/eda508/mentor/questaCDC/V10.3c_2/common/share/modeltech/linux_x86_64/../std_developerskit')"
# endif
# $vlib_exec /nfs/site/eda/data/eda508/mentor/questaCDC/V10.3c_2/common/share/modeltech/linux_x86_64/../synopsys
# if($status == 0) then
#   $vmap_exec -modelsimini modelsim.ini synopsys /nfs/site/eda/data/eda508/mentor/questaCDC/V10.3c_2/common/share/modeltech/linux_x86_64/../synopsys
# else
#   echo "** Error: Library mapping failed. (Command: 'vlib /nfs/site/eda/data/eda508/mentor/questaCDC/V10.3c_2/common/share/modeltech/linux_x86_64/../synopsys')"
# endif
# $vlib_exec /nfs/site/eda/data/eda508/mentor/questaCDC/V10.3c_2/common/share/modeltech/linux_x86_64/../modelsim_lib
# if($status == 0) then
#   $vmap_exec -modelsimini modelsim.ini modelsim_lib /nfs/site/eda/data/eda508/mentor/questaCDC/V10.3c_2/common/share/modeltech/linux_x86_64/../modelsim_lib
# else
#   echo "** Error: Library mapping failed. (Command: 'vlib /nfs/site/eda/data/eda508/mentor/questaCDC/V10.3c_2/common/share/modeltech/linux_x86_64/../modelsim_lib')"
# endif
# $vlib_exec /nfs/site/eda/data/eda508/mentor/questaCDC/V10.3c_2/common/share/modeltech/linux_x86_64/../sv_std
# if($status == 0) then
#   $vmap_exec -modelsimini modelsim.ini sv_std /nfs/site/eda/data/eda508/mentor/questaCDC/V10.3c_2/common/share/modeltech/linux_x86_64/../sv_std
# else
#   echo "** Error: Library mapping failed. (Command: 'vlib /nfs/site/eda/data/eda508/mentor/questaCDC/V10.3c_2/common/share/modeltech/linux_x86_64/../sv_std')"
# endif
# $vlib_exec /nfs/site/eda/data/eda508/mentor/questaCDC/V10.3c_2/common/share/modeltech/linux_x86_64/../avm
# if($status == 0) then
#   $vmap_exec -modelsimini modelsim.ini mtiAvm /nfs/site/eda/data/eda508/mentor/questaCDC/V10.3c_2/common/share/modeltech/linux_x86_64/../avm
# else
#   echo "** Error: Library mapping failed. (Command: 'vlib /nfs/site/eda/data/eda508/mentor/questaCDC/V10.3c_2/common/share/modeltech/linux_x86_64/../avm')"
# endif
# $vlib_exec /nfs/site/eda/data/eda508/mentor/questaCDC/V10.3c_2/common/share/modeltech/linux_x86_64/../ovm-2.1.2
# if($status == 0) then
#   $vmap_exec -modelsimini modelsim.ini mtiOvm /nfs/site/eda/data/eda508/mentor/questaCDC/V10.3c_2/common/share/modeltech/linux_x86_64/../ovm-2.1.2
# else
#   echo "** Error: Library mapping failed. (Command: 'vlib /nfs/site/eda/data/eda508/mentor/questaCDC/V10.3c_2/common/share/modeltech/linux_x86_64/../ovm-2.1.2')"
# endif
# $vlib_exec /nfs/site/eda/data/eda508/mentor/questaCDC/V10.3c_2/common/share/modeltech/linux_x86_64/../uvm-1.1d
# if($status == 0) then
#   $vmap_exec -modelsimini modelsim.ini mtiUvm /nfs/site/eda/data/eda508/mentor/questaCDC/V10.3c_2/common/share/modeltech/linux_x86_64/../uvm-1.1d
# else
#   echo "** Error: Library mapping failed. (Command: 'vlib /nfs/site/eda/data/eda508/mentor/questaCDC/V10.3c_2/common/share/modeltech/linux_x86_64/../uvm-1.1d')"
# endif
# $vlib_exec /nfs/site/eda/data/eda508/mentor/questaCDC/V10.3c_2/common/share/modeltech/linux_x86_64/../upf_lib
# if($status == 0) then
#   $vmap_exec -modelsimini modelsim.ini mtiUPF /nfs/site/eda/data/eda508/mentor/questaCDC/V10.3c_2/common/share/modeltech/linux_x86_64/../upf_lib
# else
#   echo "** Error: Library mapping failed. (Command: 'vlib /nfs/site/eda/data/eda508/mentor/questaCDC/V10.3c_2/common/share/modeltech/linux_x86_64/../upf_lib')"
# endif
# $vlib_exec /nfs/site/eda/data/eda508/mentor/questaCDC/V10.3c_2/common/share/modeltech/linux_x86_64/../pa_lib
# if($status == 0) then
#   $vmap_exec -modelsimini modelsim.ini mtiPA /nfs/site/eda/data/eda508/mentor/questaCDC/V10.3c_2/common/share/modeltech/linux_x86_64/../pa_lib
# else
#   echo "** Error: Library mapping failed. (Command: 'vlib /nfs/site/eda/data/eda508/mentor/questaCDC/V10.3c_2/common/share/modeltech/linux_x86_64/../pa_lib')"
# endif
# $vlib_exec /nfs/site/eda/data/eda508/mentor/questaCDC/V10.3c_2/common/share/modeltech/linux_x86_64/../floatfixlib
# if($status == 0) then
#   $vmap_exec -modelsimini modelsim.ini floatfixlib /nfs/site/eda/data/eda508/mentor/questaCDC/V10.3c_2/common/share/modeltech/linux_x86_64/../floatfixlib
# else
#   echo "** Error: Library mapping failed. (Command: 'vlib /nfs/site/eda/data/eda508/mentor/questaCDC/V10.3c_2/common/share/modeltech/linux_x86_64/../floatfixlib')"
# endif
# $vlib_exec /nfs/site/eda/data/eda508/mentor/questaCDC/V10.3c_2/common/share/modeltech/linux_x86_64/../mc2_lib
# if($status == 0) then
#   $vmap_exec -modelsimini modelsim.ini mc2_lib /nfs/site/eda/data/eda508/mentor/questaCDC/V10.3c_2/common/share/modeltech/linux_x86_64/../mc2_lib
# else
#   echo "** Error: Library mapping failed. (Command: 'vlib /nfs/site/eda/data/eda508/mentor/questaCDC/V10.3c_2/common/share/modeltech/linux_x86_64/../mc2_lib')"
# endif
# $vlib_exec /nfs/site/eda/data/eda508/mentor/questaCDC/V10.3c_2/common/share/modeltech/linux_x86_64/../osvvm
# if($status == 0) then
#   $vmap_exec -modelsimini modelsim.ini osvvm /nfs/site/eda/data/eda508/mentor/questaCDC/V10.3c_2/common/share/modeltech/linux_x86_64/../osvvm
# else
#   echo "** Error: Library mapping failed. (Command: 'vlib /nfs/site/eda/data/eda508/mentor/questaCDC/V10.3c_2/common/share/modeltech/linux_x86_64/../osvvm')"
# endif
# $vlib_exec /nfs/site/eda/data/eda508/mentor/questaCDC/V10.3c_2/common/share/modeltech/linux_x86_64/../infact
# if($status == 0) then
#   $vmap_exec -modelsimini modelsim.ini infact /nfs/site/eda/data/eda508/mentor/questaCDC/V10.3c_2/common/share/modeltech/linux_x86_64/../infact
# else
#   echo "** Error: Library mapping failed. (Command: 'vlib /nfs/site/eda/data/eda508/mentor/questaCDC/V10.3c_2/common/share/modeltech/linux_x86_64/../infact')"
# endif
# $vlib_exec /nfs/fm/disks/fm_pmc_00089/ssing18/PGCB/ip-pwrmisc-tgl/tools/cdc/tests/cdc_ClockDomainController/.//qcache/AN/zin_vopt_work
if($status == 0) then
  $vmap_exec -modelsimini modelsim.ini z0in_work_ctrl /nfs/fm/disks/fm_pmc_00089/ssing18/PGCB/ip-pwrmisc-tgl/tools/cdc/tests/cdc_ClockDomainController/.//qcache/AN/zin_vopt_work
else
  echo "** Error: Library mapping failed. (Command: 'vlib /nfs/fm/disks/fm_pmc_00089/ssing18/PGCB/ip-pwrmisc-tgl/tools/cdc/tests/cdc_ClockDomainController/.//qcache/AN/zin_vopt_work')"
endif
# $vlib_exec /nfs/fm/disks/fm_pmc_00089/ssing18/PGCB/ip-pwrmisc-tgl/tools/cdc/tests/cdc_ClockDomainController/qcache/AN/zin_vopt_work
# if($status == 0) then
#   $vmap_exec -modelsimini modelsim.ini work /nfs/fm/disks/fm_pmc_00089/ssing18/PGCB/ip-pwrmisc-tgl/tools/cdc/tests/cdc_ClockDomainController/qcache/AN/zin_vopt_work
# else
#   echo "** Error: Library mapping failed. (Command: 'vlib /nfs/fm/disks/fm_pmc_00089/ssing18/PGCB/ip-pwrmisc-tgl/tools/cdc/tests/cdc_ClockDomainController/qcache/AN/zin_vopt_work')"
# endif
