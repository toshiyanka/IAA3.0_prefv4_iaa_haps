//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2012 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : bosman3 
// Date Created : 2012-06-03 
//-----------------------------------------------------------------
// Description:
// ccu_driver class definition as part of ccu_vc_pkg
//------------------------------------------------------------------

`ifndef INC_ccu_driver
`define INC_ccu_driver 

/**
 * TODO: Add class description
 */
class ccu_driver extends ovm_driver #(ccu_xaction);
   //------------------------------------------
   // Data Members 
   //------------------------------------------
   ccu_vc_cfg cfg; 
   ccu_crg_seqr ccu_crg_seqr_i;
   ccu_ob_seqr usync_sqr;
   virtual ccu_crg_no_param_intf clk_vintf;
   int gusync_counter;
   int num_slices;
   int usync_assert[$];
   int usync_deassert[$];
   real new_div_ratio_l;
   real slice_div_ratio;
   ccu_crg::ccu_crg_operations_e crg_op;

   //------------------------------------------
   // Constraints 
   //------------------------------------------
   
   //------------------------------------------
   // Methods 
   //------------------------------------------
   
   // Standard OVM Methods 
   extern function       new   (string name = "", ovm_component parent = null);
   extern function void  build ();
   extern task run();

   // APIs 
   extern task drive_gusync();
   extern task drive_slice_usync(int slice_num );
   
   // OVM Macros 
   `ovm_component_utils (ccu_vc_pkg::ccu_driver)
endclass :ccu_driver

/**
 * ccu_driver Class constructor
 * @param   name     OVM component hierarchal name
 * @param   parent   OVM parent component
 * @return           A new object of type ccu_driver 
 */
function ccu_driver::new (string name = "", ovm_component parent = null);
   // Super constructor
   super.new (name, parent);
endfunction :new

/******************************************************************************
 * ccu_driver class OVM build phase
 ******************************************************************************/
function void ccu_driver::build ();
   ovm_object tmp;
   string ccu_crg_ti_name;

   // Super builder
   // -------------
   super.build ();
   
   // Get configuration
   // -----------------
   assert (get_config_object("CCU_VC_CFG", tmp));
   assert ($cast(cfg , tmp));
   assert (get_config_string("CCU_VC_ccu_crg_TI_NAME", ccu_crg_ti_name)); 
   clk_vintf = sla_resource_db #(virtual ccu_crg_no_param_intf)::get({ccu_crg_ti_name, ".ccu_crg_no_param_intf"}, `__FILE__, `__LINE__);  
   
   // Construct children
   // ------------------
   
   // Configure children
   // ------------------
   num_slices = cfg.get_num_slices();
endfunction :build

task ccu_driver::run();
  ccu_crg_seq seq = ccu_crg_seq::type_id::create("seq");
  ccu_crg_xaction txn = ccu_crg_xaction::type_id::create("txn");

  assert (ccu_crg_seqr_i != null);
  assert(usync_sqr != null);

  fork
    drive_gusync();
  join_none

  for (int i=0;i<num_slices;i++) begin
  fork
    automatic int k = i;
    drive_slice_usync(k);
  join_none
  #0; 
  end
 
  forever
  begin
    seq_item_port.get_next_item(req);
	if(req.cmd == ccu_types::DIVIDE_RATIO) begin
		if(cfg.slices[req.slice_num].half_divide_ratio === 1) new_div_ratio_l = (int'(req.div_ratio) + 0.5);
		else new_div_ratio_l = req.div_ratio;
	end else if(req.cmd == ccu_types::HALF_DIVIDE_RATIO) begin
		if(req.half_div_ratio === 1) new_div_ratio_l = (int'(cfg.slices[req.slice_num].divide_ratio) + 0.5);
		else new_div_ratio_l = cfg.slices[req.slice_num].divide_ratio;
	end
	if(cfg.slices[req.slice_num].half_divide_ratio === 1) 
		slice_div_ratio = (int'(cfg.slices[req.slice_num].divide_ratio) + 0.5);
	else 
		slice_div_ratio = cfg.slices[req.slice_num].divide_ratio;
	
	case (req.cmd)
        ccu_types::GATE:
        begin
			if(cfg.slices[req.slice_num].clk_status === ccu_types::CLK_UNGATED) begin
		  		if(cfg.slices[req.slice_num].dcg_blk_num == 1024)
					  crg_op = ccu_crg::OP_CLK_GATE;
		  		else 
					  crg_op = ccu_crg::OP_CLK_GATE_ALL;
          		assert(txn.randomize() with
            		 { ccu_crg_op_i == crg_op;
              		 clk_num.size() == 1;
              		 clk_num[0] == req.slice_num;
             		});
          		seq.send_xaction(ccu_crg_seqr_i, txn);
		  		cfg.slices[req.slice_num].clk_status = ccu_types::CLK_GATED;
		  		foreach(cfg.slices[m]) begin
					  if(cfg.slices[req.slice_num].dcg_blk_num == cfg.slices[m].dcg_blk_num &&
						  cfg.slices[m].dcg_blk_num !== 1024)
				  		cfg.slices[m].clk_status = ccu_types::CLK_GATED;
		  		end
        	end
		end
        ccu_types::UNGATE:
        begin
			if(cfg.slices[req.slice_num].clk_status === ccu_types::CLK_GATED) begin
				if(cfg.slices[req.slice_num].dcg_blk_num == 1024)
					  crg_op = ccu_crg::OP_CLK_UNGATE;
		  		else 
					  crg_op = ccu_crg::OP_CLK_UNGATE_ALL;
          		assert(txn.randomize() with
            		 { ccu_crg_op_i == crg_op;
              	 	clk_num.size() == 1;
              	 	clk_num[0] == req.slice_num;
             		});
          		seq.send_xaction(ccu_crg_seqr_i, txn);
		  		cfg.slices[req.slice_num].clk_status = ccu_types::CLK_UNGATED;
		  		foreach(cfg.slices[m]) begin
					  if(cfg.slices[req.slice_num].dcg_blk_num == cfg.slices[m].dcg_blk_num &&
			  			 cfg.slices[m].dcg_blk_num !== 1024)
				  		cfg.slices[m].clk_status = ccu_types::CLK_UNGATED;
		  		end
        	end
		end
        ccu_types::DIVIDE_RATIO:
        begin
			int clk_src = cfg.slices[req.slice_num].clk_src;
			time new_period = cfg.clk_sources[clk_src].period * (new_div_ratio_l);
			if(cfg.slices[req.slice_num].clk_status === ccu_types::CLK_GATED) begin
			  	assert(txn.randomize() with
					{ ccu_crg_op_i == ccu_crg::OP_CLK_FREQ;
					clk_num.size() == 1;
				  	clk_num[0] == req.slice_num;
				  	clk_period[0] == new_period;
					});
				seq.send_xaction(ccu_crg_seqr_i, txn);
			end
			else begin
				if(cfg.slices[req.slice_num].dcg_blk_num == 1024)
				  crg_op = ccu_crg::OP_CLK_GATE;
				else 
				  crg_op = ccu_crg::OP_CLK_GATE_ALL;
				assert(txn.randomize() with
				 { ccu_crg_op_i == crg_op;
				   clk_num.size() == 1;
				   clk_num[0] == req.slice_num;
				 });
				seq.send_xaction(ccu_crg_seqr_i, txn);
				cfg.slices[req.slice_num].divide_ratio = req.div_ratio;
				// wait for one clock period or programmed freq delay
				if(cfg.slices[req.slice_num].freq_change_delay == 0)
					#cfg.clk_sources[cfg.slices[req.slice_num].clk_src].period;
				else
			  		#cfg.slices[req.slice_num].freq_change_delay;
			  	assert(txn.randomize() with
					{ ccu_crg_op_i == ccu_crg::OP_CLK_FREQ;
					clk_num.size() == 1;
				  	clk_num[0] == req.slice_num;
				  	clk_period[0] == new_period;
					});
				seq.send_xaction(ccu_crg_seqr_i, txn);
				if(cfg.slices[req.slice_num].dcg_blk_num == 1024)
					crg_op = ccu_crg::OP_CLK_UNGATE;
			  	else 
					crg_op = ccu_crg::OP_CLK_UNGATE_ALL;
			  	// wait for one clock period 
			  	if(cfg.slices[req.slice_num].freq_change_delay == 0)
			  		#cfg.clk_sources[cfg.slices[req.slice_num].clk_src].period;
		
				assert(txn.randomize() with
				 { ccu_crg_op_i == crg_op;
				   clk_num.size() == 1;
				   clk_num[0] == req.slice_num;
				 });
			  	seq.send_xaction(ccu_crg_seqr_i, txn);
		  	end  // else
			
			foreach(cfg.slices[m]) begin
			if(cfg.slices[req.slice_num].dcg_blk_num == cfg.slices[m].dcg_blk_num &&
				cfg.slices[m].dcg_blk_num !== 1024)
				cfg.slices[m].divide_ratio = req.div_ratio;
			end
        end
        ccu_types::HALF_DIVIDE_RATIO:
        begin
			int clk_src = cfg.slices[req.slice_num].clk_src;
			time new_period = cfg.clk_sources[clk_src].period * (new_div_ratio_l);
			if(cfg.slices[req.slice_num].clk_status === ccu_types::CLK_GATED) begin
   		        assert(txn.randomize() with
        	     { ccu_crg_op_i == ccu_crg::OP_CLK_FREQ;
            	   clk_num.size() == 1;
             	  clk_num[0] == req.slice_num;
             	  clk_period[0] == new_period;
            	 });
				seq.send_xaction(ccu_crg_seqr_i, txn);
			end
			else begin
				if(cfg.slices[req.slice_num].dcg_blk_num == 1024)
					crg_op = ccu_crg::OP_CLK_GATE;
				else 
					crg_op = ccu_crg::OP_CLK_GATE_ALL;
				assert(txn.randomize() with
					{ ccu_crg_op_i == crg_op;
					clk_num.size() == 1;
					clk_num[0] == req.slice_num;
					});
				seq.send_xaction(ccu_crg_seqr_i, txn);
				cfg.slices[req.slice_num].half_divide_ratio = req.half_div_ratio;
				`ovm_info("CCU DRIVER", {"\n", cfg.sprint()}, OVM_MEDIUM)
				// wait for one clock period or programmed freq delay
				if(cfg.slices[req.slice_num].freq_change_delay == 0)
					#cfg.clk_sources[cfg.slices[req.slice_num].clk_src].period;
	  	  		else
		  			#cfg.slices[req.slice_num].freq_change_delay;
    
   		        assert(txn.randomize() with
        	     { ccu_crg_op_i == ccu_crg::OP_CLK_FREQ;
            	   clk_num.size() == 1;
             	  clk_num[0] == req.slice_num;
             	  clk_period[0] == new_period;
            	 });
				seq.send_xaction(ccu_crg_seqr_i, txn);
		  		if(cfg.slices[req.slice_num].dcg_blk_num == 1024)
			  		crg_op = ccu_crg::OP_CLK_UNGATE;
		  		else 
			  		crg_op = ccu_crg::OP_CLK_UNGATE_ALL;
          		// wait for one clock period 
		  		if(cfg.slices[req.slice_num].freq_change_delay == 0)
          			#cfg.clk_sources[cfg.slices[req.slice_num].clk_src].period;
    
				assert(txn.randomize() with
				 { ccu_crg_op_i == crg_op;
				   clk_num.size() == 1;
				   clk_num[0] == req.slice_num;
				 });
				seq.send_xaction(ccu_crg_seqr_i, txn);
			end  // else
			foreach(cfg.slices[m]) begin
				if(cfg.slices[req.slice_num].dcg_blk_num == cfg.slices[m].dcg_blk_num &&
					cfg.slices[m].dcg_blk_num !== 1024)
					cfg.slices[m].half_divide_ratio = req.half_div_ratio;
			end
        end
		ccu_types::CLK_SRC:
        begin
			int clk_src = cfg.slices[req.slice_num].clk_src;
			time new_period = cfg.clk_sources[req.clk_src].period * slice_div_ratio;
			if(req.clk_src !== clk_src) begin	
				if(cfg.slices[req.slice_num].clk_status === ccu_types::CLK_GATED) begin
					assert(txn.randomize() with
				 	{ ccu_crg_op_i == ccu_crg::OP_CLK_FREQ;
				   	clk_num.size() == 1;
				   	clk_num[0] == req.slice_num;
				   	clk_period[0] == new_period;
				 	});
					seq.send_xaction(ccu_crg_seqr_i, txn);
				end
				else begin
					if(cfg.slices[req.slice_num].dcg_blk_num == 1024)
						crg_op = ccu_crg::OP_CLK_GATE;
					else 
						crg_op = ccu_crg::OP_CLK_GATE_ALL;
					foreach(cfg.slices[m]) begin
						if(cfg.slices[m].in_phase_with_slice_num == req.slice_num &&
							cfg.slices[m].in_phase_with_slice_num !== 1024)
							crg_op = ccu_crg::OP_CLK_GATE_ALL;
					end
    
					cfg.slices[req.slice_num].clk_src = req.clk_src;
					assert(txn.randomize() with
					{ ccu_crg_op_i == crg_op;
					clk_num.size() == 1;
					clk_num[0] == req.slice_num;
					});
					seq.send_xaction(ccu_crg_seqr_i, txn);
					// wait for one clock period or programmed freq delay
					if(cfg.slices[req.slice_num].freq_change_delay == 0)
						#cfg.clk_sources[cfg.slices[req.slice_num].clk_src].period;
					else
						#cfg.slices[req.slice_num].freq_change_delay;

					assert(txn.randomize() with
				 	{ ccu_crg_op_i == ccu_crg::OP_CLK_FREQ;
				   	clk_num.size() == 1;
				   	clk_num[0] == req.slice_num;
				   	clk_period[0] == new_period;
					});
					seq.send_xaction(ccu_crg_seqr_i, txn);
					if(cfg.slices[req.slice_num].dcg_blk_num == 1024)
						crg_op = ccu_crg::OP_CLK_UNGATE;
					else 
						crg_op = ccu_crg::OP_CLK_UNGATE_ALL;

					foreach(cfg.slices[m]) begin
						if(cfg.slices[m].in_phase_with_slice_num == req.slice_num &&
							cfg.slices[m].in_phase_with_slice_num !== 1024)
							crg_op = ccu_crg::OP_CLK_UNGATE_ALL;
					end
    
					if(cfg.slices[req.slice_num].freq_change_delay == 0)
						#cfg.clk_sources[cfg.slices[req.slice_num].clk_src].period;

					assert(txn.randomize() with
				 	{ ccu_crg_op_i == crg_op;
				   	clk_num.size() == 1;
				   	clk_num[0] == req.slice_num;
				 	});
					seq.send_xaction(ccu_crg_seqr_i, txn);
				end  // else
	
				foreach(cfg.slices[m]) begin
					if(cfg.slices[req.slice_num].dcg_blk_num == cfg.slices[m].dcg_blk_num &&
						cfg.slices[m].dcg_blk_num !== 1024)
						cfg.slices[m].clk_src = req.clk_src;
					if(req.slice_num == cfg.slices[m].in_phase_with_slice_num &&
						cfg.slices[m].in_phase_with_slice_num !== 1024)
						cfg.slices[m].clk_src = req.clk_src;
				end
			end
        end
        ccu_types::REQ1_TO_CLK1:
		begin
		  cfg.slices[req.slice_num].req1_to_clk1 = req.req1_to_clk1;
		end
        ccu_types::CLK1_TO_ACK1:
		begin
		  cfg.slices[req.slice_num].clk1_to_ack1 = req.clk1_to_ack1;
		end
        ccu_types::REQ0_TO_ACK0:
		begin
		  cfg.slices[req.slice_num].req0_to_ack0 = req.req0_to_ack0;
		end
        ccu_types::CLKACK_DLY:
		begin
		  cfg.slices[req.slice_num].clkack_delay = req.clkack_delay;
		end
        ccu_types::FREQ_CHANGE_DLY:
		begin
		  cfg.slices[req.slice_num].freq_change_delay = req.freq_change_delay;
		end
		ccu_types::EN_USYNC:
        begin
          cfg.slices[req.slice_num].usync_enabled = 1'b1; 
        end
        ccu_types::DIS_USYNC:
        begin
          cfg.slices[req.slice_num].usync_enabled = 1'b0; 
        end
        ccu_types::PHASE_SHIFT:
        begin
        end
 
	endcase 

    seq_item_port.item_done();
	end
