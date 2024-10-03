	/**************************************************************************
	*  Drive SIP req
	**************************************************************************/
	virtual task forkDriveSIPReq(int delay,PowerGatingSeqItem req, bit val);
	begin
		fork
			DriveSIPReq(delay, req, val);
		join_none
	end
	endtask
	virtual task DriveSIPReq(int delay_arg, PowerGatingSeqItem req_arg, bit val_arg);
		int source;
		int delay;
		bit val;
		begin
			source = req_arg.source;
			delay = delay_arg;
			val = val_arg;
			delay_sip(delay);
			_vif.ip_pmc_pg_req_b[source] = val;
			wait(_vif.pmc_ip_pg_ack_b[source] === val);
			//Restore flow. Also wait for restore to go to 1
			if(val == 1) begin
				wait(_vif.pmc_ip_restore_b[source] === 1);
			end
			delay = req_arg.delayComplete;
			delay_sip(delay);
			req_arg.setComplete();
		end
	endtask
	/**************************************************************************
	*  Drive 	//POK
	**************************************************************************/
	virtual task forkDriveSidePOK(PowerGatingSeqItem req, bit value);
	begin
		fork
			DriveSidePOK(req, value);
		join_none
	end
	endtask
	virtual task DriveSidePOK(PowerGatingSeqItem req_arg, bit value);
		int source;
		int delay;
		begin
			source = req_arg.source;
			delay = $urandom_range(0,20);
			delay_sip(delay);
			_vif.side_pok[source]  = value;
			delay = req_arg.delayComplete;
			delay_sip(delay);
			req_arg.setComplete();
		end
	endtask
	virtual task forkDrivePrimPOK(PowerGatingSeqItem req, bit value);
	begin
		fork
			DrivePrimPOK(req, value);
		join_none
	end
	endtask
	virtual task DrivePrimPOK(PowerGatingSeqItem req_arg, bit value);
		int source;
		int delay;
		begin
			source = req_arg.source;
			delay = $urandom_range(0,20);
			delay_sip(delay);
			_vif.prim_pok[source]  = value;
			delay = req_arg.delayComplete;	
			delay_sip(delay);
			req_arg.setComplete();
		end
	endtask
	/**************************************************************************
	*  Drive 	//VNNREQ
	**************************************************************************/
	virtual task forkDriveVnnReq(PowerGatingSeqItem req, bit value);
	begin
		fork
			DriveVnnReq(req, value);
		join_none
	end
	endtask
	virtual task DriveVnnReq(PowerGatingSeqItem req_arg, bit value);
		int source;
		int delay;
		begin
			source = req_arg.source;
			delay = $urandom_range(0,20);
			delay_sip(delay);
			_vif.ip_pmc_vnn_req[source]  = value;
			delay = req_arg.delayComplete;
			delay_sip(delay);
			req_arg.setComplete();
		end
	endtask
