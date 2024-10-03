-sv $OVM_HOME/src/ovm_pkg.sv
-sv $UVM_HOME/src/uvm_pkg.sv
-sv $XVM_HOME/src/xvm_pkg.sv
-sv $JTAG_BFM_VER/verif/tb/Converged_JtagBfm/testbench/dfx_tap_env_pkg.sv 
-sv $JTAG_BFM_VER/verif/tb/Converged_JtagBfm/modules/dfx_jtag_if.sv 
-sv $JTAG_BFM_VER/verif/tb/Converged_JtagBfm/modules/dfx_test_island.sv 
-sv $JTAG_BFM_VER/verif/tb/Converged_JtagBfm/sequences/dfx_tap_seqlib_pkg.sv 

+incdir+$JTAG_BFM_VER/verif/tb/Converged_JtagBfm/testbench 
+incdir+$JTAG_BFM_VER/verif/tb/Converged_JtagBfm/sequences
+incdir+$OVM_HOME/src
+incdir+$XVM_HOME/src
+incdir+$UVM_HOME/src
+incdir+$XVM_HOME/src/macros
+incdir+$JTAG_BFM_VER/verif/tb/Converged_JtagBfm/sequences
+incdir+$JTAG_BFM_VER/verif/tb/Converged_JtagBfm/testbench
