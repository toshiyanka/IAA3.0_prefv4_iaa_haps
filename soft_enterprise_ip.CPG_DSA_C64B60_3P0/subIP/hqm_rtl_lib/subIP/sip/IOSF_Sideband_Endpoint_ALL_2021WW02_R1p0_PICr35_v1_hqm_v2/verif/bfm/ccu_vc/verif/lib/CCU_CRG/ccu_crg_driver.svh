//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2010 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : njfotari
// Date Created : 28-02-2011 
//-----------------------------------------------------------------
// Description:
// Clock Reset Generator Driver class
//------------------------------------------------------------------

`ifndef CCU_CRG_DRIVER
`define CCU_CRG_DRIVER

class ccu_crg_driver extends ovm_driver #(ccu_crg_xaction);

   virtual ccu_crg_no_param_intf vintf;
   bit internal_vintf[512];
   bit first_ungate[512];
   
   ovm_seq_item_pull_port #(ccu_crg_xaction, ccu_crg_xaction) seq_item_port;

   ovm_sequence_item  seq_item;

   ccu_crg_cfg i_cfg; 

   // Standard OVM Methods 
   extern function       new   (string name, ovm_component parent);
   extern function void  build ();
   extern task           run   ();

   extern function void set_intf (virtual ccu_crg_no_param_intf vintf);
   extern function void set_cfg (ccu_crg_cfg cfg);
   extern local task generate_clock(int clk_id);
   extern local task generate_reset(int rst_id);
   extern task execute_cmds(ccu_crg_xaction xaction);
   extern local function time get_phase_delay(realtime delay, realtime period);
   extern local function time get_assertion_delay(realtime period);

   extern function void update_clk_gate(int clk_num[$],ccu_crg::ccu_crg_gate_e gating);
   extern function void update_clk_period(ccu_crg_xaction xaction);
   extern function void update_clk_duty_cycle(ccu_crg_xaction xaction);
   extern function void update_all_clk_gate(int clk_num[$],ccu_crg::ccu_crg_gate_e gating);
   extern task assert_rst(int rst_num[$], int ini_delay[$]);
   extern task deassert_rst(int rst_num[$], int ini_delay[$]);
   extern task assert_rst_type(int rst_num[$], int ini_delay[$], ccu_crg::ccu_crg_assert_e assrt);
   extern task deassert_rst_type(int rst_num[$], int ini_delay[$], ccu_crg::ccu_crg_assert_e assrt);
   extern task assert_rst_all();
   extern task deassert_rst_all();
   extern task rst_assertion(int rst_id, int ini_delay, ccu_crg::ccu_crg_assert_e assrt);
   extern task rst_deassertion(int rst_id, int ini_delay, ccu_crg::ccu_crg_assert_e assrt);

   `ovm_component_utils_begin (ccu_crg_driver)
      `ovm_field_object (i_cfg,  OVM_ALL_ON)
   `ovm_component_utils_end

endclass : ccu_crg_driver

function ccu_crg_driver::new (string name, ovm_component parent);
   super.new (name, parent);
endfunction :new

function void ccu_crg_driver::build ();
   string msg;
   super.build ();

   seq_item_port = new ("seq_item_port", this);

endfunction :build

function void ccu_crg_driver::set_intf (virtual ccu_crg_no_param_intf vintf);
   this.vintf = vintf;
endfunction : set_intf

function void ccu_crg_driver::set_cfg (ccu_crg_cfg cfg);
   this.i_cfg = cfg;
endfunction : set_cfg

task ccu_crg_driver::run();
   string msg;
   ccu_crg_xaction xaction;

//   //initialize each clock and reset to 0
//   foreach (vintf.clocks[clk_id])
//      vintf.clocks[clk_id] = 'b0;
//   
//   foreach (vintf.resets[rst_id])
//      //For now drive all resets to 0, because unused resets wont have proper polarity set and should be driven to 0
//      vintf.resets[rst_id] = 'b0;
//      //vintf.resets[rst_id] = vintf.resets[rst_id].rst_polarity ? 'b0 : 'b1;
   
   // Generate clocks
   foreach(i_cfg.clk_list_i[i])
   begin
      fork
      begin
         $sformat(msg, "Generating clock %s with period %0d", 
         i_cfg.clk_list_i[i].clk_name, i_cfg.clk_list_i[i].clk_period);
         `ovm_info("ccu_crg_driver", msg, OVM_MEDIUM)
         if (i_cfg.clk_list_i[i].clk_id >= i_cfg.num_clks) begin
            $sformat(msg, "Clock number specified is greater than maximum number of defined clocks, please increase NUM_CLKS");
         `ovm_error("ccu_crg_CFG", msg)
         end else
            generate_clock(i_cfg.clk_list_i[i].clk_id);
      end
      join_none
      #0; //Allow fork before changing i
   end

   // Generate resets - for each reset defined in the xml
   foreach(i_cfg.rst_list_i[i])
   begin
      fork
      begin
         $sformat(msg, "Generating reset %s with polarity %0d",
         i_cfg.rst_list_i[i].rst_name, i_cfg.rst_list_i[i].rst_polarity);
         `ovm_info("ccu_crg_driver", msg, OVM_MEDIUM)
         if (i_cfg.rst_list_i[i].rst_id >= i_cfg.num_rsts) begin
            $sformat(msg, "Reset number specified is greater than maximum number of defined resets, please increase NUM_RSTS");
         `ovm_error("ccu_crg_CFG", msg)
         end else
            generate_reset(i_cfg.rst_list_i[i].rst_id);
      end
      join_none
      #0; //Allow fork before changing i
   end

   forever
   begin
      seq_item_port.get_next_item(seq_item);
      $cast(xaction,seq_item);
      $sformat(msg, "Command: %s", xaction.ccu_crg_op_i);
      `ovm_info("ccu_crg_driver", msg, OVM_MEDIUM)
      fork
         execute_cmds(xaction);
      join_none
      seq_item_port.item_done();
   end

