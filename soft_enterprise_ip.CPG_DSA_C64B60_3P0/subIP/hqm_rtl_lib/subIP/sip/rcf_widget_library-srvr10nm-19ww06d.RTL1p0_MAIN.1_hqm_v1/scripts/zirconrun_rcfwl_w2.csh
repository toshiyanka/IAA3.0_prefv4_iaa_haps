#!/bin/csh
source /p/hdk/rtl/hdk.rc -cfg shdk74
$RTL_PROJ_TOOLS/zircon/master/2.08.16/bin/zirconQA -ipconfigid 93363 -subipconfig cdc_wrapper_w2 -alias cdc_wrapper -app SIP -ms RTL1P0 -verbose3 -rpt -dssmsid 73103 -ovf tools/zirconqa/inputs/cdc_wrapper_top_override_2.08.00.dat -env DUT=cdc_wrapper > scripts/cdc_wrapper_w2.log
$RTL_PROJ_TOOLS/zircon/master/2.08.16/bin/zirconQA -ipconfigid 93363 -subipconfig dft_reset_sync_w2 -alias dft_reset_sync -app SIP -ms RTL1P0 -verbose3 -rpt -dssmsid 73103 -ovf tools/zirconqa/inputs/dft_reset_sync_w2_override_2.08.00.dat -env DUT=dft_reset_sync > scripts/dft_reset_sync.log
$RTL_PROJ_TOOLS/zircon/master/2.08.16/bin/zirconQA -ipconfigid 93363 -subipconfig pok_mgr_w2 -alias pok_mgr -app SIP -ms RTL1P0 -verbose3 -rpt -dssmsid 73103 -ovf tools/zirconqa/inputs/pok_mgr_w2_override_2.08.00.dat -env DUT=pok_mgr > scripts/pok_mgr_w2.log
# from zircon log:
#ZQA must have been run for all the subIpConfigs. ZQA will upload the results. It will not not rerun the tool. 
#$RTL_PROJ_TOOLS/zircon/master/2.08.16/bin/zirconQA -ipconfigid 93363 -app SIP -ms RTL1P0 -dssmsid 73103 -ipDashUpload
