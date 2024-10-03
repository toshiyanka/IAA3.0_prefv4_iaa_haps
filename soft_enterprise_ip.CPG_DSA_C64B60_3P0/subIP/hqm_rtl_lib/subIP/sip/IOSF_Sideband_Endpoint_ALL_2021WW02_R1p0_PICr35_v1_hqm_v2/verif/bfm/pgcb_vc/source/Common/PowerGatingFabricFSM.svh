class PowerGatingFabricFSM extends PowerGatingBaseFSM;

	`ovm_component_utils(PowerGatingFabricFSM)

	logic[MAX_FAB:0] temp_fab_pmc_idle;

	function new(string name = "", ovm_component parent);
		super.new(name, parent);
	endfunction

   	virtual task run();
		driveResetSignaling();	
		x.source = i;		
		x.typ = PowerGating::FAB;		
		if (vif.reset_b !== 1) begin
			@(posedge vif.reset_b);
		end
		forever begin
			fork
				fsm();
				waitForReset();
				//fab idle
				fab_pmc_idle_monitor();				
			join_any
			disable fork;
		end
	endtask: run

	//fabric idle signal
	//`CHASSIS_PG_MONITOR(fab_pmc_idle, cfg.num_fab_pgcb, reset_b, FAB_IDLE, FAB_IDLE_EXIT, FAB, 0)
	//`define CHASSIS_PG_MONITOR(NAME, WIDTH, RESET_B, EVENT_1, EVENT_0, TYP, IGNORE_1) \
	task fab_pmc_idle_monitor(); 
		PowerGatingMonitorSeqItem x; 
		forever begin 
			@(posedge vif.clk iff cfg.no_fab == 0) 
				if (vif.reset_b === 1 && vif.fab_pmc_idle[i] === 0 && temp_fab_pmc_idle === 1) begin 
					x = new(); 
					x.source = i; 
					x.startTime = $time; 
					x.typ = PowerGating::FAB; 
					x.evnt = PowerGating::FAB_IDLE_EXIT; 
					x.sourceName = cfg.cfg_fab_pgcb[i].getName(); 
					if(cfg.no_fab == 0) x.state = state; 
					ap.write(x); 
				end
				if (vif.reset_b === 1 && vif.fab_pmc_idle[i] === 1 && temp_fab_pmc_idle === 0) begin 
					x = new(); 
					x.source = i; 
					x.startTime = $time; 
					x.typ = PowerGating::FAB; 
					x.evnt = PowerGating::FAB_IDLE; 
					x.sourceName = cfg.cfg_fab_pgcb[i].getName(); 
					if(cfg.no_fab == 0) x.state = state; 
					ap.write(x); 
				end 
				temp_fab_pmc_idle = vif.fab_pmc_idle[i]; 
		end 
	endtask: fab_pmc_idle_monitor 

	virtual task waitForReset();
		@(negedge vif.reset_b);
		driveResetSignaling();
	endtask: waitForReset
	protected virtual task driveResetSignaling();
			//TODO: follow-up with Hartej about whether this is needed
			/*if(!cfg.sip_belongs_to_fabric.exists(i)) begin
				`chassis_power_gating_error({get_name(), "_fabric_index"}, $psprintf("Fabric interface %-d does not have any SIP interface associated with it. User needs to add a SIP PGCB and specify fabric_index.", i));	
			end
			*/
			if(cfg.cfg_fab_pgcb[i].initial_state == PowerGating::POWER_GATED) begin
				state = PowerGating::PWRGT;
				temp_fab_pmc_idle = 1'b1;
			end
			else begin
				state = PowerGating::PWRON;
				temp_fab_pmc_idle = 1'b0;
			end				
	endtask : driveResetSignaling

	task fsm();	
		forever begin
			@(posedge vif.clk);
			wait(vif.reset_b === 1);
 
			case (state)
				PowerGating::PWRON:
				begin			
					if(vif.pmc_fab_pg_rdy_req_b[i] === 0) begin
						state = PowerGating::ACKID;
						x.evnt = PowerGating::FAB_PG_REQ;
						x.state = state;
						x.startTime = $time;
						x.sourceName = cfg.cfg_fab_pgcb[i].name;						
						ap.write(x);
					end	
				end
			    PowerGating::ACKID:
				begin
					if(vif.fab_pmc_pg_rdy_nack_b[i] === 0) begin
						if(cfg.sip_belongs_to_fabric.exists(i)) begin
						
						if((vif.pmc_ip_pg_ack_b[cfg.sip_belongs_to_fabric[i]] & vif.ip_pmc_pg_req_b[cfg.sip_belongs_to_fabric[i]]) !== 1) begin
							`chassis_power_gating_error({get_name(), "_fabric_hs_gate_check"}, $psprintf("fab_pmc_pg_rdy_nack_b[%-d] asserted when ip_pmc_pg_req_b/pmc_ip_pg_ack_b[%-d] was asserted. Fabric cannot nack a power gating request after asserting ip_pmc_pg_req_b", i, cfg.sip_belongs_to_fabric[i]));							
						end	
						end
						else begin
							`chassis_power_gating_error({get_name(), "_fabric_sip_exists_check"}, $psprintf("Fabric interface %-d does not have any SIP interface associated with it. User needs to add a SIP PGCB and specify fabric_index.", i));	
						end

						state = PowerGating::REQ_1;
						x.evnt = PowerGating::FAB_PG_NACK;
						x.state = state;
						x.startTime = $time;
						x.sourceName = cfg.cfg_fab_pgcb[i].name;							
						ap.write(x);
					end					
					else if(vif.fab_pmc_pg_rdy_ack_b[i] === 0) begin
						if(cfg.sip_belongs_to_fabric.exists(i)) begin
						if(vif.pmc_ip_pg_ack_b[cfg.sip_belongs_to_fabric[i]] === 1) begin
							`chassis_power_gating_error({get_name(), "_fabric_hs_gate_check"}, $psprintf("fab_pmc_pg_rdy_ack_b[%-d] asserted when pmc_ip_pg_ack_b[%-d] was deasserted.", i, cfg.sip_belongs_to_fabric[i]));							
						end	
						end
						else begin
							`chassis_power_gating_error({get_name(), "_fabric_sip_exists_check"}, $psprintf("Fabric interface %-d does not have any SIP interface associated with it. User needs to add a SIP PGCB and specify fabric_index.", i));	
						end
						
						state = PowerGating::PWRGT;
						x.evnt = PowerGating::FAB_PG_ACK;
						x.state = state;
						x.startTime = $time;
						x.sourceName = cfg.cfg_fab_pgcb[i].name;							
						ap.write(x);
					end
				end
				PowerGating::REQ_1:
				begin
					if(vif.pmc_fab_pg_rdy_req_b[i] === 1) begin
						state = PowerGating::NACK1;
						x.evnt = PowerGating::FAB_UG_REQ;
						x.state = state;
						x.startTime = $time;
						x.sourceName = cfg.cfg_fab_pgcb[i].name;							
						ap.write(x);
					end
				end
				PowerGating::NACK1:
				begin
					if(vif.fab_pmc_pg_rdy_nack_b[i] === 1) begin
						state = PowerGating::PWRON;
						x.evnt = PowerGating::FAB_PG_NACK_DSD;
						x.state = state;
						x.startTime = $time;
						x.sourceName = cfg.cfg_fab_pgcb[i].name;							
						ap.write(x);
					end					
				end
				PowerGating::PWRGT:
				begin
				   if(vif.pmc_fab_pg_rdy_req_b[i] === 1) begin
						state = PowerGating::ACKEX;
						x.evnt = PowerGating::FAB_UG_REQ;
						x.state = state;
						x.startTime = $time;
						x.sourceName = cfg.cfg_fab_pgcb[i].name;							
						ap.write(x);
				   end
				end
				PowerGating::ACKEX:
				begin
					if(vif.fab_pmc_pg_rdy_ack_b[i] === 1) begin
						if(cfg.sip_belongs_to_fabric.exists(i)) begin
						if(vif.pmc_ip_pg_ack_b[cfg.sip_belongs_to_fabric[i]] === 0) begin
							`chassis_power_gating_error({get_name(), "_fabric_hs_ungate_check"}, $psprintf("fab_pmc_pg_rdy_ack_b[%-d] deasserted when pmc_ip_pg_ack_b[%-d] was asserted.", i, cfg.sip_belongs_to_fabric[i]));							
						end	
						end
						else begin
							`chassis_power_gating_error({get_name(), "_fabric_sip_exists_check"}, $psprintf("Fabric interface %-d does not have any SIP interface associated with it. User needs to add a SIP PGCB and specify fabric_index.", i));	
						end
						
						state = PowerGating::PWRON;
						x.evnt = PowerGating::FAB_PG_ACK_DSD;
						x.state = state;
						x.startTime = $time;
						x.sourceName = cfg.cfg_fab_pgcb[i].name;							
						ap.write(x);
					end							
				end			
			endcase
		end
	endtask: fsm
endclass: PowerGatingFabricFSM


