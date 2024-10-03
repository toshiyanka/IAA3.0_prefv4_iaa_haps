//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2011 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : rravindr
// Date Created : 2012-06-01 
//-----------------------------------------------------------------
// Description:
// ccu_vc_cfg class definition as part of ccu_vc_pkg
//------------------------------------------------------------------

`ifndef INC_ccu_vc_cfg
`define INC_ccu_vc_cfg 

/**
 * ccu_vc env config descriptor
 */
class ccu_vc_cfg extends ovm_object;
   //------------------------------------------
   // Data Members 
   //------------------------------------------
   ovm_active_passive_enum is_active = OVM_ACTIVE;
   int is_active_ti;
   ccu_crg_cfg i_ccu_crg_cfg;
   ccu_ob_cfg i_ccu_ob_cfg ; 
   int num_slices = 512;
   bit sync_clkack = 0;
   int gusync_ref_clk = 0;
   bit start_gusync_cnt = 1'b0;
   bit[15:0] gusync_counter = 16'h40; // 64
   int req1_to_clk1_max[512];
   int clk1_to_ack1_max[512];
   int req0_to_ack0_max[512];
   int clkack_delay_max[512];
   
   slice_cfg slices[int];
   clksrc_cfg clk_sources[int];
 
   //------------------------------------------
   // Constraints 
   //------------------------------------------
  
   //------------------------------------------
   // Methods 
   //------------------------------------------
  
   // Standard OVM Methods 
   extern function new (string name = "");
 
   // APIs 
   extern function void set_to_passive ();
   extern function int get_num_slices ();
   extern function void set_sync_clkack(bit ctrl_sync_clkack);
   extern function bit add_clk_source (
                          int clk_num ,               
                          string clk_name,
                          time period 
                         );
   extern function bit randomize_clk_sources ();
   extern function bit add_slice (
                          int slice_num ,               
                          string slice_name,
                          int clk_src = 0,
                          ccu_types::clk_gate_e clk_status = ccu_types::CLK_GATED,
                          ccu_types::div_ratio_e divide_ratio = ccu_types::DIV_1,
						  int half_divide_ratio = 0,
						  int in_phase_with_slice_num = 1024,
						  int dcg_blk_num = 1024,
						  bit set_zero_delay = 0,
						  bit always_running = 0,
						  time req1_to_clk1 = 0,
						  int clk1_to_ack1 = 0,
						  int req0_to_ack0 = 0,
						  int clkack_delay = 8,
						  bit enable_random_phase = 1,
						  int duty_cycle=50,
						  bit randomize_req1_to_clk1 = 0,
						  bit randomize_clk1_to_ack1 = 0,
						  bit randomize_req0_to_ack0 = 0,
						  bit randomize_clkack_delay = 0,
						  time freq_change_delay = 0,
						  ccu_types::def_status_e def_status = ccu_types::DEF_OFF,
                          bit usync_enabled = 0
                        );
   extern function void set_ref_clk_src (int ref_clk_src);
   extern function void set_global_usync_counter (bit[15:0] count);
   extern function void ctrl_gusync_cnt(bit ctrl_start_cnt);
   extern function time get_clk_period(int slice_num);
   
   // OVM Macros 
   `ovm_object_utils_begin (ccu_vc_pkg::ccu_vc_cfg)
      `ovm_field_enum (ovm_active_passive_enum, is_active, OVM_ALL_ON)
      `ovm_field_int (num_slices, OVM_ALL_ON|OVM_DEC)
      `ovm_field_object (i_ccu_crg_cfg, OVM_ALL_ON)
      `ovm_field_object (i_ccu_ob_cfg,  OVM_ALL_ON)
      `ovm_field_sarray_object (slices,  OVM_ALL_ON)
      `ovm_field_sarray_object (clk_sources,  OVM_ALL_ON)
   `ovm_object_utils_end
endclass :ccu_vc_cfg

/**
 * ccu_vc_cfg Class constructor
 * @param   name  OVM name
 * @return        A new object of type ccu_vc_cfg 
 */
function ccu_vc_cfg::new (string name = "");
   // Super constructor
   super.new(name);
   i_ccu_crg_cfg = ccu_crg_cfg::type_id::create("i_ccu_crg_cfg");
   i_ccu_ob_cfg = ccu_ob_cfg::type_id::create("ccu_ob_cfg");
endfunction :new

