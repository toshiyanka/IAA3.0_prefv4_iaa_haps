/*THIS FILE IS GENERATED. DO NOT MODIFY*/
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
		string source_name;
		begin
			source_name = req_arg.sourceName;
			#(cfg.cfg_fab_pgcb_n[source_name].getHys());
			@(posedge fab_vif[source_name].clk);
			#1ps;
			//If still in idle, assert req
			if(fab_vif[source_name].fab_pmc_idle === 1) begin
				//TODO: checka agent wake condiditons also here
				fab_vif[source_name].pmc_fab_pg_rdy_req_b = 0;
			end		
			delay_fab(req_arg.delayComplete, source_name);
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
		string source_name;
		begin
			source_name = req_arg.sourceName;
			delay_fab(delay_arg, source_name);
			fab_vif[source_name].pmc_fab_pg_rdy_req_b = 0;
			//wait for complete
			fork
				begin
					wait(fab_vif[source_name].fab_pmc_pg_rdy_ack_b === 0);
				end
				begin
					wait(fab_vif[source_name].fab_pmc_pg_rdy_nack_b === 0);
				end
			join_any
			disable fork;
			delay_fab(req_arg.delayComplete, source_name);
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
		string source_name;
		begin
			source_name = req_arg.sourceName;
			delay_fab(delay_arg, source_name);			
			fab_vif[source_name].pmc_fab_pg_rdy_req_b = 1;
			//wait for complete
			wait(fab_vif[source_name].fab_pmc_pg_rdy_ack_b === 1);
			delay_fab(req_arg.delayComplete, source_name);			
			req_arg.setComplete();
		end
	endtask 
