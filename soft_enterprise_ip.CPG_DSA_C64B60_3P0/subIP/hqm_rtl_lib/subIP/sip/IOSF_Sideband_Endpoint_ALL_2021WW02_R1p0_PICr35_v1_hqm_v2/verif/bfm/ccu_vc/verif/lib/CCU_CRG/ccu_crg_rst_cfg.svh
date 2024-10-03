 //-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2010 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : njfotari
// Date Created : 28-02-2011 
//-----------------------------------------------------------------
// Description:
// Class for Reset configuration object
//------------------------------------------------------------------ 

`ifndef CCU_CRG_RST_CONFIG
`define CCU_CRG_RST_CONFIG

class ccu_crg_rst_cfg extends ovm_object;

   int            rst_id;
   string         rst_name;
   bit            rst_polarity;   //1: active high, 0: active low
   int            rst_length;     //how many cycle to assert - 0: dont deassert after asserting
   int            rst_resp_clk;   //respective clock
   bit            rst_auto;
   int            rst_ini_delay;  //After time 0, how many clocks to wait before asserting reset
   ccu_crg::ccu_crg_assert_e   rst_assert;
   ccu_crg::ccu_crg_assert_e   rst_deassert;
   ccu_crg::rst_initialize_polarity_e rst_ini_polarity;

   `ovm_object_utils_begin(ccu_crg_rst_cfg)
      `ovm_field_int(rst_id, OVM_ALL_ON)
      `ovm_field_string(rst_name, OVM_ALL_ON)
      `ovm_field_int(rst_polarity, OVM_ALL_ON)
      `ovm_field_int(rst_length, OVM_ALL_ON)
      `ovm_field_int(rst_resp_clk, OVM_ALL_ON)
      `ovm_field_int(rst_auto, OVM_ALL_ON)
      `ovm_field_int(rst_ini_delay, OVM_ALL_ON)
      `ovm_field_enum(ccu_crg::ccu_crg_assert_e,rst_assert, OVM_ALL_ON)
      `ovm_field_enum(ccu_crg::ccu_crg_assert_e,rst_deassert, OVM_ALL_ON)
      `ovm_field_enum(ccu_crg::rst_initialize_polarity_e,rst_ini_polarity, OVM_ALL_ON)
  `ovm_object_utils_end

  extern function       new   (string name = "");

endclass : ccu_crg_rst_cfg

function ccu_crg_rst_cfg::new(string name = "");
   // Super constructor
   super.new(name);
endfunction :new


`endif //CCU_CRG_RST_CONFIG
