//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2010 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : njfotari
// Date Created : 28-02-2011 
//-----------------------------------------------------------------
// Description:
// Clock Reset Generator monitor class
//------------------------------------------------------------------

`ifndef CCU_CRG_MONITOR
`define CCU_CRG_MONITOR

class ccu_crg_monitor extends ovm_monitor;

   virtual ccu_crg_no_param_intf  vintf;


   ccu_crg_cfg  i_cfg;
   bit      enable_events=0;
   event    clk_rise[];
   event    clk_fall[];
   event    clk_freq_change[];
   event    clk_duty_cycle_change[];
   event    rst_assert[];
   event    rst_deassert[];

   ovm_analysis_port #(ccu_crg_xaction) analysis_port;

   // Standard OVM Methods 
   extern function       new   (string name, ovm_component parent);
   extern function void  build ();
   extern task           run   ();

   extern task           clk_rise_event(int clk_id);
   extern task           clk_fall_event(int clk_id);
   extern function void  set_intf (virtual ccu_crg_no_param_intf vintf);
   extern function void  set_cfg (ccu_crg_cfg cfg);
   extern task           monitor_clk_freq(int clk_id);
//   extern task           monitor_clk_gate(int clk_id);
   extern task           monitor_reset(int rst_id);
//   extern task           monitor_deassertion(int rst_id);

   `ovm_component_utils_begin (ccu_crg_monitor)
   `ovm_component_utils_end

endclass : ccu_crg_monitor

function ccu_crg_monitor::new (string name, ovm_component parent);
   super.new (name, parent);
endfunction :new

function void ccu_crg_monitor::build ();
   string msg;

   super.build ();

   analysis_port = new("analysis_port", this); 

   clk_rise = new[i_cfg.num_clks];        
   clk_fall = new[i_cfg.num_clks];        
   clk_freq_change = new[i_cfg.num_clks]; 
   rst_assert = new[i_cfg.num_rsts];      
   rst_deassert = new[i_cfg.num_rsts];    

endfunction :build

function void ccu_crg_monitor::set_intf (virtual ccu_crg_no_param_intf vintf);
   this.vintf = vintf;
endfunction : set_intf

function void ccu_crg_monitor::set_cfg (ccu_crg_cfg cfg);
   this.i_cfg = cfg;
endfunction : set_cfg