endtask

task ccu_driver::drive_gusync();
  ccu_ob_xaction gusync_txn = ccu_ob_xaction::type_id::create("gusync_txn");
  ccu_ob_seq ob_seq = ccu_ob_seq::type_id::create("seq");
  gusync_counter = cfg.gusync_counter+1;

  forever
  begin
    @(posedge clk_vintf.clocks[num_slices] iff cfg.start_gusync_cnt == 1'b1)
    begin
      if (gusync_counter == cfg.gusync_counter)
      begin
        gusync_txn.randomize with {cmd == ccu_ob::SET; sig == ccu_ob::g_usync; data == 1'b0; };
        ob_seq.send_xaction( usync_sqr, gusync_txn);

      end
      gusync_counter--;
      if (gusync_counter == 0)
      begin
        gusync_counter = cfg.gusync_counter+1;
        gusync_txn.randomize with {cmd == ccu_ob::SET; sig == ccu_ob::g_usync; data == 1'b1; };
        ob_seq.send_xaction( usync_sqr, gusync_txn);
      end
    end
  end
endtask

task ccu_driver::drive_slice_usync(int slice_num );
	forever   
    if (cfg.slices[slice_num].usync_enabled && cfg.slices[slice_num].clk_src == cfg.gusync_ref_clk)
    begin
      //int cnt = (2 ** (int'(cfg.slices[slice_num].divide_ratio))) + 1;
	  automatic int cnt = (int'(cfg.slices[slice_num].divide_ratio) * 2) + 1; 
      @(posedge clk_vintf.clocks[num_slices]);
	  fork
	   automatic int cnt_auto = cnt;
	   automatic int slice_num_auto = slice_num;
	   automatic ccu_ob::data_t usync; 
	   usync = '1;
 
	  if(gusync_counter == cnt_auto) begin
			ccu_ob_xaction usync_txn = ccu_ob_xaction::type_id::create("usync_txn");
		    ccu_ob_seq ob_seq = ccu_ob_seq::type_id::create("seq");
			
		  @(posedge clk_vintf.ungated_clocks[slice_num_auto]);
		  if(cfg.slices[slice_num_auto].clk_status == ccu_types::CLK_UNGATED) begin
		  	usync_assert.push_back(slice_num_auto);
		  	usync[slice_num_auto] = 1'b1; 
		  	usync_txn.randomize with {cmd == ccu_ob::SET; sig == ccu_ob::usync; data == usync; slice_num == slice_num_auto;};
		  	ob_seq.send_xaction( usync_sqr, usync_txn);
		  end
  	
		  @(posedge clk_vintf.ungated_clocks[slice_num_auto]);
		  if(cfg.slices[slice_num_auto].clk_status == ccu_types::CLK_UNGATED || usync[slice_num_auto]) begin
		  	usync_deassert.push_back(slice_num_auto);
		  	usync[slice_num_auto] = 1'b0;
		  	usync_txn.randomize with {cmd == ccu_ob::SET; sig == ccu_ob::usync; data == usync; slice_num == slice_num_auto;};
		  	ob_seq.send_xaction( usync_sqr, usync_txn);
		  end
  	  end
  	  join_none
    end
    else
      @(posedge clk_vintf.ungated_clocks[slice_num]);
endtask

`endif //INC_ccu_driver

