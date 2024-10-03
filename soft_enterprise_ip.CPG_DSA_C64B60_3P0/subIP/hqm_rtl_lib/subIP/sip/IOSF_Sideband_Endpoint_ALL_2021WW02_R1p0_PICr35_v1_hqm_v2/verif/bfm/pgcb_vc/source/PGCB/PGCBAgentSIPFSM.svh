class PGCBAgentSIPFSM extends PowerGatingBaseFSM;

	`ovm_component_utils(PGCBAgentSIPFSM)

	function new(string name = "", ovm_component parent);
		super.new(name, parent);
	endfunction

   	virtual task run();
		driveResetSignaling();	
		if (vif.reset_b !== 1) begin
			@(posedge vif.reset_b);
		end
		forever begin
			fork
				fsm();
				waitForReset();
			join_any
			disable fork;
		end
	endtask: run
	virtual task waitForReset();
		@(negedge vif.reset_b);
		driveResetSignaling();		
	endtask: waitForReset

	protected virtual task driveResetSignaling();

			if(cfg.cfg_sip_pgcb[i].initial_state == PowerGating::POWER_GATED) begin
				state = PowerGating::ACPOF;
			end
			else begin
				state = PowerGating::PWRON;
			end		
	endtask : driveResetSignaling

	task fsm();
		forever begin
			@(posedge vif.clk);
			wait(vif.reset_b === 1);
			x.source = i;

			case (state)
				PowerGating::UG_REQ:
				begin
					if(vif.ip_pmc_pg_req_b[i] === 1) begin
						state = PowerGating::UG_HS;	
						x.state = state;
						ap.write(x);
					end							
				end	
				PowerGating::UG_HS:
				begin
					if(vif.pmc_ip_pg_ack_b[i] === 1) begin
						state = PowerGating::PWRON;	
						x.state = state;
						ap.write(x);
					end							
				end					
				PowerGating::PWRON:
				begin
					//HW PG and PMC wake is 0
					if(vif.ip_pmc_pg_req_b[i] === 0) begin
						state = PowerGating::PG_HS;	
						x.state = state;
						ap.write(x);
					end
					//SW PG and PMC wake is 0
					else if(vif.pmc_ip_pg_wake[cfg.cfg_sip_pgcb[i].pmc_wake_index] === 0 && 
						vif.pmc_ip_sw_pg_req_b[cfg.cfg_sip_pgcb[i].sw_ent_index] === 0 && 
						cfg.cfg_sip_pgcb[i].ignore_sw_req == 0 
					) begin
						state = PowerGating::PG_REQ;	
						x.state = state;
						ap.write(x);
					end						
				end	
				PowerGating::PG_REQ:
				begin
				if(vif.ip_pmc_pg_req_b[i] === 0) begin
						state = PowerGating::PG_HS;	
						x.state = state;
						ap.write(x);
					end							
				end	
				PowerGating::PG_HS:
				begin
					if(vif.pmc_ip_pg_ack_b[i] === 0) begin
						state = PowerGating::ACPOF;	
						x.state = state;
						ap.write(x);
					end
				   
				end					
				PowerGating::ACPOF:
				begin
				   if(vif.pmc_ip_pg_wake[cfg.cfg_sip_pgcb[i].pmc_wake_index] === 1) begin
						state = PowerGating::UG_REQ;	
						x.state = state;
						ap.write(x);
					end
					else if (vif.ip_pmc_pg_req_b[i] === 1) begin
						state = PowerGating::UG_HS;	
						x.state = state;
						ap.write(x);
					end							
				end	
			endcase
		end
	endtask: fsm
endclass: PGCBAgentSIPFSM


