	
	/**************************************************************************
	*  Drive SIP PMC wake
	**************************************************************************/
	virtual task forkDriveSIPPMCWake(int delay,PowerGatingSeqItem req);
	begin
		fork
			driveSIPPMCWake(delay, req);
		join_none
	end
	endtask
	virtual task driveSIPPMCWake(int delay_arg, PowerGatingSeqItem req_arg);
		int source;
		bit[MAX_SIP-1:0] posedge_seen;
		bit proceed;		
		int delay;
		begin
			source = req_arg.source;
			proceed = 0;
			delay = delay_arg;
			delay_wake(delay);			
			_vif.pmc_ip_pg_wake[source] = 1;
			//wait for all the sips to wake and then return wait for complete.
			//this is for AON domains
			//wait(sip_vif[source_name].pmc_ip_pg_ack_b === 1);
			//START collage comment out 
			if(cfg.cfg_pmc_wake[source] != null) begin
			for(int i = 0; i < cfg.cfg_pmc_wake[source].pgcb_index.size(); i ++) begin
				wait(_vif.pmc_ip_pg_ack_b[cfg.cfg_pmc_wake[source].pgcb_index[i]] === 1);
			end			
			while(proceed != 1) begin
				@(posedge _vif.clk);		
				for(int i = 0; i < cfg.cfg_pmc_wake[source].pgcb_index.size(); i ++) begin
					//check if all signals transisiton to 1 
					if(_vif.pmc_ip_pg_ack_b[cfg.cfg_pmc_wake[source].pgcb_index[i]] === 1) begin
						posedge_seen[i] = 1;
					end
				end
				if($countones(posedge_seen) == cfg.cfg_pmc_wake[source].pgcb_index.size()) begin
					proceed = 1;
				end
			end			
			end
			//END collage comment out
			delay = req_arg.delayComplete;
			delay_wake(delay);
			req_arg.setComplete();
		end
	endtask 
	/**************************************************************************
	*  Drive SIP PMC wake
	**************************************************************************/
	virtual task forkDriveSIPPMCWakeAll(int delay,PowerGatingSeqItem req);
	begin
		fork
			driveSIPPMCWakeAll(delay, req);
		join_none
	end
	endtask
	virtual task driveSIPPMCWakeAll(int delay_arg, PowerGatingSeqItem req_arg);
		bit[MAX_SIP-1:0] posedge_seen;
		bit proceed;
		int delay;
		begin
			proceed = 0;
			delay = delay_arg;
			delay_fet(delay);
			for(int i = 0; i < cfg.num_pmc_wake; i ++) begin
				_vif.pmc_ip_pg_wake[i] = 1;
			end
			/*START collage uncomment out
			foreach(cfg.cfg_sip_pgcb_n[source_name]) begin
			fork
				begin
					wait(sip_vif[source_name].pmc_ip_pg_ack_b === 1);
				end
			join
			end
			END collage uncomment out*/
			//START collage comment out 
			while(proceed != 1) begin
				@(posedge _vif.clk);
				//Here i need to wait on clock and not on the ack because the ack can already be all 1
				for(int i = 0; i < cfg.num_sip_pgcb; i ++) begin
					//check if all signals transisiton to 1 
					if(_vif.pmc_ip_pg_ack_b[i] === 1) begin
						posedge_seen[i] = 1;
					end
				end
				if($countones(posedge_seen) == cfg.num_sip_pgcb) begin
					proceed = 1;
				end
			end
			//END collage comment out
			delay = req_arg.delayComplete;
			delay_fet(delay);
			req_arg.setComplete();
		end
	endtask 	
	/**************************************************************************
	*  Drive SIP PMC wake de
	**************************************************************************/
	virtual task forkDriveSIPPMCWakeDE(int delay, PowerGatingSeqItem req);
	begin
		fork
			driveSIPPMCWakeDE(delay, req);
		join_none
	end
	endtask

	virtual task driveSIPPMCWakeDE(int delay_arg, PowerGatingSeqItem req_arg);
		int source;
		int delay;
		begin
			source = req_arg.source;
			delay = delay_arg;
			delay_wake(delay);
			_vif.pmc_ip_pg_wake[source] = 0;
			delay = req_arg.delayComplete;
			delay_wake(delay);
			req_arg.setComplete();
		end
	endtask 
	/**************************************************************************
	*  Drive SIP PMC wake de
	**************************************************************************/
	virtual task forkDriveSIPPMCWakeDEAll(int delay, PowerGatingSeqItem req);
	begin
		fork
			driveSIPPMCWakeDEAll(delay, req);
		join_none
	end
	endtask

	virtual task driveSIPPMCWakeDEAll(int delay_arg, PowerGatingSeqItem req_arg);
		int source;
		int delay;
		begin
			source = req_arg.source;
			delay = delay_arg;
			delay_wake(delay);

			for(int i = 0; i < cfg.num_pmc_wake; i ++) begin
				_vif.pmc_ip_pg_wake[i] = 0;
			end
			delay = req_arg.delayComplete;
			delay_wake(delay);
			req_arg.setComplete();
		end
	endtask 
	/**************************************************************************
	*  Drive SIP UG ACK 
	**************************************************************************/
   	virtual task forkDriveSIPUGFlow(CCAgentResponseSeqItem req);
	begin
		fork
			DriveSIPUGFlow(req);
		join_none
	end
	endtask

	virtual task DriveSIPUGFlow(CCAgentResponseSeqItem req_arg);
		int source;
		int fet_index;
		int delay;
		begin
			source = req_arg.source;
			fet_index = cfg.cfg_sip_pgcb[source].fet_index;
			//Check if fet is already up
			if(_vif.fet_en_b[fet_index] !== 0) begin
				delay_fet(req_arg.delay_fet_en);			
				_vif.fet_en_b[fet_index] = 0;
				wait(_vif.fet_en_ack_b[fet_index] === 0);
			end
			//Restore
			if(_vif.restore_next_wake[source] == 1) begin
				delay = req_arg.delay_restore;
				delay_sip(delay);			
				_vif.pmc_ip_restore_b[source] = 0;
			end
			delay = req_arg.delay_ug_ack;
			delay_sip(delay);				
			_vif.pmc_ip_pg_ack_b[source] = 1;
			//Put semaphore
			cfg.arb_sem.put(1);
			//Set complete
			delay = req_arg.delayComplete;
			delay_sip(delay);
			req_arg.setComplete();			
		end
	endtask 
  
	/**************************************************************************
	*  Drive SIP PG ACK 
	**************************************************************************/
	virtual task forkDriveSIPPGFlow(CCAgentResponseSeqItem req);
	begin
		fork
			DriveSIPPGAck(req);
		join_none
	end
	endtask
	virtual task DriveSIPPGAck(CCAgentResponseSeqItem req_arg);
		int source;
		int fet_index;
		bit pull_fet;
		int delay;
		begin
			pull_fet = 1;
			source = req_arg.source;
			fet_index = cfg.cfg_sip_pgcb[source].fet_index;
			delay = req_arg.delay_pg_ack;
			delay_sip(delay);			
			_vif.pmc_ip_pg_ack_b[source] = 0;
			DriveFetOffIndex(req_arg.delay_fet_dis, fet_index);
			//Put semaphore
			cfg.arb_sem.put(1);
			//Set complete
			delay = req_arg.delayComplete;
			delay_sip(delay);
			req_arg.setComplete();
		end
	endtask

	//MACRO
	`define pg_driver_task(NAME, SIG_NAME) \
	virtual task fork``NAME(int delay,PowerGatingSeqItem req, bit value); \
	begin \
		fork \
			NAME(delay, req, value); \
		join_none \
	end \
	endtask \
	virtual task NAME(int delay_arg, PowerGatingSeqItem req_arg, bit value); \
		int source; \
		int delay; \
		begin \
			source = req_arg.source; \
			delay = delay_arg; \
			delay_sip(delay); \
			_vif.SIG_NAME[source] = value; \
			cfg.arb_sem.put(1); \
			delay = req_arg.delayComplete; \
			delay_sip(delay); \
			req_arg.setComplete(); \
		end \
	endtask 

	`define pg_dfx_driver_task(NAME, SIG_NAME) \
	virtual task fork``NAME(int delay,PowerGatingSeqItem req, bit value); \
	begin \
		fork \
			NAME(delay, req, value); \
		join_none \
	end \
	endtask \
	virtual task NAME(int delay_arg, PowerGatingSeqItem req_arg, bit value); \
		int source; \
		int delay; \
		begin \
			source = req_arg.source; \
			delay = delay_arg; \
			delay_dfx(delay); \
			_vif.SIG_NAME[source] = value; \
			delay = req_arg.delayComplete; \
			delay_dfx(delay); \
			req_arg.setComplete(); \
		end \
	endtask 


	`define pg_rst_driver_task(NAME, SIG_NAME, NUM) \
	virtual task fork``NAME(int delay,PowerGatingSeqItem req, bit value); \
	begin \
		fork \
			NAME(delay, req, value); \
		join_none \
		end \
	endtask \
	virtual task NAME(int delay_arg, PowerGatingSeqItem req_arg, bit value); \
		string source_name; \
		int delay; \
		begin \
			source_name = req_arg.sourceName; \
			delay = delay_arg; \
			delay_sip(delay); \
			for(int i = 0; i < cfg.cfg_sip_pgcb_n.``NUM; i++) begin \
				sip_vif[source_name].``SIG_NAME[i] = value; \
			end \
			delay = req_arg.delayComplete; \
			delay_sip(delay); \
			req_arg.setComplete(); \
		end \
	endtask \
	
	/**************************************************************************
	*  Drive SIP SW PG
	**************************************************************************/
   	`pg_driver_task(DriveSIPSWReq, pmc_ip_sw_pg_req_b)
	`pg_driver_task(DriveSIPRestore, pmc_ip_restore_b)
	`pg_dfx_driver_task(DriveBypass, fdfx_pgcb_ovr)
	`pg_dfx_driver_task(DriveOvr, fdfx_pgcb_ovr)

	`pg_driver_task(DriveSideRst, side_rst_b)
	`pg_driver_task(DrivePrimRst, prim_rst_b)

	`pg_driver_task(DriveVnnAck, pmc_ip_vnn_ack)
