/*THIS FILE IS GENERATED. DO NOT MODIFY*/
class PowerGatingFabricFSM_Col extends PowerGatingBaseFSM;

	`ovm_component_utils(PowerGatingFabricFSM_Col)

	logic[MAX_FAB:0] temp_fab_pmc_idle;

	function new(string name = "", ovm_component parent);
		super.new(name, parent);
	endfunction

   	virtual task run();
		driveResetSignaling();	
		x.source = i;x.sourceName = name;		
		x.typ = PowerGating::FAB;		
		if (fab_if.reset_b !== 1) begin
			@(posedge fab_if.reset_b);
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
			@(posedge fab_if.clk iff cfg.no_fab == 0) 
				if (fab_if.reset_b === 1 && fab_if.fab_pmc_idle === 0 && temp_fab_pmc_idle === 1) begin 
					x = new(); 
					x.source = i;x.sourceName = name; 
					x.startTime = $time; 
					x.typ = PowerGating::FAB; 
					x.evnt = PowerGating::FAB_IDLE_EXIT; 
					x.sourceName = name; 
					if(cfg.no_fab == 0) x.state = state; 
					ap.write(x); 
				end
				if (fab_if.reset_b === 1 && fab_if.fab_pmc_idle === 1 && temp_fab_pmc_idle === 0) begin 
					x = new(); 
					x.source = i;x.sourceName = name; 
					x.startTime = $time; 
					x.typ = PowerGating::FAB; 
					x.evnt = PowerGating::FAB_IDLE; 
					x.sourceName = name; 
					if(cfg.no_fab == 0) x.state = state; 
					ap.write(x); 
				end 
				temp_fab_pmc_idle = fab_if.fab_pmc_idle; 
		end 
	endtask: fab_pmc_idle_monitor 

	virtual task waitForReset();
		@(negedge fab_if.reset_b);
		driveResetSignaling();
	endtask: waitForReset
	protected virtual task driveResetSignaling();
			//TODO: follow-up with Hartej about whether this is needed
			/*if(!cfg.sip_belongs_to_fabric.exists(i)) begin
				`chassis_power_gating_error({get_name(), "_fabric_index"}, $psprintf("Fabric interface %-d does not have any SIP interface associated with it. User needs to add a SIP PGCB and specify fabric_index.", i));	
			end
			*/
			if(cfg.cfg_fab_pgcb_n[name].initial_state == PowerGating::POWER_GATED) begin
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
			@(posedge fab_if.clk);
			wait(fab_if.reset_b === 1);
 
			case (state)
				PowerGating::PWRON:
				begin			
					if(fab_if.pmc_fab_pg_rdy_req_b === 0) begin
						state = PowerGating::ACKID;
						x.evnt = PowerGating::FAB_PG_REQ;
						x.state = state;
						x.startTime = $time;
						x.sourceName = name;						
						ap.write(x);
					end	
				end
			    PowerGating::ACKID:
				begin
					if(fab_if.fab_pmc_pg_rdy_nack_b === 0) begin
						if(cfg.sip_belongs_to_fabric.exists(i)) begin
						
						if((sip_if.pmc_ip_pg_ack_b & sip_if.ip_pmc_pg_req_b) !== 1) begin
							`chassis_power_gating_error({get_name(), "_fabric_hs_gate_check"}, $psprintf("fab_pmc_pg_rdy_nack_b[%-s] asserted when ip_pmc_pg_req_b/pmc_ip_pg_ack_b[%-s] was asserted. Fabric cannot nack a power gating request after asserting ip_pmc_pg_req_b", name, cfg.sip_belongs_to_fabric_n[name]));							
						end	
						end
						else begin
							`chassis_power_gating_error({get_name(), "_fabric_sip_exists_check"}, $psprintf("Fabric interface %-d does not have any SIP interface associated with it. User needs to add a SIP PGCB and specify fabric_index.", i));	
						end

						state = PowerGating::REQ_1;
						x.evnt = PowerGating::FAB_PG_NACK;
						x.state = state;
						x.startTime = $time;
						x.sourceName = name;							
						ap.write(x);
					end					
					else if(fab_if.fab_pmc_pg_rdy_ack_b === 0) begin
						if(cfg.sip_belongs_to_fabric.exists(i)) begin
						if(sip_if.pmc_ip_pg_ack_b === 1) begin
							`chassis_power_gating_error({get_name(), "_fabric_hs_gate_check"}, $psprintf("fab_pmc_pg_rdy_ack_b[%-s] asserted when pmc_ip_pg_ack_b[%-s] was deasserted.", name, cfg.sip_belongs_to_fabric_n[name]));							
						end	
						end
						else begin
							`chassis_power_gating_error({get_name(), "_fabric_sip_exists_check"}, $psprintf("Fabric interface %-d does not have any SIP interface associated with it. User needs to add a SIP PGCB and specify fabric_index.", i));	
						end
						
						state = PowerGating::PWRGT;
						x.evnt = PowerGating::FAB_PG_ACK;
						x.state = state;
						x.startTime = $time;
						x.sourceName = name;							
						ap.write(x);
					end
				end
				PowerGating::REQ_1:
				begin
					if(fab_if.pmc_fab_pg_rdy_req_b === 1) begin
						state = PowerGating::NACK1;
						x.evnt = PowerGating::FAB_UG_REQ;
						x.state = state;
						x.startTime = $time;
						x.sourceName = name;							
						ap.write(x);
					end
				end
				PowerGating::NACK1:
				begin
					if(fab_if.fab_pmc_pg_rdy_nack_b === 1) begin
						state = PowerGating::PWRON;
						x.evnt = PowerGating::FAB_PG_NACK_DSD;
						x.state = state;
						x.startTime = $time;
						x.sourceName = name;							
						ap.write(x);
					end					
				end
				PowerGating::PWRGT:
				begin
				   if(fab_if.pmc_fab_pg_rdy_req_b === 1) begin
						state = PowerGating::ACKEX;
						x.evnt = PowerGating::FAB_UG_REQ;
						x.state = state;
						x.startTime = $time;
						x.sourceName = name;							
						ap.write(x);
				   end
				end
				PowerGating::ACKEX:
				begin
					if(fab_if.fab_pmc_pg_rdy_ack_b === 1) begin
						if(cfg.sip_belongs_to_fabric.exists(i)) begin
						if(sip_if.pmc_ip_pg_ack_b === 0) begin
							`chassis_power_gating_error({get_name(), "_fabric_hs_ungate_check"}, $psprintf("fab_pmc_pg_rdy_ack_b[%-s] deasserted when pmc_ip_pg_ack_b[%-s] was asserted.", name, cfg.sip_belongs_to_fabric_n[name]));							
						end	
						end
						else begin
							`chassis_power_gating_error({get_name(), "_fabric_sip_exists_check"}, $psprintf("Fabric interface %-d does not have any SIP interface associated with it. User needs to add a SIP PGCB and specify fabric_index.", i));	
						end
						
						state = PowerGating::PWRON;
						x.evnt = PowerGating::FAB_PG_ACK_DSD;
						x.state = state;
						x.startTime = $time;
						x.sourceName = name;							
						ap.write(x);
					end							
				end			
			endcase
		end
	endtask: fsm
endclass: PowerGatingFabricFSM_Col


