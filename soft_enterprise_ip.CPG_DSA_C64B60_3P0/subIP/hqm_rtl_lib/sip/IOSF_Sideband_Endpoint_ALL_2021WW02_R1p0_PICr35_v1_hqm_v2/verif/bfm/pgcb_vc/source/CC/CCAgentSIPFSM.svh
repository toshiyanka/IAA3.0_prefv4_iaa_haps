class CCAgentSIPFSM extends PowerGatingBaseFSM;


	`ovm_component_utils(CCAgentSIPFSM)

	function new(string name = "", ovm_component parent);
		super.new(name, parent);
		
	endfunction

	logic temp_pmc_ip_vnn_ack;
	logic temp_ip_pmc_vnn_req;

   	virtual task run();
		driveResetSignaling();
		x.source = i;
		if (vif.reset_b !== 1) begin
			@(posedge vif.reset_b);
		end
		forever begin
			fork
				fsm();
				waitForReset();
				vnn_req_monitor();

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

			temp_ip_pmc_vnn_req = 1'b0;
			temp_pmc_ip_vnn_ack = 1'b0;

	endtask : driveResetSignaling

	task fsm();
		forever begin
			@(posedge vif.clk);
			wait(vif.reset_b === 1);
			case (state)

				PowerGating::UGFET:
				begin
					if(vif.fet_en_b[cfg.cfg_sip_pgcb[i].getFETNum()] === 0) begin
						state = PowerGating::UGFEA;	
						x.state = state;
						ap.write(x);
					end							
				end	
				PowerGating::UGFEA:
				begin

					if(vif.fet_en_ack_b[cfg.cfg_sip_pgcb[i].getFETNum()] === 0) begin
							state = PowerGating::UG_HS;	
							x.state = state;
							ap.write(x);
					end
				end						
				PowerGating::UG_HS:
				begin
					if(vif.pmc_ip_pg_ack_b[i] === 1) begin
						if(vif.pmc_ip_restore_b[i] === 1) begin
							state = PowerGating::PWRON;	
							x.state = state;
							ap.write(x);
						end	
						else begin
							state = PowerGating::RESTO;	
							vif.restore_next_wake[i] = 0;
							x.state = state;
							ap.write(x);						
						end
					end							
				end					
				PowerGating::RESTO:
				begin
					if(vif.pmc_ip_restore_b[i] === 1) begin
						state = PowerGating::PWRON;	
						x.state = state;
						ap.write(x);
					end	
				end
				PowerGating::PWRON:
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
					if (vif.ip_pmc_pg_req_b[i] === 1) begin
						state = PowerGating::UGFET;	
						x.state = state;
						ap.write(x);
					end							
				end	

			endcase
		end
	endtask: fsm

	task vnn_req_monitor(); 
		PowerGatingMonitorSeqItem x; 
		forever begin 
			@(posedge vif.clk) 
				if (vif.reset_b === 1 && vif.ip_pmc_vnn_req[i] === 0 && temp_ip_pmc_vnn_req === 1) begin 
					x = new(); 
					x.state = state;
					x.source = i; 
					x.startTime = $time; 
					x.typ = PowerGating::SIP; 
					x.evnt = PowerGating::VNN_ACK_DSD; 
					x.sourceName = cfg.sip_name_sb_ep[i];
					ap.write(x); 
				end
				if (vif.reset_b === 1 && vif.ip_pmc_vnn_req[i] === 1 && temp_ip_pmc_vnn_req === 0) begin 
					x = new(); 
					x.state = state;
					x.source = i; 
					x.startTime = $time; 
					x.typ = PowerGating::SIP; 
					x.evnt = PowerGating::VNN_ACK_ASD; 
					x.sourceName = cfg.sip_name_sb_ep[i];
				    ap.write(x); 
				end 
				temp_ip_pmc_vnn_req = vif.ip_pmc_vnn_req[i]; 
			end 

	endtask: vnn_req_monitor 
	

endclass: CCAgentSIPFSM


