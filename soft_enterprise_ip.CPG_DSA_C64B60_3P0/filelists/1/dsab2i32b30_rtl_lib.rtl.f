-f $ip/filelists/dsa_subip_rtl_lib.rtl.f 
-f $ip/filelists/dsa_common_rtl_lib.rtl.f


#$ip/src/rtl/eip/dsa2i32b30/dsab2i32b30.sv
$ip/src/rtl/eip/dsa2i32b30/dsab2i32b30_ip.sv
$ip/src/rtl/eip/dsa2i32b30/dsab2i32b30_aon.sv
$ip/src/rtl/eip/dsa2i32b30/dsab2i32b30_csr.sv
$ip/src/rtl/eip/dsa2i32b30/dsab2i32b30_mem.sv
$ip/src/gen/dsa2i32b30_csr_cfg.sv
$ip/src/gen/dsa2i32b30_csr_mem.sv


+incdir+$ip/src/gen
+incdir+$ip/src/rtl/dsa
+incdir+$ip/src/rtl/iax
+incdir+$ip/src/rtl/sbw
+incdir+$ip/src/rtl/eip
+incdir+$ip/src/rtl/common