endtask : run

//This task is called for each clock and stays on through out simulation, keeps running clock
task ccu_crg_driver::generate_clock(int clk_id);
   // Locals
   realtime phase_delay;
   realtime period;
   realtime rise_time, fall_time;

   ccu_crg::ccu_crg_gate_e prev_clk_gate;
   ccu_crg::ccu_crg_gate_e clk_gate;
   int duty_cycle;
       
   // This function will see if phase_delay is -1(undefined), then it will use random number
 if (i_cfg.domain_list_i.exists(i_cfg.clk_list_i[clk_id].clk_domain))begin
    if (i_cfg.domain_list_i[i_cfg.clk_list_i[clk_id].clk_domain].domain_phase_delay == -1) begin
       i_cfg.domain_list_i[i_cfg.clk_list_i[clk_id].clk_domain].domain_phase_delay = get_phase_delay(-1, i_cfg.domain_list_i[i_cfg.clk_list_i[clk_id].clk_domain].domain_period_queue[0]); 
      `ovm_info("ccu_crg_driver", $psprintf("Applying Random Phase Delay: %0d to Clk Domain: %0s ", i_cfg.domain_list_i[i_cfg.clk_list_i[clk_id].clk_domain].domain_phase_delay, i_cfg.clk_list_i[clk_id].clk_domain), OVM_MEDIUM) 
    end
    phase_delay = i_cfg.domain_list_i[i_cfg.clk_list_i[clk_id].clk_domain].domain_phase_delay;
 end else begin
 	`ovm_error(get_type_name(), $psprintf("Domain %0s not found", i_cfg.clk_list_i[clk_id].clk_domain))
 end
   vintf.clocks[clk_id] = 1'b0;

   // initialize/randomize jitter related values
   i_cfg.clk_list_i[clk_id].jitter_start = $urandom_range(0,10000);
   i_cfg.clk_list_i[clk_id].jitter_length = $urandom_range(0,20);
   i_cfg.clk_list_i[clk_id].clk_counter = 0;
   clk_gate = i_cfg.clk_list_i[clk_id].clk_gating;
   
   internal_vintf[clk_id] = ~internal_vintf[clk_id];
   
   // Generate the clock
   forever
   begin

      period = i_cfg.clk_list_i[clk_id].clk_period;
	  prev_clk_gate = clk_gate;
      clk_gate = i_cfg.clk_list_i[clk_id].clk_gating;
      duty_cycle = i_cfg.clk_list_i[clk_id].clk_duty_cycle;
	  phase_delay = i_cfg.domain_list_i[i_cfg.clk_list_i[clk_id].clk_domain].domain_phase_delay;
	  
	  if(prev_clk_gate == ccu_crg::GATE && clk_gate == ccu_crg::UNGATE && !first_ungate[clk_id]) begin
		// Insert phase delay
		#phase_delay;
		first_ungate[clk_id] = 1'b1;
	  end

      if (duty_cycle >= 100) begin
         `ovm_error(get_type_name(), $psprintf("Clock duty cycle %0d is more than 100, clock wont be generated", duty_cycle))
         return;
      end

      rise_time = (period * duty_cycle) / 100;
      fall_time = (period - rise_time);

	  if(internal_vintf[clk_id] == 'b1) begin
         #(rise_time);
         i_cfg.clk_list_i[clk_id].clk_counter++;
         //# (period / 2.0);
      end 
	  if(internal_vintf[clk_id] == 'b0)
         #(fall_time);

	  internal_vintf[clk_id] = ~internal_vintf[clk_id];
	  vintf.ungated_clocks[clk_id] = internal_vintf[clk_id];
	  
      if (clk_gate == ccu_crg::UNGATE) begin
		 vintf.clocks[clk_id] = internal_vintf[clk_id];		  
      end else 
         vintf.clocks[clk_id] = 1'b0;

      if (i_cfg.clk_list_i[clk_id].jitter == ccu_crg::ON && vintf.clocks[clk_id] == 'b0) begin
         //if jitter start time has reached, change clock period
         if (i_cfg.clk_list_i[clk_id].clk_counter == i_cfg.clk_list_i[clk_id].jitter_start) begin
            i_cfg.clk_list_i[clk_id].positive_jitter = $random();
            //random 2 - 10% jitter
            i_cfg.clk_list_i[clk_id].jitter_amount =  i_cfg.clk_list_i[clk_id].clk_period *  0.01 * $urandom_range(10,2); 
            if (i_cfg.clk_list_i[clk_id].positive_jitter) 
               i_cfg.clk_list_i[clk_id].clk_period = i_cfg.clk_list_i[clk_id].clk_period + i_cfg.clk_list_i[clk_id].jitter_amount;
            else
               i_cfg.clk_list_i[clk_id].clk_period = i_cfg.clk_list_i[clk_id].clk_period - i_cfg.clk_list_i[clk_id].jitter_amount;
         end //jitter_start
         //When jitter stop time is reached revert back to original frequency
         if (i_cfg.clk_list_i[clk_id].clk_counter == (i_cfg.clk_list_i[clk_id].jitter_start + i_cfg.clk_list_i[clk_id].jitter_length)) begin
            if (i_cfg.clk_list_i[clk_id].positive_jitter)
               i_cfg.clk_list_i[clk_id].clk_period = i_cfg.clk_list_i[clk_id].clk_period - i_cfg.clk_list_i[clk_id].jitter_amount;
            else
               i_cfg.clk_list_i[clk_id].clk_period = i_cfg.clk_list_i[clk_id].clk_period + i_cfg.clk_list_i[clk_id].jitter_amount;
            i_cfg.clk_list_i[clk_id].clk_counter = 0;
         end // jitter end
      end // jitter ON
   end //forever
      
endtask :generate_clock


task ccu_crg_driver::generate_reset(int rst_id);
   int resp_clk;
   realtime assertion_delay;

   if (! i_cfg.clk_list_i.exists(i_cfg.rst_list_i[rst_id].rst_resp_clk)) begin
      `ovm_fatal("ccu_crg_driver", $psprintf("RESET ID: %0d has respective clock number set to: %0d there is no clock with that ID", rst_id, i_cfg.rst_list_i[rst_id].rst_resp_clk))
   end

   resp_clk = i_cfg.rst_list_i[rst_id].rst_resp_clk;

   //If active high, initialize to 0, else to 1
   if (i_cfg.rst_list_i[rst_id].rst_ini_polarity == ccu_crg::DEASSERTED)
      vintf.resets[rst_id] = i_cfg.rst_list_i[rst_id].rst_polarity ? 1'b0 : 1'b1;
   else
      vintf.resets[rst_id] = i_cfg.rst_list_i[rst_id].rst_polarity ? 1'b1 : 1'b0;

   //Generate reset only if Auto bit is set
   if(i_cfg.rst_list_i[rst_id].rst_auto) begin
      if (i_cfg.rst_list_i[rst_id].rst_ini_delay != 0)
         repeat(i_cfg.rst_list_i[rst_id].rst_ini_delay) @(posedge vintf.clocks[resp_clk]);
      else 
         @(posedge vintf.clocks[resp_clk]);
      //if reset is to be asserted asynchronously, then generate a random delay after posedge before asserting
      if (i_cfg.rst_list_i[rst_id].rst_assert == ccu_crg::ASYNC) begin
         assertion_delay = get_assertion_delay(i_cfg.clk_list_i[resp_clk].clk_period);
         #(assertion_delay);
      end 
      //else begin
      //   @(posedge vintf.clocks[resp_clk]);
      //end
      //Assert reset based on reset polarity
      vintf.resets[rst_id] = i_cfg.rst_list_i[rst_id].rst_polarity ? 1'b1 : 1'b0;
      //de assert reset if reset length is specified a number other than 0
      if (i_cfg.rst_list_i[rst_id].rst_length != 0) begin
         repeat(i_cfg.rst_list_i[rst_id].rst_length) @(posedge vintf.clocks[resp_clk]);
         if (i_cfg.rst_list_i[rst_id].rst_deassert == ccu_crg::ASYNC)
            #(assertion_delay);
         //else
         //   @(posedge vintf.clocks[resp_clk]);
         vintf.resets[rst_id] = i_cfg.rst_list_i[rst_id].rst_polarity ? 1'b0 : 1'b1;
      end //rst_length
   end //rst_auto
   else begin
      `ovm_info("ccu_crg_driver", $psprintf("RESET ID: %0d doesn't have auto bit set, reset wont be asserted", rst_id), OVM_MEDIUM)
   end //if auto

endtask :generate_reset


function time ccu_crg_driver::get_phase_delay(realtime delay, realtime period);
  // Locals
  real multiplier;

  // If Phase delay is not defined, get random number
  if ( delay == -1)
  begin
     multiplier = 0.1 * $urandom_range(8,2);
     return (multiplier * period);
  end else
     return delay;

endfunction :get_phase_delay

function time ccu_crg_driver::get_assertion_delay(realtime period);
  // Locals
  real multiplier;

  multiplier = 0.1 * $urandom_range(4,2);
  return (multiplier * period);

endfunction :get_assertion_delay

/*////////////////////////////////////////////
This task fetches command from the command fifo
and calls tasks associated with each command
*/////////////////////////////////////////////
task ccu_crg_driver::execute_cmds(ccu_crg_xaction xaction);
   string msg, msg1;      

   case(xaction.ccu_crg_op_i)
      ccu_crg::OP_CLK_GATE          :
         update_clk_gate(xaction.clk_num,ccu_crg::GATE);
      ccu_crg::OP_CLK_UNGATE        :
         update_clk_gate(xaction.clk_num,ccu_crg::UNGATE);
      ccu_crg::OP_CLK_FREQ          :
         update_clk_period(xaction);
      ccu_crg::OP_DUTY_CYCLE        :
         update_clk_duty_cycle(xaction);
      ccu_crg::OP_CLK_GATE_ALL      :
         update_all_clk_gate(xaction.clk_num,ccu_crg::GATE);
      ccu_crg::OP_CLK_UNGATE_ALL    :
         update_all_clk_gate(xaction.clk_num,ccu_crg::UNGATE);
      ccu_crg::OP_RST_ASSERT        :
         assert_rst(xaction.rst_num, xaction.rst_delay);
      ccu_crg::OP_RST_DEASSERT      :
         deassert_rst(xaction.rst_num, xaction.rst_delay);
      ccu_crg::OP_RST_ASSERT_SYNC   :
         assert_rst_type(xaction.rst_num, xaction.rst_delay, ccu_crg::SYNC);
      ccu_crg::OP_RST_DEASSERT_SYNC :
         deassert_rst_type(xaction.rst_num, xaction.rst_delay, ccu_crg::SYNC);
      ccu_crg::OP_RST_ASSERT_ASYNC  :
         assert_rst_type(xaction.rst_num, xaction.rst_delay, ccu_crg::ASYNC);
      ccu_crg::OP_RST_DEASSERT_ASYNC:
         deassert_rst_type(xaction.rst_num, xaction.rst_delay, ccu_crg::ASYNC);
      ccu_crg::OP_RST_ASSERT_ALL    :
         assert_rst_all();
      ccu_crg::OP_RST_DEASSERT_ALL  :
         deassert_rst_all();
      default:
         `ovm_error("ccu_crg_driver", $psprintf("Unknown ccu_crg opcode: %s",xaction.ccu_crg_op_i.name()))
   endcase

