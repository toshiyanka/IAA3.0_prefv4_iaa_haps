/*
================================================================================
  Copyright (c) 2011 Intel Corporation, all rights reserved.

  THIS PROGRAM IS AN UNPUBLISHED WORK FULLY PROTECTED BY COPYRIGHT LAWS AND IS 
  CONSIDERED A TRADE SECRET BELONGING TO THE INTEL CORPORATION.
================================================================================

  Author          : 
  Email           : 
  Phone           : 
  Date            : 

================================================================================
  Description     : One line description of this class
  
Write your wordy description here.
================================================================================
*/
class PowerGatingMonitor extends ovm_monitor;
	//=========================================================================
	// PUBLIC VARIABLES
	//=========================================================================
	ovm_analysis_port #(PowerGatingMonitorSeqItem) analysisPort;  //scoreboards can hook up to this.

	//=========================================================================
	// OVM Macros for public variables
	//=========================================================================
	//Below exports the is_active variable as a configurable variable
	`ovm_component_utils_begin(PowerGatingMonitor)
	`ovm_component_utils_end

	//=========================================================================
	// PROTECTED VARIABLES
	//=========================================================================
	protected virtual PowerGatingNoParamIF _vif;        // ptr to the virtual interface
	
	protected PowerGatingConfig cfg;
	local string parent_type;
	local ovm_component comp;


	//=========================================================================
	// PRIVATE VARIABLES
	//=========================================================================
	logic[MAX_SIP:0] temp_pmc_ip_sw_pg_req_b;
	logic[MAX_SIP:0] temp_pmc_ip_pg_wake;
	logic[MAX_SIP:0] temp_prim_pok;
	logic[MAX_SIP:0] temp_side_pok;	
	logic[MAX_SIP:0] temp_prim_rst_b;
	logic[MAX_SIP:0] temp_side_rst_b;	

	logic[MAX_FET:0] temp_fet_en_b;
	logic[MAX_FET:0] temp_fet_en_ack_b;

	logic[MAX_SIP:0] temp_ip_pmc_d3;
	logic[MAX_SIP:0] temp_ip_pmc_d0i3;	

	//=========================================================================
	// PUBLIC FUNCTIONS
	//=========================================================================

	/**************************************************************************
	*  @brief Constructor.
	**************************************************************************/
	function new(string name, ovm_component parent);
		super.new(name,parent);
		analysisPort = new({name, "analysisPort"}, this);
		parent_type = parent.get_type_name();
	endfunction: new

    /**************************************************************************
    *  @brief : standard build process; only adds an analysis port
    **************************************************************************/
	virtual function void build();
		super.build();
	endfunction : build

    /**************************************************************************
    * Used to pass in virtual interface from Agent during connect
    **************************************************************************/
    function void setVIF (virtual PowerGatingNoParamIF vif_arg);
        _vif = vif_arg;
    endfunction: setVIF

    /**************************************************************************
    * Used to pass in config object from Agent during connect
    **************************************************************************/
    function void setCfg (PowerGatingConfig cfg_arg);
        cfg  = cfg_arg;
    endfunction: setCfg
	//=========================================================================
	// PUBLIC TASKS
	//=========================================================================

	/**************************************************************************
	*  @brief : description of what this method does
	*
	*  @param someArgument_arg : description of some argument
	**************************************************************************/
	virtual task run();
		//implement a check here to make sure that there is atlesat one sideband EP in the system
		/*if(cfg.cfg_side_ep.size() == 0) begin
			`chassis_power_gating_error(get_name(), "No sideband EP has been added during configuration of the power gating agent. User must use AddSBEP method to add a sideband endpoint and specify its source_id. User must also specify SB_array while using the method AddSIPPGCB.");
		end	
		*/
		fork 
			monitorReset();
		join_none
		resetSignals();
		forever begin : runForever
			fork 
				runResetAffected();
			join_any
			disable fork;
		end: runForever		
	endtask : run

	/**************************************************************************
	* Waits for reset to occur, flushes Xactions, then returns.
	**************************************************************************/
	local task waitForReset();
		wait(_vif.reset_b === 1'b0);
		resetSignals();
	endtask: waitForReset

	virtual function resetSignals();

	//COLLAGE COMMENT OUT
	//initialize pmc_wake
	for(int i = 0; i < cfg.num_pmc_wake; i++) 
	begin
		temp_pmc_ip_pg_wake[i] = 1'b0;
	end
	//initialize side and prim resets to 0
	for(int i = 0; i < cfg.num_sb_ep; i++) 
	begin
		temp_side_rst_b[i] = 1'b0;
	end
	for(int i = 0; i < cfg.num_prim_ep; i++) 
	begin
		temp_prim_rst_b[i] = 1'b0;
	end
	
	//initialize SIP
	if(cfg.no_sip === 0) begin
		for(int i = 0; i < cfg.num_sip_pgcb; i++) 
		begin
			temp_pmc_ip_sw_pg_req_b[i] = 1'b1;
			temp_pmc_ip_pg_wake[i] = 1'b0;
			//PGCB
			if(cfg.cfg_sip_pgcb[i].initial_state == PowerGating::POWER_GATED) begin
				foreach(cfg.cfg_sip_pgcb[i].SB_index[n]) begin
					temp_side_pok[cfg.cfg_sip_pgcb[i].SB_index[n]] = 1'b0;
				end
				foreach(cfg.cfg_sip_pgcb[i].prim_index[n]) begin
					temp_prim_pok[cfg.cfg_sip_pgcb[i].prim_index[n]] = 1'b0;
				end
			end		
			else if(cfg.cfg_sip_pgcb[i].initial_state == PowerGating::POWER_UNGATED) begin
				foreach(cfg.cfg_sip_pgcb[i].SB_index[n]) begin
					temp_side_pok[cfg.cfg_sip_pgcb[i].SB_index[n]] = 1'b1;
				end
				foreach(cfg.cfg_sip_pgcb[i].prim_index[n]) begin
					temp_prim_pok[cfg.cfg_sip_pgcb[i].prim_index[n]] = 1'b1;
				end
			end			
			else if(cfg.cfg_sip_pgcb[i].initial_state == PowerGating::POWER_UNGATED_POK0) begin
				foreach(cfg.cfg_sip_pgcb[i].SB_index[n]) begin
					temp_side_pok[cfg.cfg_sip_pgcb[i].SB_index[n]] = 1'b0;
				end
				foreach(cfg.cfg_sip_pgcb[i].prim_index[n]) begin
					temp_prim_pok[cfg.cfg_sip_pgcb[i].prim_index[n]] = 1'b0;
				end
			end		
			for(int i =0 ; i < cfg.cfg_sip.size(); i ++) begin
				for(int j = 0; j < cfg.cfg_sip[i].AON_SB_index.size(); j ++) begin
					temp_side_pok[cfg.cfg_sip[i].AON_SB_index[j]] = 1'b0;
				end
				for(int j = 0; j < cfg.cfg_sip[i].AON_prim_index.size(); j ++) begin
					temp_prim_pok[cfg.cfg_sip[i].AON_prim_index[j]] = 1'b0;
				end			
			end
		end
	end
		//D3
		for(int i = 0; i < cfg.num_d3 ; i ++) begin
			temp_ip_pmc_d3[i] = 1'b0;
		end
		//D0I3
		for(int i = 0; i < cfg.num_d0i3 ; i ++) begin
			temp_ip_pmc_d0i3[i] = 1'b0;
		end

		//END COLLAGE COMMENT OUT
		
		//INitializze FET
		//TODO: uncomment this
		for(int i = 0; i < cfg.num_fet ; i ++) begin
			bit all_pg;
			all_pg = 1;
			foreach(cfg.cfg_fet[i].pgcb_index[pgcb_num]) begin
				if(cfg.cfg_sip_pgcb[cfg.cfg_fet[i].pgcb_index[pgcb_num]].initial_state != PowerGating::POWER_GATED) begin
					all_pg = 0;
					continue;
				end
			end
			if(all_pg == 1) begin
				temp_fet_en_b[i] = 1'b1;
				temp_fet_en_ack_b[i] = 1'b1;
			end
			else begin
				temp_fet_en_b[i] = 1'b0;
				temp_fet_en_ack_b[i] = 1'b0;				
			end			
		end
		
	endfunction:resetSignals
	
	//=========================================================================
	// FUNCTIONS
	//=========================================================================

	/**************************************************************************
	* Monitors Fundamental Reset
	**************************************************************************/

	local task runResetAffected();
		forever begin: runResetAffected
			//wait to be out of reset
			wait(_vif.reset_b === 1'b1)
			fork
				//PMC signals
				pmc_ip_pg_wake_monitor();
				pmc_ip_sw_pg_req_b_monitor();
				//FET
				fet_en_b_monitor();
				fet_en_ack_b_monitor();
				//POK
				side_pok_monitor();
				prim_pok_monitor();
				//rst
				side_rst_b_monitor();
				prim_rst_b_monitor();				
				//D3 and D0I3
				ip_pmc_d3_monitor();
				ip_pmc_d0i3_monitor();
				waitForReset();
			join_any
			disable fork;
		end
	endtask: runResetAffected

	/**************************************************************************
	* Monitor reset assertion and deassertion 
	**************************************************************************/
   
   local task monitorReset();
		PowerGatingMonitorSeqItem x;
		// monitor forever asynchonously
		forever begin: monitorReset
			@(_vif.reset_b);
			if (_vif.reset_b === 0) begin
				x = new();
				x.sourceName = "--";
				x.evnt = PowerGating::RST_ASD;
				x.startTime = $time;
				analysisPort.write(x);
			end
			else if (_vif.reset_b === 1) begin
				x = new();
				x.sourceName = "--";			
				x.evnt = PowerGating::RST_DSD;
				x.startTime = $time;
				analysisPort.write(x);
			end
		end
	endtask: monitorReset
 
	//FET
	//`CHASSIS_PG_MONITOR(fet_en_b, cfg.num_fet, reset_b, FET_OFF, FET_ON, FET, 0)
	task fet_en_b_monitor(); 
		PowerGatingMonitorSeqItem x; 
		forever begin 
			@(posedge _vif.clk) 
			for(int i = 0; i < cfg.num_fet; i ++) begin 
				if (_vif.reset_b === 1 && _vif.fet_en_b[i] === 0 && temp_fet_en_b[i] === 1) begin 
					x = new(); 
					x.source = i; 
					x.startTime = $time; 
					x.typ = PowerGating::FET; 
					x.evnt = PowerGating::FET_ON; 
					x.sourceName = cfg.cfg_fet[i].getName(); 
					analysisPort.write(x); 
						//check for at least one PGCB requested power ungating. check that no pg_ack is 1. 
						if(cfg.disable_fet_ungate_check == 0 && parent_type == "PGCBAgent") begin 
							int cnt = 0; 
							for(int j = 0; j < cfg.cfg_fet[i].pgcb_index.size(); j++) begin 
								if(_vif.ip_pmc_pg_req_b[cfg.cfg_fet[i].pgcb_index[j]] === 1) begin 
									cnt = cnt + 1; 
								end 
								if(_vif.pmc_ip_pg_ack_b[cfg.cfg_fet[i].pgcb_index[j]] === 1) begin 
									`chassis_power_gating_error({get_name(), "_pgack_ungate_check"}, $psprintf("pmc_ip_pg_ack_b[%-d] deasserted even before the corresponding fet_en_b[%-d] was asserted (turned on). pmc_ip_pg_ack_b must deassert only after the fet is turned on", cfg.cfg_fet[i].pgcb_index[j], i)); 
								end 
							end 
							//error out if we did break out of the for loop 
							if(cnt == 0) begin 
								`chassis_power_gating_error({get_name(), "_fet_ungate_check"}, $psprintf("fet_en_b/fet_en_ack_b[%-d] asserted (turned on) when no PGD in that fet block requested power ungating. fet_en_b must assert only if at least one ip_pmc_pg_req_b in that Fet block is deasserted.", i)); 
							end 
						end 					
				end
				if (_vif.reset_b === 1 && _vif.fet_en_b[i] === 1 && temp_fet_en_b[i] === 0) begin 
					x = new(); 
					x.source = i; 
					x.startTime = $time; 
					x.typ = PowerGating::FET; 
					x.evnt = PowerGating::FET_OFF; 
					x.sourceName = cfg.cfg_fet[i].getName(); 
						//No state info here 
						//check for all PGCB in power gated state 
						if(cfg.disable_fet_gate_check == 0) begin 
							for(int j = 0; j < cfg.cfg_fet[i].pgcb_index.size(); j++) begin 
								if(_vif.pmc_ip_pg_ack_b[cfg.cfg_fet[i].pgcb_index[j]] !== 0) begin 
									`chassis_power_gating_error({get_name(), "_fet_gate_check"}, $psprintf("fet_en_b/fet_en_ack_b[%-d] deasserted (turned off) when pmc_ip_pg_ack_b[%-d] (%s) was deasserted. fet_en_b/fet_en_ack_b must deassert only if all PGDs in that fet block has asserted ip_pmc_pg_ack_b.", i, j, cfg.cfg_sip_pgcb[j].getName())); 
								end 
							end 
						end 					
					analysisPort.write(x); 
				end 
				temp_fet_en_b[i] = _vif.fet_en_b[i]; 
			end 
		end 
	endtask: fet_en_b_monitor 

	//`CHASSIS_PG_MONITOR(fet_en_ack_b, cfg.num_fet, reset_b, FET_OFF_ACK, FET_ON_ACK, FET, 0)
	task fet_en_ack_b_monitor(); 
		PowerGatingMonitorSeqItem x; 
		forever begin 
			@(posedge _vif.clk) 
			for(int i = 0; i < cfg.num_fet; i ++) begin 
				if (_vif.reset_b === 1 && _vif.fet_en_ack_b[i] === 0 && temp_fet_en_ack_b[i] === 1) begin 
					x = new(); 
					x.source = i; 
					x.startTime = $time; 
					x.typ = PowerGating::FET; 
					x.evnt = PowerGating::FET_ON_ACK; 
					x.sourceName = cfg.cfg_fet[i].getName(); 
					analysisPort.write(x); 				
						//check for at least one PGCB requested power ungating. check that no pg_ack is 1. 
						if(cfg.disable_fet_ungate_check == 0 && parent_type == "PGCBAgent") begin 
							int cnt = 0; 
							for(int j = 0; j < cfg.cfg_fet[i].pgcb_index.size(); j++) begin 
								if(_vif.ip_pmc_pg_req_b[cfg.cfg_fet[i].pgcb_index[j]] === 1) begin 
									cnt = cnt + 1; 
								end 
								if(_vif.pmc_ip_pg_ack_b[cfg.cfg_fet[i].pgcb_index[j]] === 1) begin 
									`chassis_power_gating_error({get_name(), "_pgack_ungate_check"}, $psprintf("pmc_ip_pg_ack_b[%-d] deasserted even before the corresponding fet_en_ack_b[%-d] was asserted (turned on). pmc_ip_pg_ack_b must deassert only after the fet is turned on", cfg.cfg_fet[i].pgcb_index[j], i)); 
								end 
							end 
							//error out if we did break out of the for loop 
							if(cnt == 0) begin 
								`chassis_power_gating_error({get_name(), "_fet_ungate_check"}, $psprintf("fet_en_b/fet_en_ack_b[%-d] asserted (turned on) when no PGD in that fet block requested power ungating. fet_en_ack_b must assert only if at least one ip_pmc_pg_req_b in that Fet block is deasserted.", i)); 
							end 
						end 	
				end
				if (_vif.reset_b === 1 && _vif.fet_en_ack_b[i] === 1 && temp_fet_en_ack_b[i] === 0) begin 
					x = new(); 
					x.source = i; 
					x.startTime = $time; 
					x.typ = PowerGating::FET; 
					x.evnt = PowerGating::FET_OFF_ACK; 
					x.sourceName = cfg.cfg_fet[i].getName(); 				
						//No state info here 
						//check for all PGCB in power gated state 
						if(cfg.disable_fet_gate_check == 0) begin 
							for(int j = 0; j < cfg.cfg_fet[i].pgcb_index.size(); j++) begin 
								if(_vif.pmc_ip_pg_ack_b[cfg.cfg_fet[i].pgcb_index[j]] !== 0) begin 
									`chassis_power_gating_error({get_name(), "_fet_gate_check"}, $psprintf("fet_en_ack_b[%-d] deasserted (turned off) when pmc_ip_pg_ack_b[%-d] (%s) was deasserted. fet_en_ack_b must deassert only if all PGDs in that fet block has asserted ip_pmc_pg_ack_b.", i, j, cfg.cfg_sip_pgcb[j].getName())); 
								end 
							end 
						end 	
					analysisPort.write(x); 
				end 
				temp_fet_en_ack_b[i] = _vif.fet_en_ack_b[i]; 
			end 
		end 
	endtask: fet_en_ack_b_monitor 

	`include "PowerGatingMonitorInclude.svh"
endclass : PowerGatingMonitor
