//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2010 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : njfotari
// Date Created : 20-04-2011 
//-----------------------------------------------------------------
// Description:
// Clock Reset Generator checker
//------------------------------------------------------------------

`ifndef CCU_CRG_CHECKER
`define CCU_CRG_CHECKER

class ccu_crg_checker extends ovm_component;

   ovm_analysis_export  #(ccu_crg_xaction)   rx_port;
   tlm_analysis_fifo    #(ccu_crg_xaction)   rx_fifo;

   ccu_crg_cfg     i_cfg;
   ccu_crg_xaction xaction;

   // Standard OVM Methods 
   extern function       new   (string name, ovm_component parent);
   extern function void  build ();
   extern function void  connect ();
   extern task           run   ();

   extern task           clk_rise_event(int clk_id);
   extern task           clk_fall_event(int clk_id);
   extern function void  set_intf (virtual ccu_crg_no_param_intf vintf);
   extern task           monitor_clk_freq(int clk_id);
//   extern task           monitor_clk_gate(int clk_id);
   extern task           monitor_assertion(int rst_id);
//   extern task           monitor_deassertion(int rst_id);

   `ovm_component_utils_begin (ccu_crg_checker)
   `ovm_component_utils_end

endclass : ccu_crg_checker

function ccu_crg_checker::new (string name, ovm_component parent);
   super.new (name, parent);
endfunction :new

function void ccu_crg_checker::build ();
   string msg;
   ovm_object ccu_crg_obj;

   super.build ();

   if (!get_config_object("ccu_crg_cfg", ccu_crg_obj, 0))
     `ovm_fatal("ccu_crg_checker", "Configuration object of clock reset generator not found")

   if (!($cast(i_cfg, ccu_crg_obj)))
     `ovm_fatal("ccu_crg_checker", "Type mismatch while casting ccu_crg_cfg object")

   rx_port = new("rx_port",this);
   rx_fifo = new("rx_fifo", this);

endfunction :build

function void ccu_crg_checker::connect();
      rx_port.connect(rx_fifo.analysis_export);
endfunction : connect

task ccu_crg_checker::run();
   string msg;
   int clk_id;

   forever begin
      //get xaction from the fifo
      rx_fifo.get(xaction);
      //Checking for the initial configuration settings to match with monitored behavior
      if (xaction.ccu_crg_op_i == ccu_crg::OP_NONE) begin
         foreach (xaction.clk_num[i]) begin
            clk_id = xaction.clk_num[i];
            if (xaction.clk_period[i] != i_cfg.clk_list_i[clk_id].clk_period) begin
               //`ovm_error(get_type_name(), $psprintf("clock period For clk # %0d doesnt match with configuration. Expected clk_period %0d, actual: %0d", clk_id, i_cfg.clk_list_i[clk_id].clk_period, xaction.clk_period[i]))
            end else begin
               `ovm_info(get_type_name(), $psprintf("clock period For clk # %0d matches with configuration. Expected clk_period %0d, actual: %0d", clk_id, i_cfg.clk_list_i[clk_id].clk_period, xaction.clk_period[i]), OVM_MEDIUM)
            end

            //if (xaction.clk_duty[i] != i_cfg.clk_list_i[clk_id].clk_duty_cycle) begin
            //   `ovm_error(get_type_name(), $psprintf("clock duty cycle For clk # %0d doesnt match with configuration. Expected %0d, actual: %0d", clk_id, i_cfg.clk_list_i[clk_id].clk_duty_cycle, xaction.clk_duty[i]))
            //end else begin
            //   `ovm_info(get_type_name(), $psprintf("clock duty cycle For clk # %0d matches with configuration. Expected %0d, actual: %0d", clk_id, i_cfg.clk_list_i[clk_id].clk_duty_cycle, xaction.clk_duty[i]), OVM_MEDIUM)
            //end
         end //foreach
      end //OP_NONE if
   end // forever
endtask : run

`endif //CCU_CRG_CHECKER