endtask : execute_cmds

/*////////////////////////////////////////////
Function to update clock gating bit for 
specified clock numbers
*/////////////////////////////////////////////
function void ccu_crg_driver::update_clk_gate(int clk_num[$], ccu_crg::ccu_crg_gate_e gating);
   int clk_id;

   foreach(clk_num[i])
   begin
      clk_id = clk_num[i];
      if (!i_cfg.clk_list_i.exists(clk_id)) begin
         `ovm_error("ccu_crg_driver", $psprintf("Command to change clock gating is received for non-existing clock # %0d at index %0d", clk_id, i))
         return;
      end 
      i_cfg.clk_list_i[clk_id].clk_gating = gating;
   end //foreach

endfunction : update_clk_gate

/*////////////////////////////////////////////
Function to update clock period for specified 
clock numbers
*/////////////////////////////////////////////
function void ccu_crg_driver::update_clk_period(ccu_crg_xaction xaction);
   int clk_id;
   int curr_dcg_blk_num;
   int curr_in_phase_with;
   time old_period;
   foreach(xaction.clk_num[i])
   begin
      clk_id = xaction.clk_num[i];
      if (!i_cfg.clk_list_i.exists(clk_id)) begin
         `ovm_error("ccu_crg_driver", $psprintf("Command to change clock gating is received for non-existing clock # %0d", clk_id))
         return;
      end 
      old_period = i_cfg.clk_list_i[clk_id].clk_period;
      i_cfg.clk_list_i[clk_id].clk_period = xaction.clk_period[i];
      //calling function to checck and update clk period in the domain period list       
      i_cfg.update_domain_period(clk_id, old_period, i_cfg.clk_list_i[clk_id].clk_period);
	  curr_dcg_blk_num = i_cfg.clk_list_i[clk_id].dcg_blk_num;
	  
	  foreach(i_cfg.clk_list_i[m]) begin
		  if(m !== clk_id && i_cfg.clk_list_i[m].dcg_blk_num == curr_dcg_blk_num && i_cfg.clk_list_i[m].dcg_blk_num !== 1024) begin
			  old_period = i_cfg.clk_list_i[m].clk_period;
			  i_cfg.clk_list_i[m].clk_period = xaction.clk_period[i];
			  i_cfg.update_domain_period(m, old_period, i_cfg.clk_list_i[m].clk_period);
			  `ovm_info("ccu_crg_driver",$psprintf("new clk period = %0d, for clk num = %0d", i_cfg.clk_list_i[m].clk_period,m),OVM_INFO)
		  end
		  if(m!== clk_id && i_cfg.clk_list_i[m].in_phase_with == clk_id && i_cfg.clk_list_i[m].in_phase_with !== 1024) begin
			  old_period = i_cfg.clk_list_i[m].clk_period;
			  i_cfg.clk_list_i[m].clk_period = xaction.clk_period[i];
			  i_cfg.update_domain_period(m, old_period, i_cfg.clk_list_i[m].clk_period);
			  `ovm_info("ccu_crg_driver",$psprintf("new clk period = %0d, for clk num = %0d", i_cfg.clk_list_i[m].clk_period,m),OVM_INFO)
		  end
	  end
   end //foreach
