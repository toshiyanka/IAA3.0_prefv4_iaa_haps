class PowerGatingMainSIPFSM extends ovm_component;

	virtual PowerGatingNoParamIF vif;
	int i;
	PowerGatingMonitorSeqItem x;
	PowerGatingMonitorSeqItem in_seq;
	PowerGating::MonitorState state;
	PowerGatingConfig cfg;
	local PowerGatingSIPFSM sipFSM[];

	//analysis port that sends to the responder
	ovm_analysis_port #(PowerGatingMonitorSeqItem) ap;  

	//fifi to get change in state or change in pok value.
	analysis_fifo #(PowerGatingMonitorSeqItem) fifo;  
	`ovm_component_utils(PowerGatingMainSIPFSM)

	function new(string name = "", ovm_component parent);
		super.new(name, parent);
		x = new({name, "sipState"});
		ap = new({name, "sipFSM_ap"}, this);
		fifo = new({name, "sipFSM_fifo"}, this);
	endfunction

	function setVIF(virtual PowerGatingNoParamIF vif_arg);
		vif = vif_arg;
	endfunction: setVIF

	function setCfg(PowerGatingConfig cfg_arg);
		cfg = cfg_arg;
	endfunction: setCfg

	function PowerGating::MonitorState getCurrentState();
		return state;
	endfunction: getCurrentState	

	function setSource(int source);
		i = source;
	endfunction: setSource 

	function setSIPFSM(PowerGatingSIPFSM sipFSM_arg[$]);
		sipFSM = sipFSM_arg;
	endfunction: setSIPFSM

   	virtual task run();
		driveResetSignaling();
		if (vif.reset_b !== 1'b1) begin
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
			state = PowerGating::INACCESSIBLE_POFF;
			if(cfg.cfg_sip[i].pgcb_index.size() == 0) begin
				state = PowerGating::INACCESSIBLE_PON;
			end
			else begin
				if(cfg.cfg_sip_pgcb[cfg.cfg_sip[i].pgcb_index[0]].initial_state == PowerGating::POWER_UNGATED) begin
					state = PowerGating::ACCESSIBLE_PON;
				end
				else if(cfg.cfg_sip_pgcb[cfg.cfg_sip[i].pgcb_index[0]].initial_state == PowerGating::POWER_GATED) begin
					state = PowerGating::INACCESSIBLE_POFF;
				end
				else
					state = PowerGating::INACCESSIBLE_PON;
			end			
			//flush the fifo
			#0;
			fifo.flush();
	endtask : driveResetSignaling


	`define CHASSIS_PG_SEND_INFO(PGCB_STATE, POK_VAL, SIP_STATE) \
				x.startTime = $time; \
				x.source = i; \
				x.sourceName = cfg.cfg_sip[i].getName(); \
				x.typ = PowerGating::MSG; \
					foreach(cfg.cfg_sip[i].pgcb_index[n]) begin \
						if(sipFSM[cfg.cfg_sip[i].pgcb_index[n]].getCurrentState() != PowerGating::PGCB_STATE) begin \
							all = 1; \
							continue; \
						end \
					end \
					foreach(cfg.cfg_sip[i].AON_SB_index[n]) begin \
						if(vif.side_pok[cfg.cfg_sip[i].AON_SB_index[n]] !== POK_VAL) begin \
							all = 1; \
							continue; \
						end \
					end \
					foreach(cfg.cfg_sip[i].AON_prim_index[n]) begin \
						if(vif.prim_pok[cfg.cfg_sip[i].AON_prim_index[n]] !== POK_VAL) begin \
							all = 1; \
							continue; \
						end \
					end \
					if(all == 0) begin \
						state = PowerGating::SIP_STATE;	\
						x.state = state; \
						ap.write(x); \
					end \


	`define CHASSIS_PG_SEND_INFO_INACC(PGCB_STATE, POK_VAL, SIP_STATE) \
				x.startTime = $time; \
				x.source = i; \
				x.sourceName = cfg.cfg_sip[i].getName(); \
				x.typ = PowerGating::MSG; \
					foreach(cfg.cfg_sip[i].pgcb_index[n]) begin \
						if(sipFSM[cfg.cfg_sip[i].pgcb_index[n]].getCurrentState() != PowerGating::PGCB_STATE || \
							(sipFSM[cfg.cfg_sip[i].pgcb_index[n]].no_side_prim_ep == 1 && \
								sipFSM[cfg.cfg_sip[i].pgcb_index[n]].getCurrentState() != PowerGating::ACPOF)) begin \
							all = 1; \
							continue; \
						end \
					end \
					foreach(cfg.cfg_sip[i].AON_SB_index[n]) begin \
						if(vif.side_pok[cfg.cfg_sip[i].AON_SB_index[n]] !== POK_VAL) begin \
							all = 1; \
							continue; \
						end \
					end \
					foreach(cfg.cfg_sip[i].AON_prim_index[n]) begin \
						if(vif.side_pok[cfg.cfg_sip[i].AON_prim_index[n]] !== POK_VAL) begin \
							all = 1; \
							continue; \
						end \
					end \
					if(all == 0) begin \
						state = PowerGating::SIP_STATE;	\
						x.state = state; \
						ap.write(x); \
					end \

	task fsm();
		forever begin
			//@(posedge vif.clk);
			// do not wait on clock. get from fifo
			fifo.get(in_seq);	
			//TODO: check if cycle type is SIP and state changed or pok changed
			if(state != PowerGating::INACCESSIBLE_POFF && cfg.cfg_sip[i].pgcb_index.size() != 0) begin
				bit all;
				all = 0;				
				`CHASSIS_PG_SEND_INFO_INACC(INAPF, 0, INACCESSIBLE_POFF)				
			end
			if(state != PowerGating::ACCESSIBLE_PON) begin
				bit all;
				all = 0;						
				`CHASSIS_PG_SEND_INFO(PWRON, 1, ACCESSIBLE_PON)				
			end
			if(state != PowerGating::ACCESSIBLE_POFF  && cfg.cfg_sip[i].pgcb_index.size() != 0) begin
				bit all;
				all = 0;						
				`CHASSIS_PG_SEND_INFO(ACPOF, 1, ACCESSIBLE_POFF)		
			end
			if(state != PowerGating::INACCESSIBLE_PON) begin
				bit all;
				all = 0;						
				`CHASSIS_PG_SEND_INFO_INACC(INAPN, 0, INACCESSIBLE_PON)	
			end
		end
	endtask: fsm

endclass: PowerGatingMainSIPFSM


