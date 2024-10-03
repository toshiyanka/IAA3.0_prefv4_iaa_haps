 `ifdef INTEL_CDC_ASSERTION
 module rcfwl_dft_reset_sync_cdc_assertions;
     `include "sva_assumptions_rcfwl_dft_reset_sync_bind.sv"  // Eg: sva_assumptions_adl_scf_io_top_bind.sv 
//     `include "sva_rules_prop_rcfwl_dft_reset_sync_bind.sv"   // these bind files will bind the assertions to the design 
 always@(rcfwl_dft_reset_sync.rst_b) 
     begin

     if(!(rcfwl_dft_reset_sync.rst_b === 1'bx))
         begin
         Assumption_mod.spyglass_assert = rcfwl_dft_reset_sync.rst_b;
         Assertion_mod.spyglass_assert = rcfwl_dft_reset_sync.rst_b;
         end
     else
         begin
         Assumption_mod.spyglass_assert = 1'b0;
         Assertion_mod.spyglass_assert = 1'b0;
         end
     end
 endmodule
     `include "sva_assumptions_rcfwl_dft_reset_sync_vcs.sv"   // this contains instances of assertions generated for each of the constraint 
//     `include "sva_rules_prop_rcfwl_dft_reset_sync_vcs.sv"    // this contains instances of assertions generated for each of the constraint 
     `include "sva_assumptions_definitions.sv"     // this contains definition of assertion modules for each constraint 
     `include "sva_rules_prop_definitions.sv"      // this contains definition of assertion modules for each constraint   
     `include "macro_lib.v"                      // this contains definition of some supporting functions 
     `include "rtlc.prim.v"                      // this contains definition of some supporting functions 
     `include "GlobalAssert.sv"                    // this contains declaration of global enable signal 
 `endif