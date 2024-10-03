-f $ip/filelists/dsa_subip_rtl_lib.rtl.f 
-f $ip/filelists/dsa_common_rtl_lib.rtl.f

#$ip/src/rtl/eip/dsa2i64b60/dsab2i64b60.sv
$ip/src/rtl/eip/dsa2i64b60/dsab2i64b60_ip.sv
$ip/src/rtl/eip/dsa2i64b60/dsab2i64b60_aon.sv
$ip/src/rtl/eip/dsa2i64b60/dsab2i64b60_csr.sv
$ip/src/rtl/eip/dsa2i64b60/dsab2i64b60_mem.sv
$ip/src/gen/dsa2i64b60_csr_cfg.sv
$ip/src/gen/dsa2i64b60_csr_mem.sv

$ip/src/rtl/dsa/dsa_crc64_top.sv
$ip/src/rtl/dsa/dsa_crc64_gf2_mult.sv
$ip/src/rtl/dsa/dsa_crc64_reducer.sv
$ip/src/rtl/dsa/dsa_ipt.sv
$ip/src/rtl/dsa/dsa_bmap_buf.sv

+incdir+$ip/src/gen
+incdir+$ip/src/rtl/dsa
+incdir+$ip/src/rtl/iax
+incdir+$ip/src/rtl/sbw
+incdir+$ip/src/rtl/eip
+incdir+$ip/src/rtl/common


