//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2010 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : njfotari
// Date Created : 28-02-2011 
//-----------------------------------------------------------------
// Description:
// Class for Clock and reset configuration objects
//------------------------------------------------------------------ 

`ifndef CCU_CRG_CONFIG
`define CCU_CRG_CONFIG

class ccu_crg_cfg extends ovm_object;

   ccu_crg_domain_cfg  domain_list_i[string];
   ccu_crg_clk_cfg  clk_list_i[int];
   ccu_crg_rst_cfg  rst_list_i[int];
   bit      gate_all_clocks; //0=dont gate, 1=gate
   bit      assert_all_reset; 
   bit      deassert_all_reset;
   int      num_clks;
   int      num_rsts;
   protected string   ti_name;

   // Knobs
   protected ovm_active_passive_enum is_active;

   `ovm_object_utils_begin(ccu_crg_cfg)
      //`ovm_field_array_object(clk_list_i, OVM_ALL_ON)
      //`ovm_field_array_object(rst_list_i, OVM_ALL_ON)
      `ovm_field_int(gate_all_clocks, OVM_ALL_ON)
      `ovm_field_int(assert_all_reset, OVM_ALL_ON)
      `ovm_field_int(deassert_all_reset, OVM_ALL_ON)
      `ovm_field_string(ti_name, OVM_ALL_ON)
      `ovm_field_enum   (ovm_active_passive_enum, is_active, OVM_ALL_ON)
  `ovm_object_utils_end

  extern function       new   (string name = "");
  extern function void  set_state (ovm_active_passive_enum state);
  extern function ovm_active_passive_enum get_state ();
  extern function bit   check_domain_exists(string name);
  extern function bit   check_clk_exists(int number);
  extern function bit   check_rst_exists(int number);
  extern function       set_param (int clk_num, int rst_num); 
  extern function bit  check_domain_period_valid(time period, string domain_name);
  extern function bit  update_domain_period(int clk_id, time old_period, time new_period);
  extern function void   set_ti_name(string ti_name);
  extern function string get_ti_name();

  extern function bit   set_clock_domain(string domain_name="", time phase_delay);
  extern function bit   add_clock(int clock_number, string clock_name, string domain_name="", time period, bit
  auto=1,int dcg_blk_num=1024, int in_phase_with=1024,int duty_cycle=50, ccu_crg::ccu_crg_jitter_e jitter=ccu_crg::OFF);
  extern function bit   add_reset(int reset_number, string reset_name, bit polarity, int num_cycle=0, int resp_clock=0, ccu_crg::ccu_crg_assert_e assertion=ccu_crg::ASYNC, ccu_crg::ccu_crg_assert_e deassertion=ccu_crg::ASYNC, bit auto=1, int initial_delay=0, ccu_crg::rst_initialize_polarity_e ini_polarity=ccu_crg::DEASSERTED);

endclass : ccu_crg_cfg

function ccu_crg_cfg::new(string name = "");
   // Super constructor
   super.new(name);
   // Default knobs
   is_active = OVM_ACTIVE;
endfunction :new

/**
 * Changes the environment state to active/passive
 * - Calling it after the object is constructed and passed to env has no effect
 * - Should be called before randomization, calling it before randomization 
 * causes unexpected behavior
 * @param state new state (OVM_ACTIVE or OVM_PASSIVE)
 */
function void ccu_crg_cfg::set_state (ovm_active_passive_enum state);
   //Save state
   is_active = state;
endfunction : set_state

/**
 * Retreive environment state
 * @return OVM_ACTIVE/OVM_PASSIVE
 */
function ovm_active_passive_enum ccu_crg_cfg::get_state ();
   return is_active;
endfunction : get_state

function bit ccu_crg_cfg::check_domain_exists(string name);

   foreach (domain_list_i[i]) begin
      if (domain_list_i[i] == null)
         continue;
      if (domain_list_i[i].domain_name == name)
         return 1;
   end
   return 0;
endfunction :check_domain_exists


function bit ccu_crg_cfg::check_clk_exists(int number);

   foreach (clk_list_i[i]) begin
      if (clk_list_i[i] == null)
         continue;
      if (clk_list_i[i].clk_id == number)
         return 1;
   end
   return 0;
endfunction :check_clk_exists

function bit ccu_crg_cfg::check_rst_exists(int number);

   foreach (rst_list_i[i]) begin
      if (rst_list_i[i].rst_id == number)
         return 1;
   end
   return 0;
endfunction :check_rst_exists

function ccu_crg_cfg::set_param (int clk_num, int rst_num);
   num_clks = clk_num;
   num_rsts = rst_num;
