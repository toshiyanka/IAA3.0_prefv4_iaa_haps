//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2011 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : bosman3 
// Date Created : 2012-06-03 
//-----------------------------------------------------------------
// Description:
// ccu_vc_ti interface definition
//------------------------------------------------------------------

/**
 * ccu_vc Test Island
 */

module ccu_vc_ti #(parameter int NUM_SLICES = 1, 
				   parameter bit IS_ACTIVE = 1,
			   	   parameter string IP_ENV_TO_AGT_PATH = "", 
			   	   parameter time REQ1_CLK1_MIN [NUM_SLICES] = '{default:100ps},
			   	   parameter int CLK1_ACK1_MIN [NUM_SLICES]  = '{default:2},
			   	   parameter int REQ0_ACK0_MIN [NUM_SLICES]  = '{default:2},
				   parameter int ACK0_CLK0_MIN [NUM_SLICES]  = '{default:8},
			       parameter time REQ1_CLK1_MAX [NUM_SLICES] = '{default:1000ns},
			   	   parameter int CLK1_ACK1_MAX [NUM_SLICES]  = '{default:20},
			   	   parameter int REQ0_ACK0_MAX [NUM_SLICES]  = '{default:20},
			   	   parameter int ACK0_CLK0_MAX [NUM_SLICES]  = '{default:50}) (interface ccu_intf);
   
   import ovm_pkg::*;
   bit ref_clk;
   bit checker_clk;
   string checker_name = {IP_ENV_TO_AGT_PATH," ccu checker"};
   string plusarg_maxtime;
   time max_ungate_time;
   //------------------------------------------
   // Block Comment 
   //------------------------------------------
   
   generate 
   if(IS_ACTIVE) begin:ccu_gen_blk
   ccu_crg_intf #(.NUM_CLKS(NUM_SLICES+1))
              ccu_crg_if (.clocks({ref_clk, ccu_intf.clk}), .ungated_clocks(),.resets());

   ccu_crg_ti #(.NUM_CLKS(NUM_SLICES+1))
            i_ccu_crg_ti (.i_ccu_crg_intf(ccu_crg_if));

   ccu_ob_intf ccu_ob_if ();

   ccu_ob_ti #(.IP_ENV_TO_AGT_PATH(IP_ENV_TO_AGT_PATH)) i_ccu_ob_ti (.ccu_ob_intf(ccu_ob_if));

   assign ccu_ob_if.ob[0][NUM_SLICES-1:0] = ccu_intf.clkreq[NUM_SLICES-1:0];
   assign ccu_intf.clkack = ccu_ob_if.ob[1][NUM_SLICES-1:0] ;
   assign ccu_intf.usync = ccu_ob_if.ob[2][NUM_SLICES-1:0] ;
   assign ccu_intf.globalusync = ccu_ob_if.ob[3][0];

   end
   endgenerate
   bit [512-NUM_SLICES:0] tmp_clk;
   bit [512-NUM_SLICES:0] tmp_clkreq;
   bit [512-NUM_SLICES:0] tmp_clkack;
   bit [512-NUM_SLICES:0] tmp_usync;
   bit [512-NUM_SLICES:0] tmp_reset;
   bit [512-NUM_SLICES:0] tmp_global_rst_b;
   bit [512-NUM_SLICES:0] tmp_pwell_pok;
   ccu_np_intf ccu_np_if(.clk({tmp_clk, ccu_intf.clk}),
   						 .clkack({tmp_clkack, ccu_intf.clkack}),
					 	 .clkreq({tmp_clkreq, ccu_intf.clkreq}),
					 	 .usync({tmp_usync, ccu_intf.usync}),
						 .reset({tmp_reset, ccu_intf.reset}),
						 .global_rst_b({tmp_global_rst_b,ccu_intf.global_rst_b}),
						 .pwell_pok({tmp_pwell_pok,ccu_intf.pwell_pok}),
					 	 .globalusync(ccu_intf.globalusync));
 
   initial
   begin
	 sla_pkg::sla_vif_container #(virtual ccu_np_intf) ccu_vc_IFcontainer;
     string s = $psprintf("%m.ccu_gen_blk");
	 set_config_int({IP_ENV_TO_AGT_PATH,"*"}, "CCU_VC_IS_ACTIVE_TI", IS_ACTIVE);
     set_config_int({IP_ENV_TO_AGT_PATH,"*"}, "CCU_VC_NUM_SLICES", NUM_SLICES);
     set_config_string({IP_ENV_TO_AGT_PATH,"*"}, "CCU_VC_ccu_crg_TI_NAME", {s, ".i_ccu_crg_ti"});
	 ccu_vc_IFcontainer = new("ccu_vc_if_container");
	 ccu_vc_IFcontainer.set_v_if(ccu_np_if);
	 set_config_object({IP_ENV_TO_AGT_PATH,"*"},"ccu_vc_if_container",ccu_vc_IFcontainer,0);
	 if(IP_ENV_TO_AGT_PATH == "" || IP_ENV_TO_AGT_PATH == "*")
		`ovm_error("CCU VC TI", $psprintf("IP_ENV_TO_AGT_PATH string is empty in ccu vc test island!!"))
	 $value$plusargs("MAX_CLK_UNGATE_TIME=%s", plusarg_maxtime);
	 max_ungate_time = sla_utils::str_to_time(plusarg_maxtime);
  end

  `include "ccu_vc_checker.svh" 

endmodule: ccu_vc_ti

