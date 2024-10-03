#!/bin/csh
source /p/hdk/rtl/hdk.rc -cfg shdk74
$RTL_PROJ_TOOLS/zircon/master/2.08.16/bin/zirconQA -ipconfigid 91081 -subipconfig cdc_wrapper_top -alias cdc_wrapper -app SIP -ms RTL1P0 -verbose3 -rpt -dssmsid 61093 -ovf tools/zirconqa/inputs/cdc_wrapper_top_override_2.08.00.dat -env DUT=cdc_wrapper > scripts/cdc_wrapper_top.log
$RTL_PROJ_TOOLS/zircon/master/2.08.16/bin/zirconQA -ipconfigid 91081 -subipconfig dft_reset_sync -alias dft_reset_sync -app SIP -ms RTL1P0 -verbose3 -rpt -dssmsid 61093 -ovf tools/zirconqa/inputs/dft_reset_sync_override_2.08.00.dat -env DUT=dft_reset_sync > scripts/dft_reset_sync.log
# from zircon log:
#ZQA must have been run for all the subIpConfigs. ZQA will upload the results. It will not not rerun the tool. 
#$RTL_PROJ_TOOLS/zircon/master/2.08.16/bin/zirconQA -ipconfigid 91081 -app SIP -ms RTL1P0 -dssmsid 61093 -ipDashUpload