endfunction : set_param
/////////////////////////////////////////////////////////////////////////////
//This task defines clock domains to the configuration descriptor
/////////////////////////////////////////////////////////////////////////////
function bit ccu_crg_cfg::set_clock_domain(string domain_name, time phase_delay);
   // locals
   string msg;
   
   ccu_crg_domain_cfg clk_domain_temp_i;

   // Check domain name is already defined
   if (check_domain_exists(domain_name)) begin
      $sformat(msg, "%s is already defined as domain", domain_name);
      `ovm_error("ccu_crg_CFG", msg)
      return 0;
   end else begin
      // Echo added clock
      $sformat(msg, "Adding domain name  = %s, Phase delay = %0t", domain_name, phase_delay);
      `ovm_info("ccu_crg_CFG", msg, OVM_MEDIUM)
      clk_domain_temp_i = new(domain_name);

      // Start adding clock

      clk_domain_temp_i.domain_name        = domain_name;
      clk_domain_temp_i.domain_phase_delay   = phase_delay;

      domain_list_i[clk_domain_temp_i.domain_name] = ccu_crg_domain_cfg::type_id::create();
      domain_list_i[clk_domain_temp_i.domain_name] = clk_domain_temp_i;
      //end
   end
   // Return success
   return 1;
endfunction :set_clock_domain


/////////////////////////////////////////////////////////////////////////////
//This task adds a clock to the configuration descriptor
/////////////////////////////////////////////////////////////////////////////
function bit ccu_crg_cfg::add_clock(int clock_number, string clock_name, string domain_name="", time period, bit auto=1,int dcg_blk_num=1024, int in_phase_with=1024, int duty_cycle=50, ccu_crg::ccu_crg_jitter_e jitter=ccu_crg::OFF);
   // locals
   string msg;
 //  int x; 
//   realtime a, x;
//   realtime b[*];
   ccu_crg_clk_cfg clk_cfg_temp_i;
   ccu_crg_domain_cfg clk_domain_temp_i;

   // Check clock number is already defined
   if (check_clk_exists(clock_number)) begin
      $sformat(msg, "%d is already defined as clock", clock_number);
      `ovm_error("ccu_crg_CFG", msg)
      return 0;
   end else begin
      // Echo added clock
      $sformat(msg, "Adding clock: Number = %d, Period = %0t", clock_number, period);
      `ovm_info("ccu_crg_CFG", msg, OVM_MEDIUM)
      clk_cfg_temp_i = new(clock_name);

      // Start adding clock
      clk_cfg_temp_i.clk_id            = clock_number;
      clk_cfg_temp_i.clk_name          = clock_name;
      clk_cfg_temp_i.clk_period        = period;
      clk_cfg_temp_i.clk_domain        = domain_name;
      clk_cfg_temp_i.clk_auto          = auto;
	  clk_cfg_temp_i.dcg_blk_num 	   = dcg_blk_num;
	  clk_cfg_temp_i.in_phase_with 	   = in_phase_with;
      clk_cfg_temp_i.clk_duty_cycle    = duty_cycle;
      clk_cfg_temp_i.jitter            = jitter;

      //If clock shouldnt start automatically, then gate the clock
      if (auto == 0) begin
         clk_cfg_temp_i.clk_gating        = ccu_crg::GATE; 
      end else begin
         clk_cfg_temp_i.clk_gating        = ccu_crg::UNGATE; 
      end

      //if (clk_cfg_temp_i.clk_id >= num_clks) begin
      //   $sformat(msg, "Clock number specified is greater than maximum number of defined clocks, please increase NUM_CLKS");
      //   `ovm_error("ccu_crg_CFG", msg)
      //   return 0;
      //end else begin
         clk_list_i[clk_cfg_temp_i.clk_id] = ccu_crg_clk_cfg::type_id::create();
         clk_list_i[clk_cfg_temp_i.clk_id] = clk_cfg_temp_i;
      //end

   if (clk_cfg_temp_i.clk_domain == "")begin
        `ovm_error(get_type_name(), $psprintf("No Clock Domain Name specified for clk %s ", clk_cfg_temp_i.clk_name))
   end
	
      // check to make sure the clk period is a multiple of min clk period in the same domain 

      check_domain_period_valid(period, domain_name);
  
   end
   // Return success
   return 1;

endfunction :add_clock


/////////////////////////////////////////////////////////////////////////////
//This task adds a reset to the configuration descriptor
/////////////////////////////////////////////////////////////////////////////
function bit ccu_crg_cfg::add_reset(int reset_number, string reset_name, bit polarity, int num_cycle=0, int resp_clock=0, ccu_crg::ccu_crg_assert_e assertion=ccu_crg::ASYNC, ccu_crg::ccu_crg_assert_e deassertion=ccu_crg::ASYNC, bit auto=1, int initial_delay=0, ccu_crg::rst_initialize_polarity_e ini_polarity=ccu_crg::DEASSERTED);
   // locals
   string msg;
   ccu_crg_rst_cfg rst_cfg_temp_i;

   // Check reset number is already defined
   if (check_rst_exists(reset_number)) begin
      $sformat(msg, "%d is already defined as reset", reset_number);
      `ovm_error("ccu_crg_CFG", msg)
      return 0;
   end else begin
      // Echo added reset
      $sformat(msg, "Adding Reset: Number = %d, name = %0s", reset_number, reset_name);
      `ovm_info("ccu_crg_CFG", msg, OVM_MEDIUM)
      rst_cfg_temp_i = new(reset_name);

      // Start adding reset
      rst_cfg_temp_i.rst_id            = reset_number;
      rst_cfg_temp_i.rst_name          = reset_name;
      rst_cfg_temp_i.rst_polarity      = polarity;
      rst_cfg_temp_i.rst_length        = num_cycle;
      rst_cfg_temp_i.rst_resp_clk      = resp_clock;
      rst_cfg_temp_i.rst_assert        = assertion;
      rst_cfg_temp_i.rst_deassert      = deassertion;
      rst_cfg_temp_i.rst_auto          = auto;
      rst_cfg_temp_i.rst_ini_delay     = initial_delay;
      rst_cfg_temp_i.rst_ini_polarity  = ini_polarity;

      //if (rst_cfg_temp_i.rst_id >= num_rsts) begin
      //   $sformat(msg, "Clock number specified is greater than maximum number of defined clocks, please increase NUM_RSTS");
      //   `ovm_error("ccu_crg_CFG", msg)
      //   return 0;
      //end else
         rst_list_i[rst_cfg_temp_i.rst_id] = rst_cfg_temp_i;
   end
   // Return success
   return 1;