endfunction : update_clk_period


/*////////////////////////////////////////////
Function to update clock duty cycle for 
specified clock numbers
*/////////////////////////////////////////////
function void ccu_crg_driver::update_clk_duty_cycle(ccu_crg_xaction xaction);
   int clk_id;

   foreach(xaction.clk_num[i])
   begin
      clk_id = xaction.clk_num[i];
      if (!i_cfg.clk_list_i.exists(clk_id)) begin
         `ovm_error("ccu_crg_driver", $psprintf("Command to change clock duty cycle is received for non-existing clock # %0d", clk_id)) 
         return;
      end 
      i_cfg.clk_list_i[clk_id].clk_duty_cycle = xaction.clk_duty[i];
   end //foreach
endfunction : update_clk_duty_cycle

/*////////////////////////////////////////////
Change Clock gating bit  for all the clocks
gating = 1: will gate the clock
gating = 0: will ungate the clock
*/////////////////////////////////////////////
function void ccu_crg_driver::update_all_clk_gate(int clk_num[$], ccu_crg::ccu_crg_gate_e gating);

	int slice_num = clk_num[0];
	int dcg_blk_num = i_cfg.clk_list_i[slice_num].dcg_blk_num;
   foreach(i_cfg.clk_list_i[i]) begin
	   if( (i_cfg.clk_list_i[i].dcg_blk_num == dcg_blk_num && i_cfg.clk_list_i[i].dcg_blk_num !== 1024)|| 
		   (i_cfg.clk_list_i[i].in_phase_with == slice_num && i_cfg.clk_list_i[i].in_phase_with !== 1024)) begin
      		i_cfg.clk_list_i[i].clk_gating = gating;
			//`ovm_info("ccu_crg_driver", $psprintf("dcg_blk_num = %0d and clk num %0d, dcg num is %0d",dcg_blk_num,i,i_cfg.clk_list_i[i].dcg_blk_num),OVM_INFO)
	   end
   end

