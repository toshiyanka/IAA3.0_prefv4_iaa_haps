//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2010 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : njfotari
// Date Created : 28-02-2011 
//-----------------------------------------------------------------
// Description:
// Config parameter object, will be used in test island to pass parameters
//------------------------------------------------------------------

`ifndef CCU_CRG_PARAM_CFG
`define CCU_CRG_PARAM_CFG

/**
 * Data structure holding configuration data for the IOSF sideband interface endpoint
 */
class ccu_crg_param_cfg extends ovm_object;
  // ============================================================================
  // Data members 
  // ============================================================================
  int num_clks;
  int num_rsts;

  // ============================================================================
  // Standard Functions 
  // ============================================================================
  extern function new(string name = "");
 
  // ============================================================================
  // OVM Macros 
  // ============================================================================
  `ovm_object_utils_begin(ccu_crg_param_cfg)
    `ovm_field_int(num_clks, OVM_ALL_ON)
    `ovm_field_int(num_rsts, OVM_ALL_ON)
  `ovm_object_utils_end
endclass :ccu_crg_param_cfg
  
/**
 * ccu_crg_param_cfg class constructor
 * @param name  OVM name
 * @return Constructed component of type ccu_crg_param_cfg
 */
function ccu_crg_param_cfg::new(string name);
      super.new(name);

      //DEFAULT VALUES
      num_clks= 8;
      num_rsts= 8;
     
endfunction :new

`endif //CCU_CRG_PARAM_CFG 
