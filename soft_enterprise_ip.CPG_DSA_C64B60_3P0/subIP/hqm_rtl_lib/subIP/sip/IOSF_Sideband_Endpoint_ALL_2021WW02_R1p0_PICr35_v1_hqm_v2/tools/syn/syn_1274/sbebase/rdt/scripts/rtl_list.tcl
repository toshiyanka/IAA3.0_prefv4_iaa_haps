global env

set VERILOG_SOURCE_FILES "
../../../../../source/rtl/iosfsbc/common/sbc_map.sv
../../../../../source/rtl/iosfsbc/common/sbcasyncfifo.sv
../../../../../source/rtl/iosfsbc/common/sbcegress.sv
../../../../../source/rtl/iosfsbc/common/sbcfifo.sv
../../../../../source/rtl/iosfsbc/common/sbcgcgu.sv
../../../../../source/rtl/iosfsbc/common/sbcingress.sv
../../../../../source/rtl/iosfsbc/common/sbcinqueue.sv
../../../../../source/rtl/iosfsbc/common/sbcism.sv
../../../../../source/rtl/iosfsbc/common/sbcport.sv
../../../../../source/rtl/iosfsbc/common/sbcusync.sv
../../../../../source/rtl/iosfsbc/common/sbcvram2.sv
../../../../../source/rtl/iosfsbc/common/sbff.sv
../../../../../source/rtl/iosfsbc/endpoint/sbebase.sv 
../../../../../source/rtl/iosfsbc/endpoint/sbemstr.sv 
../../../../../source/rtl/iosfsbc/endpoint/sbemstrreg.sv 
../../../../../source/rtl/iosfsbc/endpoint/sbendpoint.sv
../../../../../source/rtl/iosfsbc/endpoint/sbetrgt.sv 
../../../../../source/rtl/iosfsbc/endpoint/sbetrgtreg.sv 
"

set VHDL_SOURCE_FILES ""

lappend search_path "../../../../../source/rtl/iosfsbc/endpoint"
lappend search_path "../../../../../source/rtl/iosfsbc/common"
