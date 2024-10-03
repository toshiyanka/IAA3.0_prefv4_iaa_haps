//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2010 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : njfotari
// Date Created : 25-02-2011 
//-----------------------------------------------------------------
// Description:
// Class for Clock Reset Generator defines, enumerations
//------------------------------------------------------------------


//parameter int NUM_CLKS = 8;
//parameter int NUM_RSTS = 8;

`ifndef CCU_CRG_CLASS
`define CCU_CRG_CLASS

class ccu_crg;

   typedef enum {
       ASYNC,
       SYNC 
   } ccu_crg_assert_e;

   typedef enum bit {
       GATE = 1,
       UNGATE = 0 
   } ccu_crg_gate_e;

   typedef enum bit {
       ON = 1,
       OFF = 0 
   } ccu_crg_jitter_e;


   typedef enum bit[3:0] {
      OP_NONE                 = 4'b0000, 
      OP_CLK_GATE             = 4'b0001, 
      OP_CLK_UNGATE           = 4'b0010,
      OP_CLK_FREQ             = 4'b0011,
      OP_DUTY_CYCLE           = 4'b0100, 
      OP_CLK_GATE_ALL         = 4'b0101,
      OP_CLK_UNGATE_ALL       = 4'b0110,
      OP_RST_ASSERT           = 4'b0111,
      OP_RST_DEASSERT         = 4'b1000,
      OP_RST_ASSERT_SYNC      = 4'b1001,
      OP_RST_DEASSERT_SYNC    = 4'b1010,
      OP_RST_ASSERT_ASYNC     = 4'b1011,
      OP_RST_DEASSERT_ASYNC   = 4'b1100,
      OP_RST_ASSERT_ALL       = 4'b1101,
      OP_RST_DEASSERT_ALL     = 4'b1110
   } ccu_crg_operations_e;

   typedef enum {
       ASSERTED,
       DEASSERTED
   } rst_initialize_polarity_e; 

endclass: ccu_crg  

`endif // CCU_CRG_CLASS