endfunction : update_all_clk_gate

/*////////////////////////////////////////////
Asserts specified resets after waiting on 
respective clock for specified ini_delay
*/////////////////////////////////////////////
task ccu_crg_driver::assert_rst(int rst_num[$], int ini_delay[$]);
   // Locals
   string msg;
   int rst_id;
   int delay;
   ccu_crg::ccu_crg_assert_e assrt;

   if (rst_num.size() != ini_delay.size()) begin
      //`ovm_error("ccu_crg_driver", $psprintf("RESET_ASSERT COMMAND: Size of rst_num and ini_delay array is not same, each reset number needs assiciated initial delay"))
      return;
   end

   // Assert resets
   foreach(rst_num[i]) begin
      rst_id = rst_num[i];
      delay = ini_delay[i];
      assrt = i_cfg.rst_list_i[rst_id].rst_assert;
      if (!i_cfg.rst_list_i.exists(rst_id)) begin
         //`ovm_error("ccu_crg_driver", $psprintf("Command to assert reset is received for non-existing reset # %0d", rst_id)) 
         return;
      end
      if (vintf.resets[rst_id] == i_cfg.rst_list_i[rst_id].rst_polarity) begin
         `ovm_info("ccu_crg_driver", $psprintf("Command to assert reset#%0d is received but reset is already in assert state, aborting command", rst_id), OVM_MEDIUM) 
         return;
      end

      vintf.resets[rst_id] = i_cfg.rst_list_i[rst_id].rst_polarity ? 1'b0 : 1'b1;

      fork
      begin
         rst_assertion(rst_id, delay, assrt);
      end
      join_none
      #0; //Allow fork before changing i
   end //foreach 

endtask :assert_rst

/*////////////////////////////////////////////
De-asserts specified resets after waiting on 
respective clock for specified ini_delay
*/////////////////////////////////////////////
task ccu_crg_driver::deassert_rst(int rst_num[$], int ini_delay[$]);
   // Locals
   string msg;
   int rst_id;
   int delay;
   ccu_crg::ccu_crg_assert_e assrt; 

   if (rst_num.size() != ini_delay.size()) begin
      //`ovm_error("ccu_crg_driver", $psprintf("RESET_ASSERT COMMAND: Size of rst_num and ini_delay array is not same, each reset number needs assiciated initial delay")) 
      return;
   end

   // Assert resets
   foreach(rst_num[i]) begin
      rst_id = rst_num[i];
      delay = ini_delay[i];
      assrt = i_cfg.rst_list_i[rst_id].rst_deassert;
      if (!i_cfg.rst_list_i.exists(rst_id)) begin
         `ovm_error("ccu_crg_driver", $psprintf("Command to assert reset is received for non-existing reset # %0d", rst_id)) 
         return;
      end

      fork
      begin
         rst_deassertion(rst_id,delay, assrt);
      end
      join_none
      #0; //Allow fork before changing i
   end //foreach 
endtask :deassert_rst

/*////////////////////////////////////////////
Asserts specified resets using specified 
assertion type 
*/////////////////////////////////////////////
task ccu_crg_driver::assert_rst_type(int rst_num[$], int ini_delay[$], ccu_crg::ccu_crg_assert_e assrt);
   // Locals
   string msg;
   int rst_id;
   int delay;

   if (rst_num.size() != ini_delay.size()) begin
      //`ovm_error("ccu_crg_driver", $psprintf("RESET_ASSERT_%0s COMMAND: Size of rst_num and ini_delay array is not same, each reset number needs assiciated initial delay", assrt.name())) 
      return;
   end

   // Assert resets
   foreach(rst_num[i]) begin
      rst_id = rst_num[i];
      delay = ini_delay[i];
      //Check if specified reset ID exists in list of resets
      if (!i_cfg.rst_list_i.exists(rst_id)) begin
         //`ovm_error("ccu_crg_driver", $psprintf("Command to assert reset is received for non-existing reset # %0d", rst_id)) 
         return;
      end

      fork
      begin
         rst_assertion(rst_id, delay, assrt);
      end
      join_none
      #0; //Allow fork before changing i
   end //foreach 