task ccu_crg_monitor::run();
   string msg;
   ccu_crg_xaction xaction;
   int clk_counter = 0;
   int rst_counter = 0;

   if (enable_events) begin

      `ovm_info(get_type_name(), "Events generation is enabled, clock rise & fall events will be generated on each edge", OVM_MEDIUM)

      //foreach (vintf.clocks[i]) begin
      while (clk_counter != i_cfg.num_clks-1) begin
         fork
            clk_rise_event(clk_counter);
            clk_fall_event(clk_counter);
         join_none
         #0;
         clk_counter ++;
      end
   end //enable_events

   clk_counter = 0;
   //monitor each clock
   //foreach (vintf.clocks[i]) begin
   while (clk_counter != i_cfg.num_clks) begin
      fork
         begin
         monitor_clk_freq(clk_counter);
         //monitor_clk_gate(i);
         end
      join_none
      #0;
      clk_counter++;
   end //foreach monitor clocks

   //monitor each reset
   //foreach (vintf.resets[i]) begin
   while (rst_counter != i_cfg.num_rsts) begin
      fork
         monitor_reset(rst_counter);
         //monitor_deassertion(i);
      join_none
      #0;
      rst_counter ++;
   end //foreach monitor clocks
endtask : run

task ccu_crg_monitor::clk_rise_event(int clk_id);
   string msg;
   forever begin
      @ (posedge vintf.clocks[clk_id]);
      ->clk_rise[clk_id];
   end

endtask : clk_rise_event

task ccu_crg_monitor::clk_fall_event(int clk_id);
   string msg;
   forever begin
      @ (negedge vintf.clocks[clk_id]);
      ->clk_fall[clk_id];
   end

endtask : clk_fall_event

task ccu_crg_monitor::monitor_clk_freq (int clk_id);
   time time_1, time_2, time_3, rise_time, current_period;
   int duty_cycle, last_known_duty_cycle;
   time last_known_period = 0;
   ccu_crg_xaction xaction_freq;

   //if clock exists monitor frequency, else check that signal is 0
   if (i_cfg.clk_list_i.exists(clk_id)) begin 
      forever begin
         @ (posedge vintf.clocks[clk_id]);
         time_1 = $time;
         @ (negedge vintf.clocks[clk_id]);
         time_3 = $time;
         @ (posedge vintf.clocks[clk_id]);
         time_2 = $time;
         current_period = time_2 - time_1;
         rise_time = time_3 - time_1;
         //duty_cycle = (rise_time / current_period) * 100 ;

         if (last_known_period == 0) begin
            //Add this as none operation in the fifo, so checker will know to compare it with configuration object
            xaction_freq = ccu_crg_xaction::type_id::create("xaction");
            xaction_freq.set_cfg(i_cfg);
            xaction_freq.randomize with {
               ccu_crg_op_i == ccu_crg::OP_NONE;
               clk_num.size() == 1;
               clk_num[0] == clk_id;
               clk_period.size() == 1;
               clk_period[0] == current_period;
               //clk_duty.size() == 1;
               //clk_duty[0] == duty_cycle;
            };
            analysis_port.write(xaction_freq);
            //Keep this event as freq change for now, make seperate later
            if (enable_events) ->clk_freq_change[clk_id]; 
         end
         //if (current_period != i_cfg.clk_list_i[clk_id].clk_period && last_known_period == 0) begin
         //   `ovm_error(get_type_name(), $psprintf("clock period For clk # %0d doesnt match with configuration. Expected clk_period %0d, actual: %0d", clk_id, i_cfg.clk_list_i[clk_id].clk_period, current_period))
         //end

         if (current_period != last_known_period && last_known_period != 0) begin
            //measure clock period one more time to be sure
            last_known_period = current_period;
            @ (posedge vintf.clocks[clk_id]);
            time_1 = $time;
            @ (posedge vintf.clocks[clk_id]);
            time_2 = $time;
            current_period = time_2 - time_1;
            //If changes frequency is monitored for 2 clock cycles, then only send the freq change event.
            //otherwise it might be that clock was gated for a while and then ungated
            if (current_period == last_known_period) begin
               `ovm_info(get_type_name(),$psprintf("Clock period changed to %0d for clk # %0d", current_period, clk_id), OVM_MEDIUM)
               xaction_freq = ccu_crg_xaction::type_id::create("xaction");
               xaction_freq.set_cfg(i_cfg);
               xaction_freq.randomize with {
                  ccu_crg_op_i == ccu_crg::OP_CLK_FREQ;
                  clk_num.size() == 1;
                  clk_num[0] == clk_id;
                  clk_period.size() == 1;
                  clk_period[0] == current_period;
               };
               analysis_port.write(xaction_freq);
               if (enable_events) ->clk_freq_change[clk_id];
            end
         end
         //if (duty_cycle != last_known_duty_cycle && last_known_duty_cycle != 0) begin
         //   //measure clock duty cycle one more time to be sure
         //   last_known_duty_cycle = duty_cycle;
         //   @ (posedge vintf.clocks[clk_id]);
         //   time_1 = $time;
         //   @ (negedge vintf.clocks[clk_id]);
         //   time_3 = $time;
         //   duty_cycle = ((time_3 - time_1) / current_period) * 100 ;
         //   //If changes cuty cycle is monitored for 2 clock cycles, then only send the duty cycle change event.
         //   //otherwise it might be that clock was gated for a while and then ungated
         //   if (duty_cycle == last_known_duty_cycle) begin
         //      `ovm_info(get_type_name(),$psprintf("Clock duty cycle change to %0d for clk # %0d", duty_cycle, clk_id), OVM_MEDIUM)
         //      xaction_freq = ccu_crg_xaction::type_id::create("xaction");
         //      xaction_freq.set_cfg(i_cfg);
         //      xaction_freq.randomize with {
         //         ccu_crg_op_i == ccu_crg::OP_DUTY_CYCLE;
         //         clk_num.size() == 1;
         //         clk_num[0] == clk_id;
         //         clk_duty.size() == 1;
         //         clk_duty[0] == duty_cycle; 
         //      };
         //      analysis_port.write(xaction_freq);
         //      if (enable_events) ->clk_duty_cycle_change[clk_id];
         //   end
         //end
         last_known_period = current_period;
         last_known_duty_cycle = duty_cycle;
      end //forever
   end else begin //check that signal has either 0 or 1 for undefined clocks
      //if ( vintf.clocks[clk_id] !== 'b0 && vintf.clocks[clk_id] !== 'b1 ) begin
      //   `ovm_error(get_type_name(), $psprintf("Clock number: %0d doesnt have a clock configuration specified and signal has undefined value", clk_id))
      //end
      forever begin
         @ (vintf.clocks[clk_id]);
         //`ovm_error(get_type_name(), $psprintf("Clock # %0d is unused and a toggle on signal was detected at %0d", clk_id, $time))
      end
   end //if clk exist
   
endtask: monitor_clk_freq

