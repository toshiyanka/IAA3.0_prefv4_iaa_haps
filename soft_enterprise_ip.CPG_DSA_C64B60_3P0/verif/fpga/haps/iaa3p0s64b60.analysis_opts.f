-sverilog
-nc
-kdb
+libext+.v+.sv+.vs+.vh+.vi+.inc
-timescale=1ps/1ps
-debug_access+all
-xlrm uniq_prior_final
-assert svaext
+incdir+$UVM_HOME/src
+incdir+$OVM_HOME/src
#+incdir+$IOSF_PVC_ROOT
#+incdir+$IOSF_PVC_ROOT/ph5/common
+incdir+$IOSF_SVC_ROOT
+incdir+$IOSF_SVC_ROOT/tb/common
+incdir+$SAOLA_HOME/verilog_uvm
+incdir+$SAOLA_HOME/verilog_ovm
+define+VCS
+define+VCSSIM
#MG - To turn off assertions +define+ASSERT_ON
+define+INTEL_INST_ON
#+define+INTEL_SIMONLY
+define+RAM_IMPL=generic
+define+SLA_RAL_ADDR_WIDTH=64
+define+SLA_RAL_DATA_WIDTH=64
+define+SLA_RAL_IS_UVM
+define+SLU_STANDARD_UVM
+define+UVM_NO_DEPRECATED
+define+IOSFTRKCHK_NO_DEPENDENCIES
+define+IOSF_DEBUG_DISABLE
#+define+IOSFSB_UVM
+define+IOSF_SB_PH2
+define+IAA3P0S64B60
+define+EIP_DO_NOT_USE_FUSE
+define+IAA_SHOW_INFO=1
+define+IAA_UPF_SIM
#-liblist UPF+LPA
#-error=IPDW
#-error=DCTL
#-error=TMBIN

# Pass in coverage args from makefile
#$VCSSIM_COV_COMP_OPTS

# To skip Translate
-skip_translate_body

#+librescan

#+define+INTEL_EMULATION 
+define+INTEL_FPGA
+define+INTEL_FAKE_MEM
#+define+default_clk=null    
#-Xmf=0x80000 