endtask :assert_rst_type

/*////////////////////////////////////////////
De-asserts specified resets using specified 
assertion type 
*/////////////////////////////////////////////
task ccu_crg_driver::deassert_rst_type(int rst_num[$], int ini_delay[$], ccu_crg::ccu_crg_assert_e assrt);
   // Locals
   string msg;
   int rst_id;
   int delay;

   if (rst_num.size() != ini_delay.size()) begin
      //`ovm_error("ccu_crg_driver", $psprintf("RESET_ASSERT_%0s COMMAND: Size of rst_num and ini_delay array is not same, each reset number needs assiciated initial delay", assrt.name())) 
      return;
   end

   // Assert resets
   foreach(rst_num[i]) begin
      rst_id = rst_num[i];
      delay = ini_delay[i];
      //Check if specified reset ID exists in list of resets
      if (!i_cfg.rst_list_i.exists(rst_id)) begin
         //`ovm_error("ccu_crg_driver", $psprintf("Command to assert reset is received for non-existing reset # %0d", rst_id)) 
         return;
      end

      fork
      begin
         rst_deassertion(rst_id,delay, assrt);
      end
      join_none
      #0; //Allow fork before changing i
   end //foreach 
endtask :deassert_rst_type

/*////////////////////////////////////////////
Assets all reeeesets with default behavior 
*/////////////////////////////////////////////
task ccu_crg_driver::assert_rst_all();
   // Locals
   string msg;
   int delay = 0;
   ccu_crg::ccu_crg_assert_e assrt;

   // Assert resets
   foreach(i_cfg.rst_list_i[rst_id]) begin
      //delay = i_cfg.rst_list_i[rst_id].rst_ini_delay;
      assrt = i_cfg.rst_list_i[rst_id].rst_assert;

      fork
      begin
         rst_assertion(rst_id, delay, assrt);
      end
      join_none
      #0; //Allow fork before changing i
   end //foreach 

