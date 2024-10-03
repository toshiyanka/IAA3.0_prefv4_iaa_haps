/*THIS FILE IS GENERATED. DO NOT MODIFY*/
class CCAgentFabricFSM_Col extends PowerGatingBaseFSM;

	`ovm_component_utils(CCAgentFabricFSM_Col)

	function new(string name = "", ovm_component parent);
		super.new(name, parent);
		
	endfunction
 

   	virtual task run();
		driveResetSignaling();
		x.source = i;x.sourceName = name;
		if (fab_if.reset_b !== 1) begin
			@(posedge fab_if.reset_b);
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
		@(negedge fab_if.reset_b);
		driveResetSignaling();
	endtask: waitForReset

	protected virtual task driveResetSignaling();
			if(cfg.cfg_fab_pgcb_n[name].initial_state == PowerGating::POWER_GATED) begin
				state = PowerGating::PWRGT;
			end
			else begin
				state = PowerGating::PWRON;
			end		
	endtask : driveResetSignaling
	task fsm();	
		forever begin
			@(posedge fab_if.clk);
			wait(fab_if.reset_b === 1);
			case (state)
				PowerGating::PWRON:
				begin
					bit agent_idle;
					agent_idle = 1;
					if(fab_if.fab_pmc_idle === 1) begin
						/* START collage comment out						
						if(cfg.cfg_fab_pgcb[i].sip_pgcb_dependency.size() > 0) begin
					   		foreach(cfg.cfg_fab_pgcb[i].sip_pgcb_dependency[agent_num]) begin
								if(vif.ip_pmc_pg_req_b[agent_num] === 1) begin
									agent_idle = 0;
									continue;
								end
							end
						end
						 END collage comment out*/
						if(agent_idle) begin
							state = PowerGating::IDHYS;	
							
							x.state = state;
							ap.write(x);
						end
					end
					if(fab_if.pmc_fab_pg_rdy_req_b === 0) begin
						state = PowerGating::ACKID;
						x.state = state;
						ap.write(x);
					end					
				end
				PowerGating::IDHYS:
				begin
					fork
						begin
							wait(fab_if.pmc_fab_pg_rdy_req_b === 0);
							state = PowerGating::ACKID;
						end
						begin
							//TODO: check agent wake condiditons also here
							wait(fab_if.fab_pmc_idle === 0);
							state = PowerGating::PWRON;
						end
					join_any
					disable fork;
					x.state = state;
					ap.write(x);
				end

				PowerGating::ACKID:
				begin
					if(fab_if.fab_pmc_pg_rdy_nack_b === 0) begin
						state = PowerGating::REQ_1;
						x.state = state;
						ap.write(x);
					end
					else if(fab_if.fab_pmc_pg_rdy_ack_b === 0) begin
						state = PowerGating::PWRGT;
						x.state = state;
						ap.write(x);
					end
				end
				PowerGating::REQ_1:
				begin
					if(fab_if.pmc_fab_pg_rdy_req_b === 1) begin
						state = PowerGating::NACK1;
						x.state = state;
						ap.write(x);
					end
				end
				PowerGating::NACK1:
				begin
					if(fab_if.fab_pmc_pg_rdy_nack_b === 1) begin
						state = PowerGating::PWRON;
						x.state = state;
						ap.write(x);
					end					
				end
				PowerGating::PWRGT:
				begin
				   //Look for faric to get out of idle
				   if(fab_if.fab_pmc_idle === 0) begin
						state = PowerGating::IDEXI;
						x.state = state;
						ap.write(x);				
				   end
				   else if(fab_if.pmc_fab_pg_rdy_req_b === 1) begin
						state = PowerGating::ACKEX;
						x.state = state;
						ap.write(x);				
				   end
				   //Look for array of wakes
				   /* START collage comment out
				   else if(cfg.cfg_fab_pgcb[i].sip_pgcb_dependency.size() > 0) begin
					   foreach(cfg.cfg_fab_pgcb[i].sip_pgcb_dependency[agent_num]) begin
							if(vif.ip_pmc_pg_req_b[agent_num] === 1) begin
								state = PowerGating::IDEXI;
								x.state = state;
								ap.write(x);				
								continue;
							end
					   end
				   end
				    END collage comment out*/

				end
				
				PowerGating::IDEXI:
				begin
					if(fab_if.pmc_fab_pg_rdy_req_b === 1) begin
						state = PowerGating::ACKEX;
						x.state = state;
						ap.write(x);
					end
					
				end
				PowerGating::ACKEX:
				begin
					if(fab_if.fab_pmc_pg_rdy_ack_b === 1) begin
						state = PowerGating::PWRON;
						x.state = state;
						ap.write(x);
					end							
				end			
			endcase
		end
	endtask: fsm
endclass: CCAgentFabricFSM_Col


