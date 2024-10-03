/*THIS FILE IS GENERATED. DO NOT MODIFY*/
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
class PGCBAgentDriver_Col extends PowerGatingBaseDriver;
	//=========================================================================
	// OVM Macros for public variables
	//=========================================================================
	`ovm_component_utils_begin(PGCBAgentDriver_Col)
	`ovm_component_utils_end

	//=========================================================================
	// PRIVATE VARIABLES
	//=========================================================================

	//=========================================================================
	// PUBLIC FUNCTIONS
	//=========================================================================
	/**************************************************************************
	*  @brief Constructor.
	**************************************************************************/
	function new(string name, ovm_component parent);
		super.new(name,parent);	
	endfunction: new

	//=========================================================================
	// PUBLIC TASKS
	//=========================================================================
   	virtual task run();
		if(cfg.phase == PowerGating::PHASE_1) begin	
			driveResetSignaling();	
			if (_vif.reset_b !== 1) begin
				@(posedge _vif.reset_b);
			end
			forever begin
				if(cfg.bfm_drives_fet_en_ack == 1) begin
				for(int k = 0 ; k < cfg.num_fet ; k ++) 
				begin
					fork 
						forkDriveFetAck(k);
					join_none
					#0;
		 		end
				end			
				fork
					driveReqs();
					waitForReset();
				join_any
				disable fork;
			end
		end
		else if(cfg.phase == PowerGating::PHASE_2) begin
			driveResetSignaling_Col();	
			if (reset_vif.reset_b !== 1) begin
				@(posedge reset_vif.reset_b);
			end
			forever begin
				//this will never join. So in this case this will be forever block.
				waitDriveResetSignaling_Col();					
				foreach(cfg.cfg_sip_pgcb_n[k]) 
				begin
					fork 
						forkDriveFetAck_Col(k);
					join_none
					#0;
		 		end
				fork
					driveReqs();
					waitForReset_Col();
				join_any
				disable fork;
			end
		
		end			
	endtask: run
	//=========================================================================
	// PROTECTED FUNCTIONS
	//=========================================================================
	protected virtual task driveResetSignaling();
		for(int i = 0; i < cfg.num_sip_pgcb; i++) 
		begin
			bit req, pok;
			_vif.inacc_pg[i] = 0;
			if(cfg.cfg_sip_pgcb[i].initial_state == PowerGating::POWER_GATED) begin
				req = 0;
				pok = 0;
			end
			else if(cfg.cfg_sip_pgcb[i].initial_state == PowerGating::POWER_UNGATED) begin
				req = 1;
				pok = 1;
			end
			else begin
				req = 1;
				pok = 0;
			end	
			_vif.ip_pmc_pg_req_b[i] = req;
			if(cfg.bfm_drives_pok) begin
				foreach(cfg.cfg_sip_pgcb[i].SB_index[n]) begin
					_vif.side_pok[cfg.cfg_sip_pgcb[i].SB_index[n]] = pok;
				end
				foreach(cfg.cfg_sip_pgcb[i].prim_index[n]) begin
					_vif.prim_pok[cfg.cfg_sip_pgcb[i].prim_index[n]] = pok;
				end
			end
		end
		//D3
		for(int i = 0; i < cfg.num_d3 ; i ++) begin
			_vif.ip_pmc_d3[i] = 1'b0;
		end
		//D0I3
		for(int i = 0; i < cfg.num_d0i3 ; i ++) begin
			_vif.ip_pmc_d0i3[i] = 1'b0;
		end				
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
				_vif.fet_en_ack_b[i] = 1;
			end
			else begin
				_vif.fet_en_ack_b[i] = 0;
			end			
		end
		for(int i =0 ; i < cfg.cfg_sip.size(); i ++) begin
			for(int j = 0; j < cfg.cfg_sip[i].AON_SB_index.size(); j ++) begin
				_vif.side_pok[cfg.cfg_sip[i].AON_SB_index[j]] = 0;
			end
			for(int j = 0; j < cfg.cfg_sip[i].AON_prim_index.size(); j ++) begin
				_vif.prim_pok[cfg.cfg_sip[i].AON_prim_index[j]] = 0;
			end			
		end

		for(int i = 0; i < cfg.num_fab_pgcb; i++) 
		begin
			_vif.fab_pmc_pg_rdy_nack_b[i] = 1;
			if(cfg.cfg_fab_pgcb[i].initial_state == PowerGating::POWER_GATED) begin
				_vif.fab_pmc_idle[i] = 1;
				_vif.fab_pmc_pg_rdy_ack_b[i] = 0;
			end
			else begin
				_vif.fab_pmc_idle[i] = 0;
				_vif.fab_pmc_pg_rdy_ack_b[i] = 1;
			end
		end	
	endtask : driveResetSignaling


	//col change	
	virtual task driveResetSignalingSIP(string name);
		bit req, pok;
		//TODO: should this be removed?
		//sip_vif[name].inacc_pg = 0;
		if(cfg.cfg_sip_pgcb_n[name].initial_state == PowerGating::POWER_GATED) begin
			req = 0;
		pok = 0;
		end
		else if(cfg.cfg_sip_pgcb_n[name].initial_state == PowerGating::POWER_UNGATED) begin
			req = 1;
			pok = 1;
		end
		else begin
			req = 1;
			pok = 0;
		end	
		sip_vif[name].ip_pmc_pg_req_b = req;
		//if(cfg.bfm_drives_pok) begin
			for(int i = 0; i < cfg.cfg_sip_pgcb_n[name].num_side; i++) begin
				sip_vif[name].side_pok[i] = pok;
			end
			for(int i = 0; i < cfg.cfg_sip_pgcb_n[name].num_prim; i++) begin
				sip_vif[name].prim_pok[i] = pok;
			end
		//end
		//D3
		for(int i = 0; i < cfg.cfg_sip_pgcb_n[name].num_d3 ; i++) begin
			sip_vif[name].ip_pmc_d3[i] = 1'b0;
		end
		//D0I3
		for(int i = 0; i < cfg.cfg_sip_pgcb_n[name].num_d0i3 ; i++) begin
			sip_vif[name].ip_pmc_d0i3[i] = 1'b0;
		end				
	endtask
	virtual task driveResetSignalingFab(string name);
		fab_vif[name].fab_pmc_pg_rdy_nack_b = 1;
		if(cfg.cfg_fab_pgcb_n[name].initial_state == PowerGating::POWER_GATED) begin
			fab_vif[name].fab_pmc_idle = 1;
			fab_vif[name].fab_pmc_pg_rdy_ack_b = 0;
		end
		else begin
			fab_vif[name].fab_pmc_idle = 0;
			fab_vif[name].fab_pmc_pg_rdy_ack_b = 1;
		end	
	endtask
	virtual task driveResetSignalingFet(string name);
		bit all_pg;
		all_pg = 1;
		foreach(cfg.cfg_fet_n_all[cfg.cfg_sip_pgcb_n[name].fet_name].pgcb_name[pgcb_num]) begin
			if(cfg.cfg_sip_pgcb_n_all[cfg.cfg_fet_n_all[cfg.cfg_sip_pgcb_n[name].fet_name].pgcb_name[pgcb_num]].initial_state != PowerGating::POWER_GATED) begin
				all_pg = 0;
				continue;
			end
		end
		if(all_pg == 1) begin
			sip_vif[name].fet_en_ack_b = 1;
		end
		else begin
			sip_vif[name].fet_en_ack_b = 0;
		end	
	endtask	
	//END col change
	
	`include "PGCBAgentDriverFetInclude.svh"
	`include "PGCBAgentDriverFabInclude_Col.svh"	
	`include "PGCBAgentDriverSIPInclude_Col.svh"
	/**************************************************************************
	*  Drive all commnads
	**************************************************************************/
   	protected virtual task driveRequestInterface();
		int delay;
		PGCBAgentResponseSeqItem rspReq;
		PGCBAgentSeqItem	masterReq;	 
		//col change
		if(req.sourceName == "" && cfg.phase == PowerGating::PHASE_2) begin
			if(req.cmd == PowerGating::FAB_IDLE 	||
			req.cmd == PowerGating::FAB_IDLE_EXIT 	||
			req.cmd == PowerGating::FAB_PG_ACK 		||
			req.cmd == PowerGating::FAB_PG_ACK_DSD 	||
			req.cmd == PowerGating::FAB_PG_NACK		||
			req.cmd == PowerGating::FAB_PG_NACK_DSD) begin
				req.sourceName = cfg.fab_name[req.source];
			end
			else if(req.cmd == PowerGating::SIDE_POK_ASD ||
				req.cmd == PowerGating::SIDE_POK_DSD) begin
				req.sourceName = cfg.sip_name_sb_ep[req.source];
			end
			else if(
				req.cmd == PowerGating::PRIM_POK_ASD ||
				req.cmd == PowerGating::PRIM_POK_DSD) begin
				req.sourceName = cfg.sip_name_prim_ep[req.source];
			end			
			else begin
				//it is a sip command
				req.sourceName = cfg.sip_name[req.source];				
			end
		end				
		//if((cfg.cfg_sip_pgcb_n.exists(req.sourceName) || cfg.cfg_fab_pgcb_n.exists(req.sourceName))) begin		
		//END col change
		if($cast(masterReq, req)) begin
			delay = masterReq.delay;
			//fabric
			if(req.cmd == PowerGating::FAB_IDLE)
			begin
			   forkDriveFabIdle(delay, req, 1);
			end
			else if(req.cmd == PowerGating::FAB_IDLE_EXIT)
			begin
			   forkDriveFabIdle(delay, req, 0);
			end	
			//SIP
			else if(req.cmd == PowerGating::SIP_UG_REQ)
			begin
			   forkDriveSIPReq(delay, req, 1);
			end
			//DONE ECN change  - replace this with PG_REQ
			else if(req.cmd == PowerGating::SIP_PG_REQ)
			begin
				//ALAMELU - COLLAGE
				if(_vif.pmc_ip_pg_wake[cfg.cfg_sip_pgcb[req.source].getPMCWakeIndex()] === 1) begin
					string str;
					$sformat(str, "%4s (index is %2d)", cfg.cfg_sip_pgcb[req.source].name, req.source);
					`ovm_error(get_full_name(), {"Test sent an accessible flow command to PGCB ", str, "when pmc_ip_pg_wake is asserted"});
				end
				else begin
			   		forkDriveSIPReq(delay, req, 0);
				end
			end			
			//else if(cfg.bfm_drives_pok) begin
				else if(req.cmd == PowerGating::SIP_INACC_PG) begin
					//deprecated.
				end						
				else if(req.cmd == PowerGating::SIDE_POK_ASD) begin
					forkDriveSidePOK(req, 1);
				end
				else if(req.cmd == PowerGating::SIDE_POK_DSD) begin
					forkDriveSidePOK(req, 0);
				end
				else if(req.cmd == PowerGating::PRIM_POK_ASD) begin
					forkDrivePrimPOK(req, 1);
				end
				else if(req.cmd == PowerGating::PRIM_POK_DSD) begin
					forkDrivePrimPOK(req, 0);
				end		
			//end
			/*else begin
				`ovm_error( get_name(), $psprintf("User sent a command %s to drive the pok but BFM_DRIVES_POk parameter in the PGCBAgentTI is set to 0. Please set the parameter to 1", req.cmd));
			end
			*/
		end
		else if ($cast(rspReq, req)) begin
			//Fabric
			if(req.cmd == PowerGating::FAB_PG_ACK)
			begin
			   forkDriveFabPGAck(rspReq);
			end
			if(req.cmd == PowerGating::FAB_PG_ACK_DSD)
			begin
			   forkDriveFabPGAckDe(rspReq.delay_fab_ug_ack, req);
			end
			if(req.cmd == PowerGating::FAB_PG_NACK)
			begin
			   forkDriveFabPGNack(rspReq.delay_fab_nack, req, 0);
			end
			if(req.cmd == PowerGating::FAB_PG_NACK_DSD)
			begin
			   forkDriveFabPGNack(delay, req, 1);
			end
			//SIP
			if(req.cmd == PowerGating::SIP_UG_REQ)
			begin
			   forkDriveSIPReq(rspReq.delay_ug_req, req, 1);
			end
			if(req.cmd == PowerGating::SIP_PG_REQ)
			begin
			   	forkDriveSIPReq(rspReq.delay_pg_req, req, 0);
			end	
		end
		else begin
			`ovm_error(get_full_name(), "Driver received unknown type of seq item");
		end
	//end
	endtask : driveRequestInterface
endclass : PGCBAgentDriver_Col
