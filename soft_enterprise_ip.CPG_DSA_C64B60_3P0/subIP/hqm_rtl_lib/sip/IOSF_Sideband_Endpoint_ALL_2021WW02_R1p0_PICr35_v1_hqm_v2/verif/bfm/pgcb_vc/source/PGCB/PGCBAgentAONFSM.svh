class PGCBAgentAONFSM extends ovm_component;

	virtual PowerGatingNoParamIF vif;
	int i;
	PowerGatingSIPState x;
	PowerGating::SIPState state;
	PowerGatingConfig cfg;
	

	//analysis port that sends to the responder
	ovm_analysis_port #(PowerGatingSIPState) ap;  

	`ovm_component_utils(PGCBAgentAONFSM)

	function new(string name = "", ovm_component parent);
		super.new(name, parent);
		x = new({name, "sipState"});
		ap = new({name, "sipFSM_ap"}, this);
		//state = PowerGating::SIP_IN_ACC;
	endfunction

	function setVIF(virtual PowerGatingNoParamIF vif_arg);
		vif = vif_arg;
	endfunction: setVIF

	function setCfg(PowerGatingConfig cfg_arg);
		cfg = cfg_arg;
	endfunction: setCfg


	function setSource(int source);
		i = source;
	endfunction: setSource 

   	virtual task run();
		driveResetSignaling();	
		if (vif.reset_b !== 1) begin
			@(posedge vif.reset_b);
		end
		forever begin
			fork
				//runDriver();
				fsm();
				waitForReset();
			join_any
			disable fork;
		end
	endtask: run
	virtual task waitForReset();
		@(negedge vif.reset_b);
		//state = PowerGating::SIP_IN_ACC;
		driveResetSignaling();		
	endtask: waitForReset

	protected virtual task driveResetSignaling();

		/*	if(cfg.cfg_sip_pgcb[i].initial_state == PowerGating::POWER_GATED) begin
				state = PowerGating::SIP_IN_ACC;
			end
			else begin
				state = PowerGating::SIP_ON;
			end	
			*/
			state = PowerGating::SIP_IN_ACC;
	endtask : driveResetSignaling



	task fsm();
		forever begin
			@(posedge vif.clk);
			wait(vif.reset_b === 1);
			x.source = i;

			case (state)
				PowerGating::SIP_IN_ACC:
				begin
					if(vif.pmc_ip_pg_wake[i] === 1) begin
						state = PowerGating::WAIT_FOR_SIP_AON_POK_ASD;	
						x.state = state;
						ap.write(x);
					end					
				end
				
				PowerGating::WAIT_FOR_SIP_AON_POK_ASD:
				begin
					foreach(cfg.cfg_pmc_wake_aon[i].AON_SB_index[n]) begin
						wait(vif.side_pok[cfg.cfg_pmc_wake_aon[i].AON_SB_index[n]] === 1);
					end
					foreach(cfg.cfg_pmc_wake_aon[i].AON_prim_index[n]) begin
						wait(vif.prim_pok[cfg.cfg_pmc_wake_aon[i].AON_prim_index[n]] === 1);						
					end

				//	if(vif.pmc_ip_pg_ack_b[i] === 1) begin
						state = PowerGating::SIP_ON;	
						x.state = state;
						ap.write(x);
				//	end							
				end	
				PowerGating::SIP_ON:
				begin
					foreach(cfg.cfg_pmc_wake_aon[i].AON_SB_index[n]) begin
						wait(vif.side_pok[cfg.cfg_pmc_wake_aon[i].AON_SB_index[n]] === 0);
					end
					foreach(cfg.cfg_pmc_wake_aon[i].AON_prim_index[n]) begin
						wait(vif.prim_pok[cfg.cfg_pmc_wake_aon[i].AON_prim_index[n]] === 0);						
					end
						state = PowerGating::SIP_IN_ACC;	
						x.state = state;
						ap.write(x);			
				end	
			endcase
		end
	endtask: fsm
endclass: PGCBAgentAONFSM


