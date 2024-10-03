/*THIS FILE IS GENERATED. DO NOT MODIFY*/

class CCAgentDriver_Col extends PowerGatingBaseDriver;
	//=========================================================================
	// PUBLIC VARIABLES
	//=========================================================================
	//ovm_analysis_imp #(PowerGatingSeqItem, CCAgentDriver) analysis_export;
	analysis_fifo #(PowerGatingSeqItem) analysis_export;
	//=========================================================================
	// OVM Macros for public variables
	//=========================================================================
	`ovm_component_utils_begin(CCAgentDriver_Col)
	`ovm_component_utils_end
	//=========================================================================
	// PRIVATE VARIABLES
	//=========================================================================
	local bit fetONMode[int];	
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
	virtual function void build();
		super.build();
		analysis_export = new({get_full_name(), "analysis_export"}, this);
	endfunction
	
	virtual task run();
		if(cfg.phase == PowerGating::PHASE_1)
		begin
			driveResetSignaling();
			if (_vif.reset_b !== 1) begin
				@(posedge _vif.reset_b);
			end
			forever begin
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
	protected virtual task getReq();
			//Get next item of work. (Similar to CGDriver.getBlocking(cgx)
			if(cfg.phase == PowerGating::PHASE_1) 
				seq_item_port.get_next_item(req);
			else
				analysis_export.get(req); 

			addToQ(req);
	endtask: getReq
	protected virtual function markRequestComplete();
		//Notify anyone waiting on this transaction that the transaction is complete (similar to CGXaction.setComplete())
		if(cfg.phase == PowerGating::PHASE_1)
			seq_item_port.item_done();		
	endfunction: markRequestComplete	
	protected virtual task driveResetSignaling();
		//MOved this outside of the no_sip loop
		for(int i = 0; i < cfg.num_pmc_wake; i++) 
		begin
			_vif.pmc_ip_pg_wake[i] = 0;
		end
		//MOved this outside of the no_sip loop
		for(int i = 0; i < cfg.num_vnn_ack_req; i++) 
		begin
			_vif.pmc_ip_vnn_ack[i] = 1;
		end
		//initialize side and prim resets to 0
		for(int i = 0; i < cfg.num_sb_ep; i++) 
		begin
			_vif.side_rst_b[i] = 1'b0;
		end
		for(int i = 0; i < cfg.num_prim_ep; i++) 
		begin
			_vif.prim_rst_b[i] = 1'b0;
		end
		//initialize SIP
		if(cfg.no_sip === 0) begin
			for(int i = 0; i < cfg.num_sip_pgcb; i++) 
			begin
				_vif.pmc_ip_sw_pg_req_b[i] = 1;
				if(cfg.cfg_sip_pgcb[i].initial_restore_asserted == 1) 
					_vif.pmc_ip_restore_b[i] = 0;
				else
					_vif.pmc_ip_restore_b[i] = 1;

				//DFX signals
				_vif.fdfx_pgcb_bypass[i] = 1'b0;
				_vif.fdfx_pgcb_ovr[i] = 1'b0;

				if(cfg.cfg_sip_pgcb[i].initial_state == PowerGating::POWER_GATED) begin
					_vif.pmc_ip_pg_ack_b[i] = 0;
				end
				else begin
					_vif.pmc_ip_pg_ack_b[i] = 1;
				end
			end
		end
		//Initialize FET
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
				_vif.fet_en_b[i] = 1;
			end
			else begin
				_vif.fet_en_b[i] = 0;
			end			
		end
		//Initialize Fabric
		if(cfg.no_fab === 0) begin
			for(int i = 0; i < cfg.num_fab_pgcb; i++) 
			begin
				if(cfg.cfg_fab_pgcb[i].initial_state == PowerGating::POWER_GATED) begin
					_vif.pmc_fab_pg_rdy_req_b[i] = 0;
				end
				else begin
					_vif.pmc_fab_pg_rdy_req_b[i] = 1;
				end
			end
		end
	endtask : driveResetSignaling

	//col change
	protected virtual task driveResetSignalingSIP(string name);
		sip_vif[name].pmc_ip_pg_wake = 0;
		sip_vif[name].pmc_ip_vnn_ack = 0;
		sip_vif[name].pmc_ip_sw_pg_req_b = 1;
		if(cfg.cfg_sip_pgcb_n[name].initial_restore_asserted == 1) 
			sip_vif[name].pmc_ip_restore_b = 0;
		else
			sip_vif[name].pmc_ip_restore_b = 1;
		//DFX signals
		sip_vif[name].fdfx_pgcb_bypass = 1'b0;
		sip_vif[name].fdfx_pgcb_ovr = 1'b0;
		if(cfg.cfg_sip_pgcb_n[name].initial_state == PowerGating::POWER_GATED) begin
			sip_vif[name].pmc_ip_pg_ack_b = 0;
			//sip_vif[name].fet_en_b = 1;
		end
 		else begin
			sip_vif[name].pmc_ip_pg_ack_b = 1;
			//sip_vif[name].fet_en_b = 0;
		end
		//initialize side and prim resets to 0
		for(int i = 0; i < cfg.cfg_sip_pgcb_n[name].num_side; i++) 
		begin
			sip_vif[name].side_rst_b[i] = 1'b0;
		end
		for(int i = 0; i < cfg.cfg_sip_pgcb_n[name].num_prim; i++) 
		begin
			sip_vif[name].prim_rst_b[i] = 1'b0;
		end		
	endtask : driveResetSignalingSIP
	protected virtual task driveResetSignalingFab(string name);
		if(cfg.cfg_fab_pgcb_n[name].initial_state == PowerGating::POWER_GATED) begin
			fab_vif[name].pmc_fab_pg_rdy_req_b = 0;
		end
		else begin
			fab_vif[name].pmc_fab_pg_rdy_req_b = 1;
		end
	endtask : driveResetSignalingFab
	protected virtual task driveResetSignalingFet(string name);
			bit all_pg;
			all_pg = 1;
			foreach(cfg.cfg_fet_n_all[cfg.cfg_sip_pgcb_n[name].fet_name].pgcb_name[pgcb_num]) begin
				if(cfg.cfg_sip_pgcb_n_all[cfg.cfg_fet_n_all[cfg.cfg_sip_pgcb_n[name].fet_name].pgcb_name[pgcb_num]].initial_state != PowerGating::POWER_GATED) begin
					all_pg = 0;
					continue;
				end
			end
			if(all_pg == 1) begin
				sip_vif[name].fet_en_b = 1;
			end
			else begin
				sip_vif[name].fet_en_b = 0;
			end	
	endtask : driveResetSignalingFet
	//END col change

	`include "CCAgentDriverFetInclude_Col.svh";
	`include "CCAgentDriverSIPInclude_Col.svh";
	`include "CCAgentDriverFabInclude_Col.svh";

	/**************************************************************************
	*  Drive all commnads
	**************************************************************************/
   	protected virtual task driveRequestInterface();
		int delay;
		CCAgentResponseSeqItem rspReq;
		CCAgentSeqItem	masterReq;	 
		//col change
		if(req.sourceName == "" && cfg.phase == PowerGating::PHASE_2) begin
			//user only specified the source and not sourceName
			if(req.cmd == PowerGating::FAB_PG_REQ || 
				req.cmd == PowerGating::FAB_UG_REQ ||
				req.cmd == PowerGating::FAB_PG_REQ_HYS || 
				req.cmd == PowerGating::FAB_UG_REQ)
			begin
				if(fab_vif[cfg.fab_name[req.source]].reset_b === 1)
					req.sourceName = cfg.fab_name[req.source];
				else begin
					//TODO: add this to the SIP interface also??
					`ovm_error("cc_driver", $psprintf("Fabric interface %s is in reset. But user sent command while interface is in reset", req.sourceName));
				end
			end
			else if(req.cmd == PowerGating::SET_FET_ON_MODE ||
				req.cmd == PowerGating::RESET_FET_ON_MODE) begin
				//no backward compatibility here
			end
			else if(req.cmd == PowerGating::SIDE_RST_ASD ||
				req.cmd == PowerGating::SIDE_RST_DSD) begin
				req.sourceName = cfg.sip_name_sb_ep[req.source];
			end
			else if(
				req.cmd == PowerGating::PRIM_RST_ASD ||
				req.cmd == PowerGating::PRIM_RST_DSD) begin
				req.sourceName = cfg.sip_name_prim_ep[req.source];
			end
			else if(req.cmd == PowerGating::VNN_ACK_ASD ||
				req.cmd == PowerGating::VNN_ACK_DSD) begin
				req.sourceName = cfg.sip_name_sb_ep[req.source];
			end

			else begin
				//it is a sip command
				req.sourceName = cfg.sip_name[req.source];
			end
		end	
		if(cfg.phase == PowerGating::PHASE_1 || (cfg.cfg_sip_pgcb_n.exists(req.sourceName) || cfg.cfg_fab_pgcb_n.exists(req.sourceName))) begin
	
		//END col change
		if($cast(masterReq, req)) begin
			delay = masterReq.delay;
			//Fabric
			//Master
			if(req.cmd == PowerGating::FAB_PG_REQ)
			begin		   	
				forkDriveFabReq(delay, req);
			end
			else if(req.cmd == PowerGating::FAB_UG_REQ)
			begin
			   forkDriveFabUGReq(delay, req);
			end
			//SIP
			//Master
			else if(req.cmd == PowerGating::SW_PG_REQ)
			begin
			   forkDriveSIPSWReq(delay, req, 0);
			end
			else if(req.cmd == PowerGating::DEASSERT_SW_PG_REQ)
			begin
			   forkDriveSIPSWReq(delay, req, 1);
			end
			else if(req.cmd == PowerGating::PMC_SIP_WAKE)
			begin
			   forkDriveSIPPMCWake(delay, req);
			end
			else if(req.cmd == PowerGating::DEASSERT_PMC_SIP_WAKE)
			begin
			   forkDriveSIPPMCWakeDE(delay, req);
			end
			else if(req.cmd == PowerGating::PMC_SIP_WAKE_ALL)
			begin
				forkDriveSIPPMCWakeAll(delay, req);
			end
			else if(req.cmd == PowerGating::DEASSERT_PMC_SIP_WAKE_ALL)
			begin
				forkDriveSIPPMCWakeDEAll(delay, req);
			end		
			//FET
			else if(req.cmd == PowerGating::SET_FET_ON_MODE)
			begin
				fetONMode[req.source] = 1;
			   	cfg.fetONMode[req.source] = 1;
			   	cfg.fetONMode_n[req.sourceName] = 1;
				req.setComplete();
			end
			else if(req.cmd == PowerGating::RESET_FET_ON_MODE)
			begin
			   	fetONMode[req.source] = 0;
				cfg.fetONMode[req.source] = 0;
			   	cfg.fetONMode_n[req.sourceName] = 0;
				req.setComplete();
			end
			//restore flow
			else if(req.cmd == PowerGating::SIP_RESTORE) begin
				forkDriveSIPRestore(delay, req, 0);
			end					
			else if(req.cmd == PowerGating::SIP_RESTORE_NEXT_WAKE) 
			begin
				_vif.restore_next_wake[req.source] = 1;
				req.setComplete();
			end			
			else if(req.cmd == PowerGating::DEASSERT_SIP_RESTORE) 
			begin
				forkDriveSIPRestore(delay, req, 1);
			end					
			//DFX
			else if(req.cmd == PowerGating::FDFX_BYPASS_DSD) 
			begin
				forkDriveBypass(delay, req, 0);				
			end			
			else if(req.cmd == PowerGating::FDFX_BYPASS_ASD) 
			begin
				forkDriveBypass(delay, req, 1);
			end		
			else if(req.cmd == PowerGating::FDFX_OVR_DSD) 
			begin
				forkDriveOvr(delay, req, 0);
			end			
			else if(req.cmd == PowerGating::FDFX_OVR_ASD) 
			begin
				forkDriveOvr(delay, req, 1);
			end					
			//side and prim resets
			else if(req.cmd == PowerGating::VNN_ACK_DSD) 
			begin
				forkDriveVnnAck(delay, req, 1);
			end			
			else if(req.cmd == PowerGating::VNN_ACK_ASD) 
			begin
				forkDriveVnnAck(delay, req, 0);
			end		
			//side and prim resets
			else if(req.cmd == PowerGating::SIDE_RST_DSD) 
			begin
				forkDriveSideRst(delay, req, 1);
			end			
			else if(req.cmd == PowerGating::SIDE_RST_ASD) 
			begin
				forkDriveSideRst(delay, req, 0);
			end		
			else if(req.cmd == PowerGating::PRIM_RST_DSD) 
			begin
				forkDrivePrimRst(delay, req, 1);
			end			
			else if(req.cmd == PowerGating::PRIM_RST_ASD) 
			begin
				forkDrivePrimRst(delay, req, 0);
			end					
		end
		else if ($cast(rspReq, req)) begin
			//Response
			if(rspReq.cmd == PowerGating::FAB_PG_REQ_HYS)
			begin
			   forkDriveFabReqHys(rspReq);
			end			
			else if(rspReq.cmd == PowerGating::FAB_UG_REQ)
			begin
			   forkDriveFabUGReq(rspReq.delay_fab_ug_req, rspReq);
			end
			else if(rspReq.cmd == PowerGating::SIP_PG_FLOW)
			begin
			   forkDriveSIPPGFlow(rspReq);
			end	
			else if(rspReq.cmd == PowerGating::SIP_UG_FLOW)
			begin
			   forkDriveSIPUGFlow(rspReq);
			end	
			else if(req.cmd == PowerGating::RESET_FET_ON_MODE)
			begin
			   	forkDriveFETOff(rspReq.delay_fet_dis, req);
			end
			else if(req.cmd == PowerGating::SIP_RESTORE) begin
				forkDriveSIPRestore(rspReq.delay_restore, req, 0);
			end					
		end
		else begin
			`ovm_error(get_full_name(), "Driver received unknown type of seq item");
		end
		end
	endtask : driveRequestInterface

endclass : CCAgentDriver_Col