task ccu_crg_monitor::monitor_reset(int rst_id);
   int num_clk = 0;
   int resp_clk;
   ccu_crg_xaction xaction_rst;
   time last_posedge = 0;
   time assert_time;

   if (i_cfg.rst_list_i.exists(rst_id)) begin
      resp_clk = i_cfg.rst_list_i[rst_id].rst_resp_clk;

      //if auto bit is set, check is reset is asserted with default parameters.
      if (i_cfg.rst_list_i[rst_id].rst_auto) begin

         if (i_cfg.rst_list_i[rst_id].rst_ini_delay != 0) begin
            while (num_clk != i_cfg.rst_list_i[rst_id].rst_ini_delay) begin
               if (vintf.resets[rst_id] == i_cfg.rst_list_i[rst_id].rst_polarity) begin
                  //`ovm_error(get_type_name(), $psprintf("Reset # %0d asserted after %0d clock cycles while it should be asserted after %0d clock cycles", rst_id, num_clk, i_cfg.rst_list_i[rst_id].rst_ini_delay))
               end
               @ (posedge vintf.clocks[resp_clk]);
               last_posedge = $time;
               num_clk ++;
            end //while
         end //rst_ini_delay
         else begin
            @ (posedge vintf.clocks[resp_clk]);
            last_posedge = $time;
         end

         wait (vintf.resets[rst_id] == i_cfg.rst_list_i[rst_id].rst_polarity);
         assert_time = $time;

         if (i_cfg.rst_list_i[rst_id].rst_assert == ccu_crg::ASYNC && ((assert_time - last_posedge) == 0)) 
            //`ovm_error(get_type_name(), $psprintf("Reset # %0d was defined to be asserted ASYNC to clk # %0d but is asserted Synchronously", rst_id, resp_clk))

         if (i_cfg.rst_list_i[rst_id].rst_assert == ccu_crg::SYNC && ((assert_time - last_posedge) != 0)) 
            //`ovm_error(get_type_name(), $psprintf("Reset # %0d was defined to be asserted SYNC to clk # %0d but is asserted asynchronously", rst_id, resp_clk))

         num_clk = 0;
         if (i_cfg.rst_list_i[rst_id].rst_length != 0) begin
            while (num_clk != i_cfg.rst_list_i[rst_id].rst_length) begin
               if (vintf.resets[rst_id] == ~i_cfg.rst_list_i[rst_id].rst_polarity) begin
                  //`ovm_error(get_type_name(), $psprintf("Reset # %0d deasserted after %0d clock cycles while it should be deasserted after %0d clock cycles", rst_id, num_clk, i_cfg.rst_list_i[rst_id].rst_length))
               end
               @ (posedge vintf.clocks[resp_clk]);
               last_posedge = $time;
               num_clk ++;
            end //while

            wait (vintf.resets[rst_id] == ~i_cfg.rst_list_i[rst_id].rst_polarity);
            assert_time = $time;

            //if (i_cfg.rst_list_i[rst_id].rst_deassert == ccu_crg::ASYNC && ((assert_time - last_posedge) == 0)) 
               //`ovm_error(get_type_name(), $psprintf("Reset # %0d was defined to be deasserted ASYNC to clk # %0d but is deasserted Synchronously", rst_id, resp_clk))

		   //was error
            //if (i_cfg.rst_list_i[rst_id].rst_deassert == ccu_crg::SYNC && ((assert_time - last_posedge) != 0)) 
               //`ovm_error(get_type_name(), $psprintf("Reset # %0d was defined to be deasserted SYNC to clk # %0d but is deasserted asynchronously", rst_id, resp_clk))
         end //rst_length

      end // rst_auto bit set

      forever begin
         @ (vintf.resets[rst_id]);
         if (vintf.resets[rst_id] == i_cfg.rst_list_i[rst_id].rst_polarity) begin
            xaction_rst = ccu_crg_xaction::type_id::create("xaction");
            xaction_rst.set_cfg(i_cfg);
            xaction_rst.randomize with {
               ccu_crg_op_i == ccu_crg::OP_RST_ASSERT;
               rst_num.size() == 1;
               rst_num[0] == rst_id;
            };
            analysis_port.write(xaction_rst); 
            if (enable_events) ->rst_assert[rst_id];
         end
         else
         begin
            xaction_rst = ccu_crg_xaction::type_id::create("xaction");
            xaction_rst.set_cfg(i_cfg);
            xaction_rst.randomize with {
               ccu_crg_op_i == ccu_crg::OP_RST_DEASSERT;
               rst_num.size() == 1;
               rst_num[0] == rst_id;
            };
            analysis_port.write(xaction_rst); 
            if (enable_events) ->rst_deassert[rst_id];
         end

      end

   end else begin
     // if ( vintf.resets[rst_id] !== 'b0 && vintf.resets[rst_id] !== 'b1 ) begin
     //    `ovm_error(get_type_name(), $psprintf("Reset number: %0d doesnt have a reset configuration specified and signal has undefined value", rst_id))
     // end
      forever begin
         @ (vintf.resets[rst_id]);
         //`ovm_error(get_type_name(), $psprintf("Reset # %0d is unused and a toggle on signal was detected at %0d", rst_id, $time))
      end
   end //if rst exist

endtask : monitor_reset


`endif //CCU_CRG_MONITOR
