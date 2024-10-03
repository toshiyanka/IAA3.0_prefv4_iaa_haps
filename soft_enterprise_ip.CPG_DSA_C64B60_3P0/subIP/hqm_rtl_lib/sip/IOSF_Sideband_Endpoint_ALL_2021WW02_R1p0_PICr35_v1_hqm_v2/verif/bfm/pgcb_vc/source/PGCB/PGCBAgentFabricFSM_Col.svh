/*THIS FILE IS GENERATED. DO NOT MODIFY*/
class PGCBAgentFabricFSM_Col extends PowerGatingBaseFSM;

	`ovm_component_utils(PGCBAgentFabricFSM_Col)

	function new(string name = "", ovm_component parent);
		super.new(name, parent);
	endfunction

   	virtual task run();
		driveResetSignaling();	
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
					if(fab_if.pmc_fab_pg_rdy_req_b === 0) begin
						state = PowerGating::ACKID;
						x.source = i;x.sourceName = name;
						x.state = state;
						ap.write(x);
					end					
				end

			    PowerGating::ACKID:
				begin
					if(fab_if.fab_pmc_pg_rdy_nack_b === 0) begin
						state = PowerGating::REQ_1;
						x.source = i;x.sourceName = name;
						x.state = state;
						ap.write(x);
					end
					else if(fab_if.fab_pmc_pg_rdy_ack_b === 0) begin
						state = PowerGating::PWRGT;
						x.source = i;x.sourceName = name;
						x.state = state;
						ap.write(x);
					end

				end

				PowerGating::REQ_1:
				begin
					if(fab_if.pmc_fab_pg_rdy_req_b === 1) begin
						state = PowerGating::NACK1;
						x.source = i;x.sourceName = name;
						x.state = state;
						ap.write(x);
					end
				end
				PowerGating::NACK1:
				begin
					if(fab_if.fab_pmc_pg_rdy_nack_b === 1) begin
						state = PowerGating::PWRON;
						x.source = i;x.sourceName = name;
						x.state = state;
						ap.write(x);
					end					
				end
				PowerGating::PWRGT:
				begin

				   if(fab_if.pmc_fab_pg_rdy_req_b === 1) begin
						state = PowerGating::ACKEX;
						x.source = i;x.sourceName = name;
						x.state = state;
						ap.write(x);

				   end

				end

				PowerGating::ACKEX:
				begin
					if(fab_if.fab_pmc_pg_rdy_ack_b === 1) begin
						state = PowerGating::PWRON;
						x.source = i;x.sourceName = name;
						x.state = state;
						ap.write(x);
					end							
				end			
			endcase
		end
	endtask: fsm
endclass: PGCBAgentFabricFSM_Col


