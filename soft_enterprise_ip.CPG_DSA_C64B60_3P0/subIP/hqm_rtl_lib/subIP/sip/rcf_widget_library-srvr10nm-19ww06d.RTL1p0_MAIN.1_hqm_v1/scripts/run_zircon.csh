#!/bin/csch
setenv MODEL_ROOT ${cwd}

$RTL_PROJ_TOOLS/zircon/master/2.10.05.P2/bin/zirconQA -model_root $MODEL_ROOT -ipconfigid 93363 -dssmsid 73102 -subipconfig cdc_wrapper_w2    -alias cdc_wrapper rcfwl_cdc_wrapper       -app SIP -ms RTL0P8 -verbose -ovf tools/zirconqa/inputs/zirconqa_overrides_2.10.ini -output tools/zirconqa/outputs/cdc_wrapper      -ipDashUpload
$RTL_PROJ_TOOLS/zircon/master/2.10.05.P2/bin/zirconQA -model_root $MODEL_ROOT -ipconfigid 93363 -dssmsid 73102 -subipconfig dft_reset_sync_w2 -alias dft_reset_sync rcfwl_dft_reset_sync -app SIP -ms RTL0P8 -verbose -ovf tools/zirconqa/inputs/zirconqa_overrides_2.10.ini -output tools/zirconqa/outputs/dft_reset_sync   -ipDashUpload
$RTL_PROJ_TOOLS/zircon/master/2.10.05.P2/bin/zirconQA -model_root $MODEL_ROOT -ipconfigid 93363 -dssmsid 73102 -subipconfig ip_disable_w2     -alias ip_disable rcfwl_ip_disable         -app SIP -ms RTL0P8 -verbose -ovf tools/zirconqa/inputs/zirconqa_overrides_2.10.ini -output tools/zirconqa/outputs/ip_disable       -ipDashUpload
$RTL_PROJ_TOOLS/zircon/master/2.10.05.P2/bin/zirconQA -model_root $MODEL_ROOT -ipconfigid 99584 -dssmsid 116947                               -alias fuse_hip_glue rcfwl_fuse_hip_glue   -app SIP -ms RTL0P8 -verbose -ovf tools/zirconqa/inputs/zirconqa_overrides_2.10.ini -output tools/zirconqa/outputs/fuse_hip_glue    -ipDashUpload


unsetenv MODEL_ROOT
