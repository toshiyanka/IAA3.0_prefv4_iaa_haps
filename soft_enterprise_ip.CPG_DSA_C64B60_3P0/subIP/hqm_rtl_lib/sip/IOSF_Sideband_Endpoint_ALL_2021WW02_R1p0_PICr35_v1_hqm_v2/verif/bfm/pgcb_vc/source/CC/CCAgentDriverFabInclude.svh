	/**************************************************************************
	*  Drive Fab PG Hys
	**************************************************************************/
	virtual task forkDriveFabReqHys(PowerGatingSeqItem req);
	begin
		fork
			driveFabReqHys(req);
		join_none
	end
	endtask	
	virtual task driveFabReqHys(PowerGatingSeqItem req_arg);
		int source;
		begin
			source = req_arg.source;
			#(cfg.cfg_fab_pgcb[source].getHys());
			@(posedge _vif.clk);
			#1ps;
			//If still in idle, assert req
			if(_vif.fab_pmc_idle[source] === 1) begin
				//TODO: checka agent wake condiditons also here
				_vif.pmc_fab_pg_rdy_req_b[source] = 0;
			end		
			delay_fab(req_arg.delayComplete);
			req_arg.setComplete();
		end
	endtask
	/**************************************************************************
	*  Drive Fab PG
	**************************************************************************/
	virtual task forkDriveFabReq(int delay,PowerGatingSeqItem req);
	begin
		fork
			driveFabReq(delay, req);
		join_none
	end
	endtask
	virtual task driveFabReq(int delay_arg, PowerGatingSeqItem req_arg);
		int source;
		begin
			source = req_arg.source;
			delay_fab(delay_arg);
			_vif.pmc_fab_pg_rdy_req_b[source] = 0;
			//wait for complete
			fork
				begin
					wait(_vif.fab_pmc_pg_rdy_ack_b[source] === 0);
				end
				begin
					wait(_vif.fab_pmc_pg_rdy_nack_b[source] === 0);
				end
			join_any
			disable fork;
			delay_fab(req_arg.delayComplete);
			req_arg.setComplete();
		end
	endtask 
	/**************************************************************************
	*  Drive Fab UG
	**************************************************************************/
	virtual task forkDriveFabUGReq(int delay,PowerGatingSeqItem req);
	begin
		fork
			driveFabUGReq(delay, req);
		join_none
	end
	endtask
	virtual task driveFabUGReq(int delay_arg, PowerGatingSeqItem req_arg);
		int source;
		begin
			source = req_arg.source;
			delay_fab(delay_arg);			
			_vif.pmc_fab_pg_rdy_req_b[source] = 1;
			//wait for complete
			wait(_vif.fab_pmc_pg_rdy_ack_b[source] === 1);
			delay_fab(req_arg.delayComplete);			
			req_arg.setComplete();
		end
	endtask 
