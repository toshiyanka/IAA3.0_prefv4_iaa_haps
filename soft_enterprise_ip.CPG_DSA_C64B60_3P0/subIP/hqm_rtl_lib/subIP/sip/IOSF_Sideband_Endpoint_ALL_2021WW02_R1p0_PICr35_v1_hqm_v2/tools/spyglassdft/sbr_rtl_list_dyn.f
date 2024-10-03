$IP_ROOT/source/rtl/iosfsbc/router/${SIP_COMP_NAME}_sbr_generic.sv
$IP_ROOT/source/rtl/iosfsbc/common/${PUNI_PREFIX}sbc_map.sv

-y $IP_ROOT/source/rtl/iosfsbc/common
-y $IP_ROOT/source/rtl/iosfsbc/router
-y $IP_ROOT/subIP/dfx_secure_plugin/source/rtl/dfxsecure_plugin
-y $IP_ROOT/subIP/pgcb/source/rtl/pgcbunit
$IP_ROOT/subIP/pgcb/source/rtl/pgcbunit/${PUNI_PREFIX}pgcb_map.sv
+libext+.v+.sv

+incdir+$IP_ROOT/subIP/pgcb/source/rtl/pgcbunit
+incdir+$IP_ROOT/source/rtl/iosfsbc/common
+incdir+$IP_ROOT/source/rtl/iosfsbc/router
+incdir+$IP_ROOT/subIP/dfx_secure_plugin/source/rtl/include

