//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2011 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : bosman3 
// Date Created : 2012-06-03 
//-----------------------------------------------------------------
// Description:
// ccu_types class definition as part of ccu_types_pkg
//------------------------------------------------------------------

`ifndef INC_ccu_types
`define INC_ccu_types 

/**
 * Include all the types/constants/parameters used inside ccu_types collateral
 */
class ccu_types extends ovm_object;
   // TODO: Add all your defines as static members here
   static const time default_timeout = 10_000us;

   typedef enum bit{CLK_GATED, CLK_UNGATED} clk_gate_e;
   typedef enum bit[4:0] {DUMMY_0, DIV_1, DIV_2, DIV_3, DIV_4, DIV_5, DIV_6, DIV_7, DIV_8, 
	   					  DIV_9, DIV_10, DIV_11, DIV_12, DIV_13, DIV_14, DIV_15, DIV_16} div_ratio_e;
   typedef enum bit[4:0] {GATE, UNGATE, DIVIDE_RATIO, HALF_DIVIDE_RATIO, CLKACK_DLY,CLK_SRC, EN_USYNC, DIS_USYNC,
	   PHASE_SHIFT, REQ1_TO_CLK1, REQ0_TO_ACK0, CLK1_TO_ACK1, FREQ_CHANGE_DLY} cmd_e;

   typedef enum bit{DEF_OFF,DEF_ON} def_status_e;
endclass :ccu_types

`endif //INC_ccu_types

