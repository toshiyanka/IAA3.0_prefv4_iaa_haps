$IP_ROOT/source/rtl/iosfsbc/common/sbc_map.sv
./upf_wrapper.sv

-y $IP_ROOT/source/rtl/iosfsbc/common
-y $IP_ROOT/source/rtl/iosfsbc/endpoint
+libext+.v+.sv
+define+DC
+define+SIPINT_1271

+incdir+$IP_ROOT/source/rtl/iosfsbc/common
+incdir+$IP_ROOT/tools/upf/sbendpoint/