endtask :assert_rst_all

/*////////////////////////////////////////////
De-assets all reeeesets with default behavior 
*/////////////////////////////////////////////
task ccu_crg_driver::deassert_rst_all();
   // Locals
   string msg;
   int delay = 0;
   ccu_crg::ccu_crg_assert_e assrt; 

   // Assert resets
   foreach(i_cfg.rst_list_i[rst_id]) begin
      //delay = i_cfg.rst_list_i[rst_id].rst_length;
      assrt = i_cfg.rst_list_i[rst_id].rst_deassert;

      fork
      begin
         rst_deassertion(rst_id, delay, assrt);
      end
      join_none
      #0; //Allow fork before changing i
   end //foreach 
endtask :deassert_rst_all

/*////////////////////////////////////////////
This task drives interface signals for reset 
assertion
*/////////////////////////////////////////////
task ccu_crg_driver::rst_assertion(int rst_id, int ini_delay, ccu_crg::ccu_crg_assert_e assrt);
   // Locals
   string msg;
   int resp_clk;
   realtime assertion_delay;

   resp_clk = i_cfg.rst_list_i[rst_id].rst_resp_clk;

   //Check if respective clock of this reset exists in clock list
   if (! i_cfg.clk_list_i.exists(resp_clk)) begin
      //`ovm_error("ccu_crg_driver", $psprintf("RESET_ASSERT COMMAND: Reset ID %0d has respective clock number set to: %0d there is no clock with that ID", rst_id, resp_clk)) 
      return;
   end

   //If active high, initialize to 0, else to 1
   vintf.resets[rst_id] = i_cfg.rst_list_i[rst_id].rst_polarity ? 1'b0 : 1'b1;

   if (ini_delay != 0)
      repeat(ini_delay) @(posedge vintf.clocks[resp_clk]);

   //if reset is to be asserted asynchronously, then generate a random delay after posedge before asserting
   if (assrt == ccu_crg::ASYNC) begin
      assertion_delay = get_assertion_delay(i_cfg.clk_list_i[resp_clk].clk_period);
      #(assertion_delay);
   end 
   else begin
      @(posedge vintf.clocks[resp_clk]);
   end

   //Assert reset based on reset polarity
   vintf.resets[rst_id] = i_cfg.rst_list_i[rst_id].rst_polarity ? 1'b1 : 1'b0;

