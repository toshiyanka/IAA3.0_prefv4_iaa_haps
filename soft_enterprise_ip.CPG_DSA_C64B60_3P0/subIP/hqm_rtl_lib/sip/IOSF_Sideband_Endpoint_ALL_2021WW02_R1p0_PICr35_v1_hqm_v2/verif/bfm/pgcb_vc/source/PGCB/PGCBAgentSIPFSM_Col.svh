/*THIS FILE IS GENERATED. DO NOT MODIFY*/
class PGCBAgentSIPFSM_Col extends PowerGatingBaseFSM;

	`ovm_component_utils(PGCBAgentSIPFSM_Col)

	function new(string name = "", ovm_component parent);
		super.new(name, parent);
	endfunction

   	virtual task run();
		driveResetSignaling();	
		if (sip_if.reset_b !== 1) begin
			@(posedge sip_if.reset_b);
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
		@(negedge sip_if.reset_b);
		driveResetSignaling();		
	endtask: waitForReset

	protected virtual task driveResetSignaling();

			if(cfg.cfg_sip_pgcb_n[name].initial_state == PowerGating::POWER_GATED) begin
				state = PowerGating::ACPOF;
			end
			else begin
				state = PowerGating::PWRON;
			end		
	endtask : driveResetSignaling

	task fsm();
		forever begin
			@(posedge sip_if.clk);
			wait(sip_if.reset_b === 1);
			x.source = i;x.sourceName = name;

			case (state)
				PowerGating::UG_REQ:
				begin
					if(sip_if.ip_pmc_pg_req_b === 1) begin
						state = PowerGating::UG_HS;	
						x.state = state;
						ap.write(x);
					end							
				end	
				PowerGating::UG_HS:
				begin
					if(sip_if.pmc_ip_pg_ack_b === 1) begin
						state = PowerGating::PWRON;	
						x.state = state;
						ap.write(x);
					end							
				end					
				PowerGating::PWRON:
				begin
					//HW PG and PMC wake is 0
					if(sip_if.ip_pmc_pg_req_b === 0) begin
						state = PowerGating::PG_HS;	
						x.state = state;
						ap.write(x);
					end
					//SW PG and PMC wake is 0
					else if(sip_if.pmc_ip_pg_wake === 0 && 
						sip_if.pmc_ip_sw_pg_req_b === 0 && 
						cfg.cfg_sip_pgcb[i].ignore_sw_req == 0 
					) begin
						state = PowerGating::PG_REQ;	
						x.state = state;
						ap.write(x);
					end						
				end	
				PowerGating::PG_REQ:
				begin
				if(sip_if.ip_pmc_pg_req_b === 0) begin
						state = PowerGating::PG_HS;	
						x.state = state;
						ap.write(x);
					end							
				end	
				PowerGating::PG_HS:
				begin
					if(sip_if.pmc_ip_pg_ack_b === 0) begin
						state = PowerGating::ACPOF;	
						x.state = state;
						ap.write(x);
					end
				   
				end					
				PowerGating::ACPOF:
				begin
				   if(sip_if.pmc_ip_pg_wake === 1) begin
						state = PowerGating::UG_REQ;	
						x.state = state;
						ap.write(x);
					end
					else if (sip_if.ip_pmc_pg_req_b === 1) begin
						state = PowerGating::UG_HS;	
						x.state = state;
						ap.write(x);
					end							
				end	
			endcase
		end
	endtask: fsm
endclass: PGCBAgentSIPFSM_Col