function void ccu_vc_cfg::set_to_passive ();

   this.is_active = OVM_PASSIVE;
   i_ccu_crg_cfg.set_state(OVM_PASSIVE);
   i_ccu_ob_cfg.is_active = OVM_PASSIVE;
   if(is_active_ti !== 0)
	   `ovm_error("CCU_VC_CFG", $psprintf("Please set ccu_vc_ti parameter IS_ACTIVE to 0"))

endfunction :set_to_passive

function bit ccu_vc_cfg::add_slice (
                int slice_num ,               
                string slice_name,
                int clk_src = 0,
                ccu_types::clk_gate_e clk_status = ccu_types::CLK_GATED,
                ccu_types::div_ratio_e divide_ratio = ccu_types::DIV_1,
                int half_divide_ratio = 0,
				int in_phase_with_slice_num = 1024,
				int dcg_blk_num = 1024,
				bit set_zero_delay = 0,
				bit always_running = 0,
			    time req1_to_clk1 = 0,
				int clk1_to_ack1 = 0,
				int req0_to_ack0 = 0,
				int clkack_delay = 8,
				bit enable_random_phase = 1,
				int duty_cycle = 50,
				bit randomize_req1_to_clk1 = 0,
				bit randomize_clk1_to_ack1 = 0,
				bit randomize_req0_to_ack0 = 0,
				bit randomize_clkack_delay = 0,
				time freq_change_delay = 0,
				ccu_types::def_status_e def_status = ccu_types::DEF_OFF,
			   	bit usync_enabled = 0
              );
  if (slices.size() < num_slices) 
    if ( ! slices.exists(slice_num))
    begin
      slices[slice_num] = slice_cfg::type_id::create($psprintf("slice_cfg[%0d]", slice_num));
      slices[slice_num].slice_num = slice_num;
      slices[slice_num].slice_name = slice_name;
      slices[slice_num].clk_src = clk_src;
	  slices[slice_num].in_phase_with_slice_num = in_phase_with_slice_num;
	  slices[slice_num].dcg_blk_num = dcg_blk_num;
	  slices[slice_num].set_zero_delay = set_zero_delay;
	  slices[slice_num].always_running = always_running;
	  slices[slice_num].req1_to_clk1 = req1_to_clk1;
	  slices[slice_num].clk1_to_ack1 = clk1_to_ack1;
	  slices[slice_num].req0_to_ack0 = req0_to_ack0;
	  if(def_status == ccu_types::DEF_OFF)
      	slices[slice_num].clk_status = clk_status;
  	  else
		slices[slice_num].clk_status = ccu_types::CLK_UNGATED;
      slices[slice_num].divide_ratio = divide_ratio;
	  slices[slice_num].half_divide_ratio = half_divide_ratio;
	  slices[slice_num].clkack_delay = clkack_delay;
	  slices[slice_num].enable_random_phase = enable_random_phase;
	  slices[slice_num].duty_cycle = duty_cycle;
	  slices[slice_num].randomize_req1_to_clk1 = randomize_req1_to_clk1;
	  slices[slice_num].randomize_clk1_to_ack1 = randomize_clk1_to_ack1;
	  slices[slice_num].randomize_req0_to_ack0 = randomize_req0_to_ack0;
	  slices[slice_num].randomize_clkack_delay = randomize_clkack_delay;
	  slices[slice_num].freq_change_delay = freq_change_delay;
	  slices[slice_num].def_status = def_status;
      slices[slice_num].usync_enabled = usync_enabled;
	  req1_to_clk1_max[slice_num] = req1_to_clk1;
	  clk1_to_ack1_max[slice_num] = clk1_to_ack1;
	  req0_to_ack0_max[slice_num] = req0_to_ack0;
	  clkack_delay_max[slice_num] = clkack_delay;
    end
    else
    begin
      `ovm_error("CCU VC CFG", $psprintf("Slice %0d already exists", slice_num))
      return 0;
    end
  else
  begin
      `ovm_error("CCU VC CFG", "NUM_SLICES already reached, you can't add more slices")
      return 0;
  end
  return 1;
endfunction

function int ccu_vc_cfg::get_num_slices ();
  return num_slices;
endfunction

function bit ccu_vc_cfg::randomize_clk_sources ();
  for (int i=0;i<48;i++)
  begin
    clk_sources[i] = clksrc_cfg::type_id::create($psprintf("clksrc_cfg[%0d]", i));
   assert( clk_sources[i].randomize());
   clk_sources[i].clk_num = i;
   clk_sources[i].clk_name = $psprintf("CLK_%0d", i);
  end
endfunction

function bit ccu_vc_cfg::add_clk_source ( int clk_num ,               
                                          string clk_name,
                                          time period 
                                        );
   if (clk_sources.size() < 48) 
    if ( ! slices.exists(clk_num))
    begin
      clk_sources[clk_num] = clksrc_cfg::type_id::create($psprintf("clksrc_cfg[%0d]", clk_num));
      clk_sources[clk_num].clk_num = clk_num;
      clk_sources[clk_num].clk_name = clk_name;
      clk_sources[clk_num].period = period;
    end
    else
    begin
      `ovm_error("CCU VC CFG", $psprintf("Clock Source %0d already exists", clk_num))
      return 0;
    end
  else
  begin
      `ovm_error("CCU VC CFG", "48 Clock Sources already added, you can't add more clock sources")
      return 0;
  end
  return 1;
 
endfunction

function void ccu_vc_cfg::set_sync_clkack(bit ctrl_sync_clkack);
	sync_clkack = ctrl_sync_clkack;
endfunction

function void ccu_vc_cfg::set_ref_clk_src (int ref_clk_src);
  if (ovm_top.m_curr_phase.get_name() == "run")
    `ovm_error("CCU VC CFG","Changing reference clock during run phase is not allowed")
  gusync_ref_clk = ref_clk_src;
endfunction

function void ccu_vc_cfg::set_global_usync_counter (bit[15:0] count);
  gusync_counter = count;
endfunction

function void ccu_vc_cfg::ctrl_gusync_cnt(bit ctrl_start_cnt);
	start_gusync_cnt = ctrl_start_cnt;
endfunction

function time ccu_vc_cfg::get_clk_period(int slice_num);
	if(slice_num > num_slices) begin
		`ovm_error("CCU_VC_CFG","Requesting clk period info for an invalid slice number")
		return 0;
	end
	else
		return i_ccu_crg_cfg.clk_list_i[slice_num].clk_period;
endfunction
	
`endif //INC_ccu_vc_cfg

