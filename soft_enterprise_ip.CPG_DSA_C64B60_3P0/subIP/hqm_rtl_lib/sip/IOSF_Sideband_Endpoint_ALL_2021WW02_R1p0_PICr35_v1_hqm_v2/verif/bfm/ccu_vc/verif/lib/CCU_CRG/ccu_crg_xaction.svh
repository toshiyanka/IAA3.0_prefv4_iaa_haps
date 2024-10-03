//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2010 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : njfotari
// Date Created : 28-02-2011 
//-----------------------------------------------------------------
// Description:
// This file defines clock reset generator transaction class
//------------------------------------------------------------------ 

`ifndef CCU_CRG_XACTION
`define CCU_CRG_XACTION

class ccu_crg_xaction extends ovm_sequence_item;

   rand ccu_crg::ccu_crg_operations_e ccu_crg_op_i;
   rand int   clk_num[];
   rand int   rst_num[];
   rand time  clk_period[];
   rand int   clk_duty[];
   rand int   rst_delay[];

   protected ccu_crg_cfg r_cfg;
   protected int num_clk, num_rst;

   constraint ccu_crg_allowable_ops_c;
   constraint clk_rst_array_size_c;

   // ============================================================================
   // Standard functions 
   // ============================================================================
   extern function new (string name = "", 
                        ovm_sequencer_base sequencer = null,
                        ovm_sequence #(ovm_sequence_item,ovm_sequence_item) parent_seq = null
                       );
   extern function void set_cfg(ccu_crg_cfg cfg);                    
   extern function void pre_randomize();

   `ovm_object_utils_begin(ccu_crg_xaction)
      `ovm_field_enum(ccu_crg::ccu_crg_operations_e, ccu_crg_op_i, OVM_ALL_ON | OVM_NOCOMPARE | OVM_NOPACK)
      `ovm_field_array_int(clk_num, OVM_ALL_ON | OVM_NOCOMPARE | OVM_NOPACK)
      `ovm_field_array_int(rst_num, OVM_ALL_ON | OVM_NOCOMPARE | OVM_NOPACK)
      `ovm_field_array_int(clk_duty, OVM_ALL_ON | OVM_NOCOMPARE | OVM_NOPACK)
      `ovm_field_array_int(clk_period, OVM_ALL_ON | OVM_NOCOMPARE | OVM_NOPACK)
      `ovm_field_array_int(rst_delay, OVM_ALL_ON | OVM_NOCOMPARE | OVM_NOPACK)
   `ovm_object_utils_end   

endclass : ccu_crg_xaction

function ccu_crg_xaction::new (string name="",
                           ovm_sequencer_base sequencer = null,
		                     ovm_sequence #(ovm_sequence_item,ovm_sequence_item) parent_seq = null
                          );
  // Super constructor
  super.new(name,sequencer,parent_seq);
endfunction :new

/////////////////////////////////////////////////////
//This function sets reference configuration object
/////////////////////////////////////////////////////
function void ccu_crg_xaction::set_cfg(ccu_crg_cfg cfg);
   r_cfg = cfg;
endfunction: set_cfg

/////////////////////////////////////////////////////
//This function extracts value of num_clk and num_rst 
//from configuration object, if that is not set uses 
//default values
/////////////////////////////////////////////////////
function void ccu_crg_xaction::pre_randomize();
   if (r_cfg != null) begin
      num_clk = r_cfg.num_clks; 
      num_rst = r_cfg.num_rsts; 
   end else begin
      //if configuration object is not passed, use default values of 100
      num_clk = 100;
      num_rst = 100;
   end
endfunction : pre_randomize

constraint ccu_crg_xaction::ccu_crg_allowable_ops_c {
   ccu_crg_op_i inside {
      ccu_crg::OP_NONE,
      ccu_crg::OP_CLK_GATE,
      ccu_crg::OP_CLK_UNGATE,
      ccu_crg::OP_CLK_FREQ,
      ccu_crg::OP_DUTY_CYCLE,
      ccu_crg::OP_CLK_GATE_ALL,
      ccu_crg::OP_CLK_UNGATE_ALL,
      ccu_crg::OP_RST_ASSERT,
      ccu_crg::OP_RST_DEASSERT,
      ccu_crg::OP_RST_ASSERT_SYNC,
      ccu_crg::OP_RST_DEASSERT_SYNC,
      ccu_crg::OP_RST_ASSERT_ASYNC,
      ccu_crg::OP_RST_DEASSERT_ASYNC,
      ccu_crg::OP_RST_ASSERT_ALL,
      ccu_crg::OP_RST_DEASSERT_ALL
   };
}

constraint ccu_crg_xaction::clk_rst_array_size_c {
   //Use 100 becuase interface is defined to maximum clocks & resets of 100
   clk_num.size() <= num_clk;
   rst_num.size() <= num_rst;
   clk_period.size() <= num_clk;
   rst_delay.size() <= num_rst;
   clk_duty.size() <= num_clk;
  
   ccu_crg_op_i inside {ccu_crg::OP_CLK_GATE, 
      ccu_crg::OP_CLK_UNGATE,
      ccu_crg::OP_CLK_GATE_ALL, 
      ccu_crg::OP_CLK_UNGATE_ALL} -> clk_period.size() == 0;

   ccu_crg_op_i == ccu_crg::OP_CLK_FREQ -> clk_period.size() == clk_num.size();
   ccu_crg_op_i == ccu_crg::OP_DUTY_CYCLE -> clk_duty.size() == clk_num.size();

   ccu_crg_op_i inside {ccu_crg::OP_CLK_GATE, 
      ccu_crg::OP_CLK_UNGATE, 
      ccu_crg::OP_CLK_FREQ, 
      ccu_crg::OP_CLK_GATE_ALL, 
      ccu_crg::OP_CLK_UNGATE_ALL} -> ((rst_num.size() == 0) && (rst_delay.size() == 0));

   ccu_crg_op_i inside {ccu_crg::OP_RST_ASSERT,
      ccu_crg::OP_RST_DEASSERT,
      ccu_crg::OP_RST_ASSERT_SYNC,
      ccu_crg::OP_RST_DEASSERT_SYNC,
      ccu_crg::OP_RST_ASSERT_ASYNC,
      ccu_crg::OP_RST_DEASSERT_ASYNC,
      ccu_crg::OP_RST_ASSERT_ALL,
      ccu_crg::OP_RST_DEASSERT_ALL} -> ((clk_num.size() == 0) && (clk_period.size() == 0));

   ccu_crg_op_i inside {ccu_crg::OP_RST_ASSERT,
      ccu_crg::OP_RST_DEASSERT,
      ccu_crg::OP_RST_ASSERT_SYNC,
      ccu_crg::OP_RST_DEASSERT_SYNC,
      ccu_crg::OP_RST_ASSERT_ASYNC,
      ccu_crg::OP_RST_DEASSERT_ASYNC} -> ((rst_num.size() == rst_delay.size()));    
}

`endif // CCU_CRG_XACTION

