//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2012 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : rravindr
// Date Created : 2012-06-03 
//-----------------------------------------------------------------
// Description:
// dcg_controller class definition as part of ccu_vc_pkg
//------------------------------------------------------------------

`ifndef INC_dcg_controller
`define INC_dcg_controller 

/**
 * TODO: Add class description
 */
class dcg_controller extends ovm_component;
   //------------------------------------------
   // Data Members 
   //------------------------------------------
   ccu_vc_cfg ccu_vc_cfg_i; 
   ccu_ob_seqr req_ack_sqr;
   ccu_crg_seqr ccu_crg_seqr_i;
   ccu_ob::data_t clk_req = '0;
   ccu_ob::data_t clk_ack = '0;
   ccu_ob::data_t prev_global_rst = '0;
   virtual ccu_np_intf ccu_clk_intf;
   int num_slices;
   bit gate_clks_imm[512];
   real div_ratio_l;
   realtime async_clkack_dly;
   ccu_vc_rand_delays random_delays;

   ovm_analysis_export #(ccu_ob_xaction) req_ack_usync_ap;
   local tlm_analysis_fifo #(ccu_ob_xaction) fifo;

   //------------------------------------------
   // Constraints 
   //------------------------------------------
   
   //------------------------------------------
   // Methods 
   //------------------------------------------
   
   // Standard OVM Methods 
   extern function       new   (string name = "", ovm_component parent = null);
   extern function void  build ();
   extern function void  connect ();
   extern task run();
   
   // APIs 
   extern task fork_drive_clkack(int k);  
   extern task drive_clkack(int k, bit clkreq, bit force_gate);
   extern task check_all_dcg_clkreqs(int current_dcg_blk_num_i, int i);
   // OVM Macros 
   `ovm_component_utils (ccu_vc_pkg::dcg_controller)
endclass :dcg_controller

/**
 * dcg_controller Class constructor
 * @param   name     OVM component hierarchal name
 * @param   parent   OVM parent component
 * @return           A new object of type dcg_controller 
 */
function dcg_controller::new (string name = "", ovm_component parent = null);
   // Super constructor
   super.new (name, parent);
endfunction :new

/******************************************************************************
 * dcg_controller class OVM build phase
 ******************************************************************************/
function void dcg_controller::build ();
   ovm_object tmp;
   string ccu_ti_name;
   sla_vif_container #(virtual ccu_np_intf) slaAgentIFContainer;
   ovm_object tmpPtrToAgentIFContainer;
   // Super builder
   // -------------
   super.build ();
   
   // Get configuration
   // -----------------
   assert (get_config_object("CCU_VC_CFG", tmp));
   assert ($cast(ccu_vc_cfg_i , tmp));
   num_slices = ccu_vc_cfg_i.get_num_slices();
   assert (get_config_object("ccu_vc_if_container", tmpPtrToAgentIFContainer));
   assert($cast(slaAgentIFContainer, tmpPtrToAgentIFContainer)) begin
	   ccu_clk_intf = slaAgentIFContainer.get_v_if();
   end
   

   // Construct children
   // ------------------
   req_ack_usync_ap = new("req_ack_usync_ap", this);
   fifo = new ("analysis_fifo", this);
   random_delays = ccu_vc_rand_delays::type_id::create ("ccu_vc_rand_delays", this);;

   // Configure children
   // ------------------
   //clk_req = new[num_slices];
endfunction :build

function void dcg_controller::connect ();
  req_ack_usync_ap.connect(fifo.analysis_export);
endfunction


task dcg_controller::fork_drive_clkack(int k);        
	fork
    	begin
			drive_clkack(k, 1'b1, 1'b0);
        end
    join_none   
endtask  

task dcg_controller::run();
  ccu_ob_xaction txn;
  assert (ccu_crg_seqr_i != null);
  assert(req_ack_sqr != null);

	if(ccu_clk_intf.clkreq !== {'0})
    begin
        for (int i=0;i<num_slices;i++) begin
            int k = i;
		 	if(ccu_clk_intf.clkreq[k] !== 0 && ccu_clk_intf.global_rst_b[k] !== 0) begin
                fork_drive_clkack(k);
				clk_req[k] = ccu_clk_intf.clkreq[k];
				prev_global_rst[k] = ccu_clk_intf.global_rst_b[k];
		 	end
        end
    end

  forever
  begin
	@(ccu_clk_intf.clkreq or ccu_clk_intf.global_rst_b);
	fork
		if((clk_req !== {'0,ccu_clk_intf.clkreq}) || (prev_global_rst !== {'0,ccu_clk_intf.global_rst_b}))
    	begin
       	for (int i=0;i<num_slices;i++)
       	fork
         	automatic int k = i;
			if(prev_global_rst[k] !== ccu_clk_intf.global_rst_b[k]) begin
				if(ccu_clk_intf.global_rst_b[k] == 1'b0) begin
					if(ccu_vc_cfg_i.slices[k].def_status == ccu_types::DEF_OFF && ccu_clk_intf.clkreq[k]) begin
						drive_clkack(k, 1'b0, 1'b1);
					end
					else if((ccu_clk_intf.clkreq[k] == 1'b0 || ccu_clk_intf.clkack[k] == 1'b0) && ccu_vc_cfg_i.slices[k].def_status == ccu_types::DEF_ON) begin
						drive_clkack(k, 1'b1, 1'b1);
					end
				end
				else if(ccu_clk_intf.global_rst_b[k] == 1'b1) begin
					if(((ccu_clk_intf.clkreq[k] == 1'b0 || ccu_clk_intf.clkack[k] == 1'b0) && ccu_vc_cfg_i.slices[k].clk_status == ccu_types::CLK_UNGATED) ||
					   (ccu_clk_intf.clkreq[k] == 1'b1 && ccu_vc_cfg_i.slices[k].clk_status == ccu_types::CLK_GATED))
						drive_clkack(k,ccu_clk_intf.clkreq[k],1'b0);
						clk_req[k] = ccu_clk_intf.clkreq[k];
				end
				prev_global_rst[k] = ccu_clk_intf.global_rst_b[k];
			end
		 	if(clk_req[k] !== ccu_clk_intf.clkreq[k] && ccu_clk_intf.global_rst_b[k] == 1'b1) begin
				drive_clkack(k, ccu_clk_intf.clkreq[k],1'b0);
				clk_req[k] = ccu_clk_intf.clkreq[k];
				prev_global_rst[k] = ccu_clk_intf.global_rst_b[k];
		 	end
       	join_none 
    	end
	join_none
  end

endtask

task dcg_controller::check_all_dcg_clkreqs(int current_dcg_blk_num_i, int i);
	automatic int current_dcg_blk_num = current_dcg_blk_num_i;
	automatic int k = i;
	this.gate_clks_imm[k] = 1'b0;
	if(current_dcg_blk_num == 1024) this.gate_clks_imm[k] = 1'b1;
	else begin
		foreach(ccu_vc_cfg_i.slices[m]) begin
			if(current_dcg_blk_num == ccu_vc_cfg_i.slices[m].dcg_blk_num)
				if(ccu_clk_intf.clkreq[m] !== 1'b0 || ccu_clk_intf.clkack[m] !== 1'b0) begin
					this.gate_clks_imm[k] = 1'b0;
					break;
				end
				else
					this.gate_clks_imm[k] = 1'b1;	
		end
	end
endtask 


task dcg_controller::drive_clkack(int k, bit clkreq, bit force_gate);
  fork
  automatic int i = k;
  automatic int m, gate_clks, current_dcg_blk_num;
  automatic ccu_ob_xaction clk_ack_txn = ccu_ob_xaction::type_id::create("clk_ack_txn");
  automatic int sync_clk = ccu_vc_cfg_i.slices[k].in_phase_with_slice_num;
  automatic ccu_ob_seq ob_seq = ccu_ob_seq::type_id::create("seq");
  automatic ccu_ob::data_t new_data;
  ccu_crg_seq clk_seq = ccu_crg_seq::type_id::create("seq");
  ccu_crg_xaction txn = ccu_crg_xaction::type_id::create("txn");
	//`ovm_info("DCG", $psprintf("CLK REQ %0b update for clk %0d and sync clk - %0d", clkreq, k, sync_clk), OVM_INFO)

	if(clkreq) begin
		if(ccu_vc_cfg_i.slices[i].randomize_req1_to_clk1) begin 
			random_delays.randomize();
			ccu_vc_cfg_i.slices[i].req1_to_clk1 = random_delays.req1_to_clk1_dly[i] * 1ns;
		end
		#ccu_vc_cfg_i.slices[i].req1_to_clk1;
		if(ccu_vc_cfg_i.slices[i].in_phase_with_slice_num !== 1024) begin
			if(ccu_vc_cfg_i.slices[sync_clk].clk_status !== ccu_types::CLK_GATED) begin
				wait(ccu_clk_intf.clk[ccu_vc_cfg_i.slices[i].in_phase_with_slice_num]);
			end else begin
			`ovm_error("CCU VC DCG",$psprintf("Clk slice num = %0d is expected to be in sync with a gated clk slice num=%0d", i,sync_clk))
			end
		end
		if(ccu_vc_cfg_i.slices[i].dcg_blk_num == 1024) begin
			assert(txn.randomize() with
			{ ccu_crg_op_i == ccu_crg::OP_CLK_UNGATE;
				clk_num.size() == 1;
				clk_num[0] == i;
			});
		end
		else begin
			assert(txn.randomize() with
			{ ccu_crg_op_i == ccu_crg::OP_CLK_UNGATE_ALL;
				clk_num.size() == 1;
				clk_num[0] == i;
			});
			current_dcg_blk_num = ccu_vc_cfg_i.slices[i].dcg_blk_num;
			foreach(ccu_vc_cfg_i.slices[m]) begin
				if(current_dcg_blk_num == ccu_vc_cfg_i.slices[m].dcg_blk_num)
					ccu_vc_cfg_i.slices[m].clk_status = ccu_types::CLK_UNGATED;
			end	
		end
		clk_seq.send_xaction(ccu_crg_seqr_i, txn);
		wait(ccu_clk_intf.clk[i]);
		@(posedge ccu_clk_intf.clk[i]);
		if(ccu_vc_cfg_i.slices[i].randomize_clk1_to_ack1) begin
			random_delays.randomize();
			ccu_vc_cfg_i.slices[i].clk1_to_ack1 = random_delays.clk1_to_ack1_dly[i];
		end
		repeat(ccu_vc_cfg_i.slices[i].clk1_to_ack1) @(posedge ccu_clk_intf.clk[i]);
		if(ccu_vc_cfg_i.slices[i].half_divide_ratio === 1) div_ratio_l = (int'(ccu_vc_cfg_i.slices[i].divide_ratio) + 0.5);
		else div_ratio_l = ccu_vc_cfg_i.slices[i].divide_ratio;
		async_clkack_dly = (ccu_vc_cfg_i.clk_sources[ccu_vc_cfg_i.slices[i].clk_src].period * (div_ratio_l)) * 0.1 * $urandom_range(8,2);
		if(!ccu_vc_cfg_i.sync_clkack)    
			#(async_clkack_dly);
		ccu_vc_cfg_i.slices[i].clk_status = ccu_types::CLK_UNGATED;
		new_data = {'0,ccu_clk_intf.clkack};
		new_data[i] = 1'b1;
		clk_ack_txn.randomize with {cmd == ccu_ob::SET; sig == ccu_ob::clkack; data == new_data; slice_num == i;};
		ob_seq.send_xaction( req_ack_sqr, clk_ack_txn);
	end
	else if(!clkreq) begin
		@(posedge ccu_clk_intf.clk[i]);
		if(ccu_vc_cfg_i.slices[i].randomize_req0_to_ack0) begin
			random_delays.randomize();
			ccu_vc_cfg_i.slices[i].req0_to_ack0 = random_delays.req0_to_ack0_dly[i];
		end
		repeat(ccu_vc_cfg_i.slices[i].req0_to_ack0) @(posedge ccu_clk_intf.clk[i]);
		if(ccu_vc_cfg_i.slices[i].half_divide_ratio === 1) div_ratio_l = (int'(ccu_vc_cfg_i.slices[i].divide_ratio) + 0.5);
		else div_ratio_l = ccu_vc_cfg_i.slices[i].divide_ratio;
		async_clkack_dly = (ccu_vc_cfg_i.clk_sources[ccu_vc_cfg_i.slices[i].clk_src].period * (div_ratio_l)) * 0.1 * $urandom_range(8,2);
		if(!ccu_vc_cfg_i.sync_clkack)    
			#(async_clkack_dly);
		new_data = {'0,ccu_clk_intf.clkack};
		new_data[i] = 1'b0;
		clk_ack_txn.randomize with {cmd == ccu_ob::SET; sig == ccu_ob::clkack; data == new_data; slice_num == i;};
		ob_seq.send_xaction( req_ack_sqr, clk_ack_txn);
		wait(!ccu_clk_intf.clkack[i]);
		current_dcg_blk_num = ccu_vc_cfg_i.slices[i].dcg_blk_num;
		check_all_dcg_clkreqs(current_dcg_blk_num, i);
		if(this.gate_clks_imm[i]) begin
			if(ccu_vc_cfg_i.slices[i].randomize_clkack_delay) begin
				random_delays.randomize();
				ccu_vc_cfg_i.slices[i].clkack_delay = random_delays.clkack_delay_dly[i];
			end
			repeat(ccu_vc_cfg_i.slices[i].clkack_delay) begin
				if((!ccu_clk_intf.clkreq[i] || (force_gate && !ccu_clk_intf.global_rst_b[i])) && this.gate_clks_imm[i]) begin
					@(posedge ccu_clk_intf.clk[i]);
					check_all_dcg_clkreqs(current_dcg_blk_num, i);
				end
				else break;
			end
			if(ccu_clk_intf.clkreq[i] === 1'b0 || (force_gate && !ccu_clk_intf.global_rst_b[i])) begin
				if(ccu_vc_cfg_i.slices[i].dcg_blk_num == 1024) begin	
					assert(txn.randomize() with
          			{ ccu_crg_op_i == ccu_crg::OP_CLK_GATE;
            		clk_num.size() == 1;
           			clk_num[0] == i;
          			});
					ccu_vc_cfg_i.slices[i].clk_status = ccu_types::CLK_GATED;
					clk_seq.send_xaction(ccu_crg_seqr_i, txn);
				end
				else begin
					current_dcg_blk_num = ccu_vc_cfg_i.slices[i].dcg_blk_num;
					gate_clks = 1'b0;
					foreach(ccu_vc_cfg_i.slices[m]) begin
						if(current_dcg_blk_num == ccu_vc_cfg_i.slices[m].dcg_blk_num)
							if(ccu_clk_intf.clkreq[m] !== 1'b0 || ccu_clk_intf.clkack[m] !== 1'b0) begin
								gate_clks = 1'b0;
								break;
							end
						else
							gate_clks = 1'b1;	
					end
					if(gate_clks || force_gate) begin
						assert(txn.randomize() with
          				{ ccu_crg_op_i == ccu_crg::OP_CLK_GATE_ALL;
            			clk_num.size() == 1;
           				clk_num[0] == i;
          				});
						foreach(ccu_vc_cfg_i.slices[m]) begin
							if(current_dcg_blk_num == ccu_vc_cfg_i.slices[m].dcg_blk_num)
								ccu_vc_cfg_i.slices[m].clk_status = ccu_types::CLK_GATED;
						end
						ccu_vc_cfg_i.slices[i].clk_status = ccu_types::CLK_GATED;
						clk_seq.send_xaction(ccu_crg_seqr_i, txn);
					end
				end

			end
		end
	end
		
  join_none
endtask

`endif //INC_dcg_controller

