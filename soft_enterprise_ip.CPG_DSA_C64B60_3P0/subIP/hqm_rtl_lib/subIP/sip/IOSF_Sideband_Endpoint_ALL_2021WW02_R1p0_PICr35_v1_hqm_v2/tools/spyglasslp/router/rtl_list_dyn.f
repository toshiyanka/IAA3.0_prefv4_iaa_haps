$IP_ROOT/source/rtl/iosfsbc/router/${SIP_COMP_NAME}_sbr_generic.sv
$IP_ROOT/source/rtl/iosfsbc/common/${PUNI_PREFIX}sbc_map.sv

-y $IP_ROOT/source/rtl/iosfsbc/common
-y $IP_ROOT/source/rtl/iosfsbc/router
-y $IP_ROOT/subIP/dfx_secure_plugin/source/rtl/dfxsecure_plugin
-y $IP_ROOT/subIP/DFx_sTAP_PIC3_2016WW28_RTL1P0_V1/source/rtl/stap
-y $IP_ROOT/subIP/DFx_sTAP_PIC3_2016WW28_RTL1P0_V1/subIP/DfxSecurePlugin/source/rtl/dfxsecure_plugin
-y $IP_ROOT/subIP/pgcb/source/rtl/pgcbunit
$IP_ROOT/subIP/pgcb/source/rtl/pgcbunit/${PUNI_PREFIX}pgcb_map.sv
$IP_ROOT/subIP/DFx_sTAP_PIC3_2016WW28_RTL1P0_V1/source/rtl/ctech_lib/${PUNI_PREFIX}stap_ctech_map.sv
+libext+.v+.sv
+define+DC
+define+SIPINT_1271

+incdir+$IP_ROOT/subIP/pgcb/source/rtl/pgcbunit
+incdir+$IP_ROOT/source/rtl/iosfsbc/common
+incdir+$IP_ROOT/source/rtl/iosfsbc/router
+incdir+$IP_ROOT/subIP/dfx_secure_plugin/source/rtl/include
+incdir+$IP_ROOT/subIP/dfx_secure_plugin/source/rtl/include/assertions
+incdir+$IP_ROOT/subIP/DFx_sTAP_PIC3_2016WW28_RTL1P0_V1/source/rtl/include
+incdir+$IP_ROOT/subIP/DFx_sTAP_PIC3_2016WW28_RTL1P0_V1/subIP/DfxSecurePlugin/source/rtl/include