endfunction :add_reset

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//This functions does checks to make sure the clock periods in same domain are multiple of min period in that domain 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


function bit ccu_crg_cfg::check_domain_period_valid (time period, string domain_name);	  
  int x;
  foreach (domain_list_i[i]) begin
       if (domain_list_i[i].domain_name == domain_name) begin 
          domain_list_i[i].domain_period_queue.push_back(period);
          foreach(domain_list_i[i].domain_period_queue[k]) begin
            domain_list_i[i].domain_period_queue.sort;
            x = int'(domain_list_i[i].domain_period_queue[k] / domain_list_i[i].domain_period_queue[0]);
            if ((x * domain_list_i[i].domain_period_queue[0]) != domain_list_i[i].domain_period_queue[k]) begin
	    `ovm_error(get_type_name(), $psprintf("Clock Period specified: %0d is not a multiple of min clock period: %0d in the same Domain: %0s ", period, domain_list_i[i].domain_period_queue[0], domain_name))
            end
          end
        end
   end
  return 1;
endfunction :check_domain_period_valid 

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//This functions does checks to make sure the updated clock periods in same domain is multiple of min period in that domain and update domain period list 
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


function bit ccu_crg_cfg::update_domain_period(int clk_id, time old_period, time new_period);	  
  int x, index[$];
  time element;
  // update the domian_period_queue with new period and delete the old one 
  domain_list_i[clk_list_i[clk_id].clk_domain].domain_period_queue.push_back(new_period);
  index = domain_list_i[clk_list_i[clk_id].clk_domain].domain_period_queue.find_last_index(element) with (element == old_period);
  domain_list_i[clk_list_i[clk_id].clk_domain].domain_period_queue.delete(index[0]);
  // check to make sure the updated clk period is a multiple of min clk period in the same domain 
  domain_list_i[clk_list_i[clk_id].clk_domain].domain_period_queue.sort;
  x = int'(new_period / domain_list_i[clk_list_i[clk_id].clk_domain].domain_period_queue[0]);
  if ((x * domain_list_i[clk_list_i[clk_id].clk_domain].domain_period_queue[0]) != new_period)  begin 
  `ovm_warning( get_type_name(), $psprintf("Clock Period updated from: %0d to: %0d is not a multiple of min clock period: %0d in the same Domain: %0s ",old_period, new_period, domain_list_i[clk_list_i[clk_id].clk_domain].domain_period_queue[0], clk_list_i[clk_id].clk_domain))
  end
  return 1;
endfunction :update_domain_period

/**
 * Pass TI name to Cfg
 * @param ti_name name to set
 */
function void   ccu_crg_cfg::set_ti_name(string ti_name);
   this.ti_name = ti_name;
endfunction : set_ti_name

/**
 * Return TI name 
 * @returns TI name
 */
function string ccu_crg_cfg::get_ti_name();
   return this.ti_name;
endfunction : get_ti_name
`endif //CCU_CRG_CONFIG

