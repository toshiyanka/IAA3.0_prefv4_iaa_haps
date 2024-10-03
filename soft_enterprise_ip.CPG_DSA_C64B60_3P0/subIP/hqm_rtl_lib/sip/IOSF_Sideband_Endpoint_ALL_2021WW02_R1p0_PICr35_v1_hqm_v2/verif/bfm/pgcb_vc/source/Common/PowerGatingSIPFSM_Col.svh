/*THIS FILE IS GENERATED. DO NOT MODIFY*/
class PowerGatingSIPFSM_Col extends PowerGatingBaseFSM;
	bit no_side_prim_ep;

	//instantiate coverage model
	`ifndef DISABLE_CHASSIS_PG_COVERAGE
		`include "PowerGatingCoverageSM.svh"
	`endif
	`ovm_component_utils(PowerGatingSIPFSM_Col)

	logic temp_pmc_ip_restore_b;
	logic temp_fdfx_pgcb_bypass;
	logic temp_fdfx_pgcb_ovr;	
	logic temp_pmc_ip_pg_wake;
	logic temp_pmc_ip_sw_pg_req_b;
	logic[MAX_SIP-1:0] temp_side_pok;
	logic[MAX_SIP-1:0] temp_side_rst_b;
	logic[MAX_SIP-1:0] temp_prim_pok;
	logic[MAX_SIP-1:0] temp_prim_rst_b;
	logic[MAX_SIP-1:0] temp_ip_pmc_d3;
	logic[MAX_SIP-1:0] temp_ip_pmc_d0i3;

	function new(string name = "", ovm_component parent);
		super.new(name, parent);

		`ifndef DISABLE_CHASSIS_POWER_GATING_COVERAGE
		cov_pon_acc_state = new();
		cov_pon_acc_state.set_inst_name({get_name()});
		cov_pmc_wake_in_acc_state = new();
		cov_pmc_wake_in_acc_state.set_inst_name({get_name()});
		cov_sw_pg_asd_pmc_wake1 = new();
		cov_sw_pg_asd_pmc_wake1.set_inst_name({get_name()});
	
		cov_inacc_state = new();
		cov_inacc_state.set_inst_name({get_name()});		
		cov_pmc_wake_in_inacc_state = new();
		cov_pmc_wake_in_inacc_state.set_inst_name({get_name()});

		`endif
	endfunction

   	virtual task run();
		driveResetSignaling();
		x.source = i;x.sourceName = name;
		x.typ = PowerGating::SIP;		
		if (sip_if.reset_b !== 1) begin
			@(posedge sip_if.reset_b);
		end
		forever begin
			fork
				fsm();
				waitForReset();
				pmc_ip_restore_b_monitor();
				//DFX
				fdfx_pgcb_bypass_monitor();
				fdfx_pgcb_ovr_monitor();				
				
				//START collage uncomment out
				pmc_ip_pg_wake_monitor();
				pmc_ip_sw_pg_req_b_monitor();
				//POK
				side_pok_monitor();
				prim_pok_monitor();
				//rst
				side_rst_b_monitor();
				prim_rst_b_monitor();				
				//D3 and D0I3
				ip_pmc_d3_monitor();
				ip_pmc_d0i3_monitor();
				//END collage uncomment out

			`ifndef DISABLE_CHASSIS_POWER_GATING_COVERAGE
				sample_state_cov();
				sample_sig_cov();
			`endif
			join_any
			disable fork;
		end
	endtask: run
	virtual task waitForReset();
		@(negedge sip_if.reset_b);
		driveResetSignaling();
	endtask: waitForReset

	`ifndef DISABLE_CHASSIS_POWER_GATING_COVERAGE	
	virtual task sample_state_cov();
	forever begin
		@(state);
		cov_pon_acc_state.sample();
		cov_inacc_state.sample();
	end
	endtask
	virtual task sample_sig_cov();
	forever begin
		@(negedge sip_if.pmc_ip_sw_pg_req_b)
		cov_sw_pg_asd_pmc_wake1.sample();
	end
	endtask
	`endif

	protected virtual task driveResetSignaling();
			no_side_prim_ep = cfg.cfg_sip_pgcb_n[name].num_side == 0 && cfg.cfg_sip_pgcb_n[name].num_prim == 0 ? 1 : 0;

			if(cfg.cfg_sip_pgcb_n[name].initial_state == PowerGating::POWER_GATED) begin
				state = PowerGating::INAPF;
			end
			else if(cfg.cfg_sip_pgcb_n[name].initial_state == PowerGating::POWER_UNGATED) begin
				state = PowerGating::PWRON;
			end		
			else if(cfg.cfg_sip_pgcb_n[name].initial_state == PowerGating::POWER_UNGATED_POK0) begin
				state = PowerGating::INAPN;
			end						
			if(cfg.cfg_sip_pgcb_n[name].initial_restore_asserted == 1) 
				temp_pmc_ip_restore_b = 1'b0;
			else
				temp_pmc_ip_restore_b = 1'b1;	

			temp_fdfx_pgcb_bypass = 1'b0;
			temp_fdfx_pgcb_ovr = 1'b0;			

			//START collage uncomment out
			temp_pmc_ip_sw_pg_req_b = 1'b1;
			temp_pmc_ip_pg_wake = 1'b0;
			//PGCB
			if(cfg.cfg_sip_pgcb_n[name].initial_state == PowerGating::POWER_GATED || cfg.cfg_sip_pgcb_n[name].initial_state == PowerGating::POWER_UNGATED_POK0) begin
				for(int k = 0; k < cfg.cfg_sip_pgcb_n[name].num_side; k++) begin
					temp_side_pok[k] = 1'b0;
				end
				for(int k = 0; k < cfg.cfg_sip_pgcb_n[name].num_prim; k++) begin
					temp_prim_pok[k] = 1'b0;
				end
			end		
			else if(cfg.cfg_sip_pgcb_n[name].initial_state == PowerGating::POWER_UNGATED) begin
				for(int k = 0; k < cfg.cfg_sip_pgcb_n[name].num_side; k++) begin
					temp_side_pok[k] = 1'b1;
				end
				for(int k = 0; k < cfg.cfg_sip_pgcb_n[name].num_prim; k++) begin
					temp_prim_pok[k] = 1'b1;
				end
			end			
			//D3
			for(int k = 0; k < cfg.cfg_sip_pgcb_n[name].num_d3 ; k++) begin
				temp_ip_pmc_d3[k] = 1'b0;
			end
			//D0I3
			for(int k = 0; k < cfg.cfg_sip_pgcb_n[name].num_d0i3 ; k++) begin
				temp_ip_pmc_d0i3[k] = 1'b0;
			end
			//END collage uncomment out
	endtask : driveResetSignaling
	//`CHASSIS_PG_MONITOR(pmc_ip_restore_b, cfg.num_sip_pgcb, reset_b, SIP_RESTORE_DSD, SIP_RESTORE, SIP, 1)
	task pmc_ip_restore_b_monitor(); 
		PowerGatingMonitorSeqItem x; 
		forever begin 
			@(posedge sip_if.clk) 
				if (sip_if.reset_b === 1 && sip_if.pmc_ip_restore_b === 0 && temp_pmc_ip_restore_b === 1) begin 
					x = new(); 
					x.source = i;x.sourceName = name; 
					x.startTime = $time; 
					x.typ = PowerGating::SIP; 
					x.evnt = PowerGating::SIP_RESTORE; 
					x.sourceName = name;
					ap.write(x); 
				end
				/*if (sip_if.reset_b === 1 && sip_if.pmc_ip_restore_b === 1 && temp_pmc_ip_restore_b === 0) begin 
					x = new(); 
					x.source = i;x.sourceName = name; 
					x.startTime = $time; 
					x.typ = PowerGating::SIP; 
					x.evnt = PowerGating::SIP_RESTORE_DSD; 
					x.sourceName = name;
					ap.write(x); 
				end 
				*/
				temp_pmc_ip_restore_b = sip_if.pmc_ip_restore_b; 
			end 
	endtask: pmc_ip_restore_b_monitor 
	//DFX
	//`CHASSIS_PG_MONITOR(fdfx_pgcb_bypass, cfg.num_sip_pgcb, reset_b, FDFX_BYPASS_ASD, FDFX_BYPASS_DSD, SIP, 0)
	task fdfx_pgcb_bypass_monitor(); 
		PowerGatingMonitorSeqItem x; 
		forever begin 
			@(posedge sip_if.jtag_tck) 
				if (sip_if.reset_b === 1 && sip_if.fdfx_pgcb_bypass === 0 && temp_fdfx_pgcb_bypass === 1) begin 
					x = new(); 
					x.source = i;x.sourceName = name; 
					x.startTime = $time; 
					x.typ = PowerGating::SIP; 
					x.evnt = PowerGating::FDFX_BYPASS_DSD; 
					x.sourceName = name;
					ap.write(x); 
				end
				if (sip_if.reset_b === 1 && sip_if.fdfx_pgcb_bypass === 1 && temp_fdfx_pgcb_bypass === 0) begin 
					x = new(); 
					x.source = i;x.sourceName = name; 
					x.startTime = $time; 
					x.typ = PowerGating::SIP; 
					x.evnt = PowerGating::FDFX_BYPASS_ASD; 
					x.sourceName = name;
					ap.write(x); 
				end 
				temp_fdfx_pgcb_bypass = sip_if.fdfx_pgcb_bypass; 
			end 
	endtask: fdfx_pgcb_bypass_monitor 
	
	//`CHASSIS_PG_MONITOR(fdfx_pgcb_ovr, cfg.num_sip_pgcb, reset_b, FDFX_OVR_ASD, FDFX_OVR_DSD, SIP, 0)
	task fdfx_pgcb_ovr_monitor(); 
		PowerGatingMonitorSeqItem x; 
		forever begin 
			@(posedge sip_if.jtag_tck) 
				if (sip_if.reset_b === 1 && sip_if.fdfx_pgcb_ovr === 0 && temp_fdfx_pgcb_ovr === 1) begin 
					x = new(); 
					x.source = i;x.sourceName = name; 
					x.startTime = $time; 
					x.typ = PowerGating::SIP; 
					x.evnt = PowerGating::FDFX_OVR_DSD; 
					x.sourceName = name;
					ap.write(x); 
				end
				if (sip_if.reset_b === 1 && sip_if.fdfx_pgcb_ovr === 1 && temp_fdfx_pgcb_ovr === 0) begin 
					x = new(); 
					x.source = i;x.sourceName = name; 
					x.startTime = $time; 
					x.typ = PowerGating::SIP; 
					x.evnt = PowerGating::FDFX_OVR_ASD; 
					x.sourceName = name;
					ap.write(x); 
				end 
				temp_fdfx_pgcb_ovr = sip_if.fdfx_pgcb_ovr; 
			end 
	endtask: fdfx_pgcb_ovr_monitor 

	`include "PowerGatingMonitorInclude_Col.svh"

	task fsm();
		forever begin
			@(posedge sip_if.clk);
			wait(sip_if.reset_b === 1);
			x.startTime = $time;			
			case (state)
				PowerGating::PWRON:
				begin
					if(sip_if.ip_pmc_pg_req_b === 0) begin
						//cannot check pmc_wake value here becaseu tehre can be a corner case where pmc_wake asserts the same clock pg_req_b deasserts
						if(cfg.cfg_sip_pgcb_n[name].fabric_name != "") begin
							if(fab_if.pmc_fab_pg_rdy_req_b !== 0) begin
								`chassis_power_gating_error({get_name(), "_fabric_hs_check"}, $psprintf("ip_pmc_pg_req_b[%-d] asserted when pmc_ip_pg_rdy_req_b[%-d] was deasserted", i, cfg.cfg_sip_pgcb_n[name].fabric_name));	
							end
						end		
						state = PowerGating::PG_HS;	
						x.evnt = PowerGating::SIP_PG_REQ;
						x.sourceName = name; 
						// = cfg.cfg_sip_pgcb_n[name].fabric_name;				
						x.state = state;
						ap.write(x);
					end							
					else if(no_side_prim_ep == 0)begin
						bit pok_asserted;
						if(1) begin
							if($countones(sip_if.side_pok) != 0) begin
								pok_asserted = 1;
								continue;
							end
						end
						if(1)begin
							if($countones(sip_if.prim_pok) != 0) begin
								pok_asserted = 1;
								continue;
							end
						end
						if(pok_asserted == 0) begin
							state = PowerGating::INAPN;	
						end
					end
			
				end	
				PowerGating::PG_HS:
				begin
					if(sip_if.pmc_ip_pg_ack_b === 0) begin
						state = PowerGating::ACPOF;	
						x.evnt = PowerGating::SIP_PG_ACK;
						x.state = state;
						x.sourceName = name; 
						// = cfg.cfg_sip_pgcb_n[name].fabric_name;							
						ap.write(x);
					end	
				end					
				PowerGating::ACPOF:
				begin
					if (sip_if.ip_pmc_pg_req_b === 1) begin
						if(cfg.cfg_sip_pgcb_n[name].fabric_name != "") begin
							if(fab_if.pmc_fab_pg_rdy_req_b !== 1) begin
								`chassis_power_gating_error({get_name(), "_fabric_hs_check"}, $psprintf("ip_pmc_pg_req_b[%-d] deasserted when pmc_ip_pg_rdy_req_b[%-d] was asserted", i, cfg.cfg_sip_pgcb_n[name].fabric_name));	
							end
						end							
						state = PowerGating::UG_HS;	
						x.evnt = PowerGating::SIP_UG_REQ;
						x.state = state;
						x.sourceName = name; 
						// = cfg.cfg_sip_pgcb_n[name].fabric_name;							
						ap.write(x);
					end							
					if (sip_if.pmc_ip_pg_wake === 1) begin
						`ifndef DISABLE_CHASSIS_POWER_GATING_COVERAGE
						cov_pmc_wake_in_acc_state.sample();
						`endif
					end								
				end	
				PowerGating::UG_HS:
				begin
					if(sip_if.pmc_ip_pg_ack_b === 1) begin
						if(sip_if.pmc_ip_restore_b === 0) begin
							state = PowerGating::RESTO;	
							x.evnt = PowerGating::SIP_UG_ACK;
							x.state = state;
							x.sourceName = name; 
							// = cfg.cfg_sip_pgcb_n[name].fabric_name;								
							ap.write(x);
						end
						else begin
							state = PowerGating::PWRON;	
							x.evnt = PowerGating::SIP_UG_ACK;
							x.state = state;
							x.sourceName = name; 
							// = cfg.cfg_sip_pgcb_n[name].fabric_name;									
							ap.write(x);
						end
					end							
				end		
				PowerGating::POKAS:		
				begin
					bit pok_deasserted;
					if(1) begin
						if($countones(sip_if.side_pok) == 0) begin
							pok_deasserted = 1;
							continue;
						end
					end
					if(1)begin
						if($countones(sip_if.prim_pok) == 0) begin
							pok_deasserted = 1;
							continue;
						end
					end
					if(pok_deasserted == 0) begin
						state = PowerGating::PWRON;	
					end							
				end
				PowerGating::POKRS:
				begin
					bit pok_deasserted;
					if(1) begin
						if($countones(sip_if.side_pok) == 0) begin
							pok_deasserted = 1;
							continue;
						end
					end
					if(1)begin
						if($countones(sip_if.prim_pok) == 0) begin
							pok_deasserted = 1;
							continue;
						end
					end
					if(pok_deasserted == 0) begin
						state = PowerGating::RESTO;	
					end							
				end				
				PowerGating::RESTO:
				begin
					if(sip_if.pmc_ip_restore_b === 1) begin
						state = PowerGating::PWRON;	
						x.evnt = PowerGating::SIP_RESTORE_DSD;
						x.state = state;
						x.sourceName = name; 
						// = cfg.cfg_sip_pgcb_n[name].fabric_name;							
						ap.write(x);
					end							
					else if(sip_if.ip_pmc_pg_req_b === 0) begin
						`chassis_power_gating_error(get_full_name(), $psprintf("ip_pmc_pg_req_b was asserted by %s (index %03d) during the RESTORE window. PMC requested a RESTORE window. So an IP must assert ip_pmc_pg_req_b only after pmc_ip_restore_b deasserts", name, i))
						//Also move to the next state and move on
						state = PowerGating::PG_HS;	
						x.evnt = PowerGating::SIP_PG_REQ;
						x.state = state;
						x.sourceName = name; 
						// = cfg.cfg_sip_pgcb_n[name].fabric_name;							
						ap.write(x);
					end					
				end	
				PowerGating::INAPF:
				begin			
					//From inacc state, only PMC wake can wake an IP.
					if (sip_if.pmc_ip_pg_wake === 1) begin	
						`ifndef DISABLE_CHASSIS_POWER_GATING_COVERAGE
						cov_pmc_wake_in_inacc_state.sample();
						`endif
						state = PowerGating::UGWAK;
					end						
					//this is for fabric SIP interfaces
					else if(cfg.cfg_sip_pgcb_n[name].fabric_name != "" && sip_if.ip_pmc_pg_req_b === 1) begin
						state = PowerGating::UGHSI;	
						x.evnt = PowerGating::SIP_UG_REQ;
						x.state = state;
						x.sourceName = name; 
						// = cfg.cfg_sip_pgcb_n[name].fabric_name;							
						ap.write(x);
					end
					//check only if this is not part of the fabric interface
					else if(sip_if.ip_pmc_pg_req_b === 1 && cfg.cfg_sip_pgcb_n[name].fabric_name == "") begin
						`chassis_power_gating_error(get_name(), $psprintf("SIP %3d deasserted ip_pmc_pg_req while in Inaccessible PG state without a pmc_wake", i))
						state = PowerGating::UGFET;	
						x.evnt = PowerGating::SIP_UG_REQ;
						x.state = state;
						x.sourceName = name; 
						// = cfg.cfg_sip_pgcb_n[name].fabric_name;							
						ap.write(x);						
					end
				end	
				PowerGating::UGWAK:
				begin	
					if (sip_if.ip_pmc_pg_req_b === 1) begin
						state = PowerGating::UGFET;	
						x.evnt = PowerGating::SIP_UG_REQ;
						x.state = state;
						x.sourceName = name; 
						// = cfg.cfg_sip_pgcb_n[name].fabric_name;							
						ap.write(x);
					end		
				end
				//Alamelu: June 11th 2013 Added Fet also here to complete the Fet checking as per PMC request.
				PowerGating::UGFET:
				begin	
					if(sip_if.fet_en_b === 0) begin
						state = PowerGating::UGFEA;	
					end		
				end				
				PowerGating::UGFEA:
				begin	
					if (sip_if.fet_en_ack_b === 0) begin
						state = PowerGating::UGHSI;	
					end		
				end	
				PowerGating::UGHSI:
				begin
					if(sip_if.pmc_ip_pg_ack_b === 1) begin
						if(sip_if.pmc_ip_restore_b === 0) begin
							state = PowerGating::POKRS;	
							x.evnt = PowerGating::SIP_UG_ACK;
							x.state = state;
							x.sourceName = name; 
							// = cfg.cfg_sip_pgcb_n[name].fabric_name;								
							ap.write(x);
						end
						else begin
							state = PowerGating::POKAS;	
							x.evnt = PowerGating::SIP_UG_ACK;
							x.state = state;
							x.sourceName = name; 
							// = cfg.cfg_sip_pgcb_n[name].fabric_name;								
							ap.write(x);
						end
					end							
				end					
				PowerGating::INAPN:
				begin
				
					if(sip_if.ip_pmc_pg_req_b === 0) begin
						state = PowerGating::PGHSI;	
						x.evnt = PowerGating::SIP_PG_REQ;
						x.state = state;
						x.sourceName = name; 
						// = cfg.cfg_sip_pgcb_n[name].fabric_name;							
						ap.write(x);
					end	
					//From inacc state, only PMC wake can wake an IP.
					else if(sip_if.pmc_ip_pg_wake === 1) begin
						`ifndef DISABLE_CHASSIS_POWER_GATING_COVERAGE
						cov_pmc_wake_in_inacc_state.sample();
						`endif
						state = PowerGating::UGWK_W;							
					end
					//if any POK asserted, it is an error. so make sure all poks are 0
					//But this is not true for the fabric interface
					else if(cfg.cfg_sip_pgcb_n[name].fabric_name == "")  begin
						bit pok_asserted;
						if(1) begin
						if($countones(sip_if.side_pok) == cfg.cfg_sip_pgcb_n[name].num_side) begin
							pok_asserted = 1;
							continue;
						end
						end
						if(1)begin
						if($countones(sip_if.prim_pok) == cfg.cfg_sip_pgcb_n[name].num_prim) begin
							pok_asserted = 1;
							continue;
						end
						end
						if(pok_asserted == 1) begin
							`chassis_power_gating_error(get_name(), $psprintf("SIP %3d deasserted its side/prim pok while in Inaccessible PON state without a pmc_wake", i))						
							state = PowerGating::PWRON;	
						end
					end	
				end

				PowerGating::UGWK_W:
				begin
					bit pok_deasserted;	
					if(1) begin
						if($countones(sip_if.side_pok) == 0) begin
							pok_deasserted = 1;
							continue;
						end
					end
					if(1)begin
						if($countones(sip_if.prim_pok) == 0) begin
							pok_deasserted = 1;
							continue;
						end
					end
					if(pok_deasserted == 0) begin
						state = PowerGating::PWRON;	
					end
				end

				PowerGating::PGHSI:
				begin
					if(sip_if.pmc_ip_pg_ack_b === 0) begin
						state = PowerGating::INAPF;	
						x.evnt = PowerGating::SIP_PG_ACK;
						x.state = state;
						x.sourceName = name; 
						// = cfg.cfg_sip_pgcb_n[name].fabric_name;							
						ap.write(x);
					end	
				end						
			endcase
		end
	endtask: fsm
 
	/******************************************************************************************
	// 
	// check error
	//
	******************************************************************************************/   
	function void check();
		super.check();
		if(cfg.disable_eot_check == 0 && !(state inside {PowerGating::PWRON, PowerGating::ACPOF, PowerGating::INAPN, PowerGating::INAPF}))
		begin
			string str;
			$sformat(str, "Test ended with PGCB %-d (%s) in state %s. The PGCB can only be in states PWRON, ACPOF, INAPN, INAPF at the end of the test. Please refer to the tracker/monitor state machine diagram in the tracker userguide", i, name, state);
			`chassis_power_gating_error({get_name(), "_chassis_sip_pg_end_of_test"}, str);
		end
	endfunction

endclass: PowerGatingSIPFSM_Col


