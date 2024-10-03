
`ifndef INC_STAPTestPkg
`define INC_STAPTestPkg
    
   package STAPTestPkg;
      import uvm_pkg::*;
      import ovm_pkg::*;
      import xvm_pkg::*;
      import STapPkg::*;
      `include "ovm_macros.svh"
      `include "xvm_macros.svh"
      `include "tb_param.inc"
      `include "STAP_DfxSecurePlugin_TbDefines.svh"
      `include "STapBaseTest.sv"
	  `ifdef USE_CONVERGED_JTAGBFM
      `include "STapTests_Converged.sv"
	  `else
      `include "STapTests.sv"
	  `endif
      `include "dummy_simfigen_test/dummy_simfigen_test.svh"

   endpackage :STAPTestPkg
`endif //INC_STAPTestPkg	
