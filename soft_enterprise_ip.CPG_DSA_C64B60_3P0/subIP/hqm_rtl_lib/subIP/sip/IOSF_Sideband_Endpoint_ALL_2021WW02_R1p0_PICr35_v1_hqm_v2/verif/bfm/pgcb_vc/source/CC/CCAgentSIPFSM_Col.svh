/*THIS FILE IS GENERATED. DO NOT MODIFY*/
class CCAgentSIPFSM_Col extends PowerGatingBaseFSM;


	`ovm_component_utils(CCAgentSIPFSM_Col)

	function new(string name = "", ovm_component parent);
		super.new(name, parent);
		
	endfunction


   	virtual task run();
		driveResetSignaling();
		x.source = i;x.sourceName = name;
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
			case (state)

				PowerGating::UGFET:
				begin
					if(sip_if.fet_en_b === 0) begin
						state = PowerGating::UGFEA;	
						x.state = state;
						ap.write(x);
					end							
				end	
				PowerGating::UGFEA:
				begin

					if(sip_if.fet_en_ack_b === 0) begin
							state = PowerGating::UG_HS;	
							x.state = state;
							ap.write(x);
					end
				end						
				PowerGating::UG_HS:
				begin
					if(sip_if.pmc_ip_pg_ack_b === 1) begin
						if(sip_if.pmc_ip_restore_b === 1) begin
							state = PowerGating::PWRON;	
							x.state = state;
							ap.write(x);
						end	
						else begin
							state = PowerGating::RESTO;	
							sip_if.restore_next_wake = 0;
							x.state = state;
							ap.write(x);						
						end
					end							
				end					
				PowerGating::RESTO:
				begin
					if(sip_if.pmc_ip_restore_b === 1) begin
						state = PowerGating::PWRON;	
						x.state = state;
						ap.write(x);
					end	
				end
				PowerGating::PWRON:
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
					if (sip_if.ip_pmc_pg_req_b === 1) begin
						state = PowerGating::UGFET;	
						x.state = state;
						ap.write(x);
					end							
				end	

			endcase
		end
	endtask: fsm
endclass: CCAgentSIPFSM_Col


