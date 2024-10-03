class PGCBAgentFabricFSM extends PowerGatingBaseFSM;

	`ovm_component_utils(PGCBAgentFabricFSM)

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

			if(cfg.cfg_fab_pgcb[i].initial_state == PowerGating::POWER_GATED) begin
				state = PowerGating::PWRGT;
			end
			else begin
				state = PowerGating::PWRON;
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
						x.source = i;
						x.state = state;
						ap.write(x);
					end					
				end

			    PowerGating::ACKID:
				begin
					if(vif.fab_pmc_pg_rdy_nack_b[i] === 0) begin
						state = PowerGating::REQ_1;
						x.source = i;
						x.state = state;
						ap.write(x);
					end
					else if(vif.fab_pmc_pg_rdy_ack_b[i] === 0) begin
						state = PowerGating::PWRGT;
						x.source = i;
						x.state = state;
						ap.write(x);
					end

				end

				PowerGating::REQ_1:
				begin
					if(vif.pmc_fab_pg_rdy_req_b[i] === 1) begin
						state = PowerGating::NACK1;
						x.source = i;
						x.state = state;
						ap.write(x);
					end
				end
				PowerGating::NACK1:
				begin
					if(vif.fab_pmc_pg_rdy_nack_b[i] === 1) begin
						state = PowerGating::PWRON;
						x.source = i;
						x.state = state;
						ap.write(x);
					end					
				end
				PowerGating::PWRGT:
				begin

				   if(vif.pmc_fab_pg_rdy_req_b[i] === 1) begin
						state = PowerGating::ACKEX;
						x.source = i;
						x.state = state;
						ap.write(x);

				   end

				end

				PowerGating::ACKEX:
				begin
					if(vif.fab_pmc_pg_rdy_ack_b[i] === 1) begin
						state = PowerGating::PWRON;
						x.source = i;
						x.state = state;
						ap.write(x);
					end							
				end			
			endcase
		end
	endtask: fsm
endclass: PGCBAgentFabricFSM