endtask : rst_assertion

/*////////////////////////////////////////////
This task drives interface signals for reset 
de-assertion
*/////////////////////////////////////////////
task ccu_crg_driver::rst_deassertion(int rst_id, int ini_delay, ccu_crg::ccu_crg_assert_e assrt);
   string msg;
   int resp_clk;
   realtime assertion_delay;

   resp_clk = i_cfg.rst_list_i[rst_id].rst_resp_clk;

   //Check if respective clock of this reset exists in clock list
   if (! i_cfg.clk_list_i.exists(resp_clk)) begin
      //`ovm_fatal("ccu_crg_driver", $psprintf("RESET ID: %0d has respective clock number set to: %0d there is no clock with that ID", rst_id, i_cfg.rst_list_i[rst_id].rst_resp_clk))
   end


   if (ini_delay != 0)
      repeat(ini_delay) @(posedge vintf.clocks[resp_clk]);

   //Make sure that reset is asserted
   if (vintf.resets[rst_id] !== i_cfg.rst_list_i[rst_id].rst_polarity) begin
	  //`ovm_error("ccu_crg_driver", $psprintf("RESET ID: %0d received deassertion command but reset is already in deassert state", rst_id))
      return;
   end

   //if reset is to be asserted asynchronously, then generate a random delay after posedge before asserting
   if (assrt == ccu_crg::ASYNC) begin
      assertion_delay = get_assertion_delay(i_cfg.clk_list_i[resp_clk].clk_period);
      #(assertion_delay);
   end 
   else begin
      @(posedge vintf.clocks[resp_clk]);
   end

   //deassert reset
   vintf.resets[rst_id] = i_cfg.rst_list_i[rst_id].rst_polarity ? 1'b0 : 1'b1;

endtask : rst_deassertion

`endif //CCU_CRG_DRIVER