/*	virtual task forkDriveSIPSWReq(int delay,PowerGatingSeqItem req, bit value);
	begin
		fork
			driveSIPSWReq(delay, req, value);
		join_none
	end
	endtask

	virtual task driveSIPSWReq(int delay_arg, PowerGatingSeqItem req_arg, bit value);
		int source;
		begin
			source = req_arg.source;
			delay_sip(delay_arg);				
			_vif.pmc_ip_sw_pg_req_b[source] = value;
			delay_sip(req_arg.delayComplete);
			req_arg.setComplete();
		end
	endtask 
	*/
	/**************************************************************************
	*  Drive RESTORE 
	**************************************************************************/
/*	virtual task forkDriveSIPRestore(int delay, PowerGatingSeqItem req, bit val);
	begin
		fork
			DriveSIPRestore(delay, req, val);
		join_none
	end
	endtask

	virtual task DriveSIPRestore(int delay_arg, PowerGatingSeqItem req_arg, bit val_arg);
		int source;
		bit val;
		begin
			source = req_arg.source;
			val = val_arg;
			delay_sip(delay_arg);			
			_vif.pmc_ip_restore_b[source] = val;
			delay_sip(req_arg.delayComplete);		
			req_arg.setComplete();
		end
	endtask*/
	/**************************************************************************
	*  DFX 
	**************************************************************************/
	/*virtual task forkDriveBypass(int delay, PowerGatingSeqItem req, int val);
	begin
		fork
			driveBypass(delay, req, val);
		join_none
	end
	endtask

	virtual task driveBypass(int delay_arg, PowerGatingSeqItem req_arg, int val_arg);
		int source;
		int val;
		begin
			source = req_arg.source;
			val = val_arg;
			delay_dfx(delay_arg);			
			_vif.fdfx_pgcb_bypass[source] = val;
			req_arg.setComplete();
		end
	endtask 


	virtual task forkDriveOvr(int delay, PowerGatingSeqItem req, int val);
	begin
		fork
			driveOvr(delay, req, val);
		join_none
	end
	endtask

	virtual task driveOvr(int delay_arg, PowerGatingSeqItem req_arg, int val_arg);
		int source;
		int val;
		begin
			source = req_arg.source;
			val = val_arg;
			delay_dfx(delay_arg);			
			_vif.fdfx_pgcb_ovr[source] = val;
			req_arg.setComplete();
		end
	endtask	
*/	
	/**************************************************************************
	*  SIDE reset 
	**************************************************************************/
	/*virtual task forkDriveSideRst(int delay, PowerGatingSeqItem req, int val);
	begin
		fork
			driveSideRst(delay, req, val);
		join_none
	end
	endtask

	virtual task driveSideRst(int delay_arg, PowerGatingSeqItem req_arg, int val_arg);
		int source;
		int val;
		begin
			source = req_arg.source;
			val = val_arg;
			delay_sip(delay_arg);			
			_vif.side_rst_b[source] = val;
			req_arg.setComplete();
		end
	endtask 
*/
	/**************************************************************************
	*  PRIM reset 
	**************************************************************************/
/*	virtual task forkDrivePrimRst(int delay, PowerGatingSeqItem req, int val);
	begin
		fork
			drivePrimRst(delay, req, val);
		join_none
	end
	endtask

	virtual task drivePrimRst(int delay_arg, PowerGatingSeqItem req_arg, int val_arg);
		int source;
		int val;
		begin
			source = req_arg.source;
			val = val_arg;
			delay_sip(delay_arg);			
			_vif.prim_rst_b[source] = val;
			req_arg.setComplete();
		end
	endtask 
*/


