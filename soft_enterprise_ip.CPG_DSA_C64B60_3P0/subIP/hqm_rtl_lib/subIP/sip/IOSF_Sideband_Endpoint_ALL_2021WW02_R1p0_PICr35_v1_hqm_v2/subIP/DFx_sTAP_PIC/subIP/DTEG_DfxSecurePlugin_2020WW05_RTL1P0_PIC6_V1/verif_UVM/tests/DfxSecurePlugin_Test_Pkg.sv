
`ifndef INC_DfxSecurePlugin_Test_Pkg
`define INC_DfxSecurePlugin_Test_Pkg

   package DfxSecurePlugin_Test_Pkg; 
  
   //--------------------------
   // Including the Test Files
   //--------------------------
    import uvm_pkg::*;
   `include "uvm_macros.svh"
    import DfxSecurePlugin_Pkg::*;
   `include "DfxSecurePlugin_BaseTest.sv"
   `include "DfxSecurePlugin_TestLib.sv"
   `include "dummy_simfigen_test.svh"

   endpackage: DfxSecurePlugin_Test_Pkg

`endif // INC_DfxSecurePlugin_Test_Pkg
