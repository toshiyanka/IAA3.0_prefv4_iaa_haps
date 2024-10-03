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
class PowerGatingMonitor_Col extends ovm_monitor;
	//=========================================================================
	// PUBLIC VARIABLES
	//=========================================================================
	ovm_analysis_port #(PowerGatingMonitorSeqItem) analysisPort;  //scoreboards can hook up to this.

	//=========================================================================
	// OVM Macros for public variables
	//=========================================================================
	//Below exports the is_active variable as a configurable variable
	`ovm_component_utils_begin(PowerGatingMonitor_Col)
	`ovm_component_utils_end

	//=========================================================================
	// PROTECTED VARIABLES
	//=========================================================================
	protected virtual PowerGatingResetIF reset_vif;        // ptr to the virtual interface
	
	protected PowerGatingConfig cfg;
	local string parent_type;
	local ovm_component comp;

	//col change
	protected virtual PowerGatingSIPIF 		sip_vif[string];  	
	//END col change
	//=========================================================================
	// PRIVATE VARIABLES
	//=========================================================================

	logic temp_fet_en_b[string];
	logic temp_fet_en_ack_b[string];

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
    function void setResetVIF (virtual PowerGatingResetIF vif_arg);
        reset_vif = vif_arg;
    endfunction: setResetVIF
	//col change
	/*function set_fet_intf(virtual PowerGatingFetIF fet[string]);
		fet_vif = fet;
	endfunction
	*/
	function set_sip_intf(virtual PowerGatingSIPIF sip[string]);
		sip_vif = sip;
	endfunction	
	//END col change
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
		if(cfg.cfg_side_ep_all.size() == 0) begin
			`chassis_power_gating_error(get_name(), "No sideband EP has been added during configuration of the power gating agent. User must use AddSBEP method to add a sideband endpoint and specify its source_id. User must also specify SB_array while using the method AddSIPPGCB.");
		end	
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
		wait(reset_vif.reset_b === 1'b0);
		resetSignals();
	endtask: waitForReset

	virtual function resetSignals();

		//for(int i = 0; i < cfg.num_fet ; i ++) begin
		foreach(cfg.cfg_sip_pgcb_n[n]) begin
			bit all_pg;
			string fet_name = cfg.cfg_sip_pgcb_n[n].fet_name;
			all_pg = 1;
			foreach(cfg.cfg_fet_n[fet_name].pgcb_name[pgcb_num]) begin
				string pgbc_name = cfg.cfg_fet_n[fet_name].pgcb_name[pgcb_num];
				if(cfg.cfg_sip_pgcb_n[pgbc_name].initial_state != PowerGating::POWER_GATED) begin
					all_pg = 0;
					continue;
				end
			end			
			if(all_pg == 1) begin
				temp_fet_en_b[fet_name] = 1'b1;
				temp_fet_en_ack_b[fet_name] = 1'b1;
			end
			else begin
				temp_fet_en_b[fet_name] = 1'b0;
				temp_fet_en_ack_b[fet_name] = 1'b0;				
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
			wait(reset_vif.reset_b === 1'b1)
			fork
				//FET
				fet_en_b_monitor();
				fet_en_ack_b_monitor();
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
			@(reset_vif.reset_b);
			if (reset_vif.reset_b === 0) begin
				x = new();
				x.sourceName = "--";
				x.evnt = PowerGating::RST_ASD;
				x.startTime = $time;
				analysisPort.write(x);
			end
			else if (reset_vif.reset_b === 1) begin
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
			@(posedge reset_vif.clk) 
			//for(int i = 0; i < cfg.num_fet; i ++) begin 
			foreach(cfg.cfg_sip_pgcb_n[i]) begin
				if (reset_vif.reset_b === 1 && sip_vif[i].fet_en_b === 0 && temp_fet_en_b[cfg.cfg_sip_pgcb_n[i].fet_name] === 1) begin 
					x = new(); 
					x.source = cfg.fet_index[i]; 
					x.startTime = $time; 
					x.typ = PowerGating::FET; 
					x.evnt = PowerGating::FET_ON; 
					x.sourceName = i; 
					analysisPort.write(x); 
				/*		//check for at least one PGCB requested power ungating. check that no pg_ack is 1. 
						if(cfg.disable_fet_ungate_check == 0 && parent_type == "PGCBAgent") begin 
							int cnt = 0; 
							//for(int j = 0; j < cfg.cfg_fet_n[i].pgcb_name.size(); j++) begin 
							foreach(cfg.cfg_fet_n[i].pgcb_name[j]) begin
								if(sip_vif[cfg.cfg_fet_n[i].pgcb_name[j]].ip_pmc_pg_req_b === 1) begin 
									cnt = cnt + 1; 
								end 
								if(sip_vif[cfg.cfg_fet_n[i].pgcb_name[j]].pmc_ip_pg_ack_b === 1) begin 
									`chassis_power_gating_error({get_name(), "_pgack_ungate_check"}, $psprintf("pmc_ip_pg_ack_b[%-d] deasserted even before the corresponding fet_en_b/fet_en_ack_b[%-d] was asserted (turned on). pmc_ip_pg_ack_b must deassert only after the fet is turned on", cfg.cfg_fet_n[i].pgcb_name[j], i)); 
								end 
							end 
							//error out if we did break out of the for loop 
							if(cnt == 0) begin 
								`chassis_power_gating_error({get_name(), "_fet_ungate_check"}, $psprintf("fet_en_b/fet_en_ack_b[%-d] asserted (turned on) when no PGD in that fet block requested power ungating. fet_en_b/fet_en_ack_b must assert only if at least one ip_pmc_pg_req_b in that Fet block is deasserted.", i)); 
							end 
						end 	
						*/
				end
				if (reset_vif.reset_b === 1 && sip_vif[i].fet_en_b === 1 && temp_fet_en_b[cfg.cfg_sip_pgcb_n[i].fet_name] === 0) begin 
					x = new(); 
					x.source = cfg.fet_index[i]; 
					x.startTime = $time; 
					x.typ = PowerGating::FET; 
					x.evnt = PowerGating::FET_OFF; 
					x.sourceName = i; 
				/*		//No state info here 
						//check for all PGCB in power gated state 
						if(cfg.disable_fet_gate_check == 0) begin 
							//for(int j = 0; j < cfg.cfg_fet_n[i].pgcb_name.size(); j++) begin 
							foreach(cfg.cfg_fet_n[i].pgcb_name[j]) begin
								if(sip_vif[cfg.cfg_fet_n[i].pgcb_name[j]].pmc_ip_pg_ack_b !== 0) begin 
									`chassis_power_gating_error({get_name(), "_fet_gate_check"}, $psprintf("fet_en_b/fet_en_ack_b[%-d] deasserted (turned off) when pmc_ip_pg_ack_b[%-d] (%s) was deasserted. fet_en_b/fet_en_ack_b must deassert only if all PGDs in that fet block has asserted ip_pmc_pg_ack_b.", i, j, cfg.cfg_sip_pgcb[j].getName())); 
								end 
							end 
						end 
						*/
					analysisPort.write(x); 
				end 
				temp_fet_en_b[cfg.cfg_sip_pgcb_n[i].fet_name] = sip_vif[i].fet_en_b; 
			end 
		end 
	endtask: fet_en_b_monitor 

	//`CHASSIS_PG_MONITOR(fet_en_ack_b, cfg.num_fet, reset_b, FET_OFF_ACK, FET_ON_ACK, FET, 0)
	task fet_en_ack_b_monitor(); 
		PowerGatingMonitorSeqItem x; 
		forever begin 
			@(posedge reset_vif.clk) 
			//for(int i = 0; i < cfg.num_fet; i ++) begin 
			foreach(cfg.cfg_sip_pgcb_n[i]) begin

				if (reset_vif.reset_b === 1 && sip_vif[i].fet_en_ack_b === 0 && temp_fet_en_ack_b[cfg.cfg_sip_pgcb_n[i].fet_name] === 1) begin 
					x = new(); 
					x.source = cfg.fet_index[i];  
					x.startTime = $time; 
					x.typ = PowerGating::FET; 
					x.evnt = PowerGating::FET_ON_ACK; 
					x.sourceName = i; 
					analysisPort.write(x); 				
				end
				if (reset_vif.reset_b === 1 && sip_vif[i].fet_en_ack_b === 1 && temp_fet_en_ack_b[cfg.cfg_sip_pgcb_n[i].fet_name] === 0) begin 
					x = new(); 
					x.source = cfg.fet_index[i]; 
					x.startTime = $time; 
					x.typ = PowerGating::FET; 
					x.evnt = PowerGating::FET_OFF_ACK; 
					x.sourceName = i; 				
					analysisPort.write(x); 
				end 
				temp_fet_en_ack_b[cfg.cfg_sip_pgcb_n[i].fet_name] = sip_vif[i].fet_en_ack_b; 
			end 
		end 
	endtask: fet_en_ack_b_monitor 

	//`include "PowerGatingMonitorInclude.svh"
endclass : PowerGatingMonitor_Col
