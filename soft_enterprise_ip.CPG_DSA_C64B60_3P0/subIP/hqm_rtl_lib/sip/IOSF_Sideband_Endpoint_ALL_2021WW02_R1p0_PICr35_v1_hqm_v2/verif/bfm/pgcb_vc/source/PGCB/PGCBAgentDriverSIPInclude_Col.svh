/*THIS FILE IS GENERATED. DO NOT MODIFY*/
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
		string source_name;
		int delay;
		bit val;
		begin
			source_name = req_arg.sourceName;
			delay = delay_arg;
			val = val_arg;
			delay_sip(delay, source_name);
			sip_vif[source_name].ip_pmc_pg_req_b = val;
			wait(sip_vif[source_name].pmc_ip_pg_ack_b === val);
			//Restore flow. Also wait for restore to go to 1
			if(val == 1) begin
				wait(sip_vif[source_name].pmc_ip_restore_b === 1);
			end
			delay = req_arg.delayComplete;
			delay_sip(delay, source_name);
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
		string source_name;
		int delay;
		begin
			source_name = req_arg.sourceName;
			delay = $urandom_range(0,20);
			delay_sip(delay, source_name);
			sip_vif[source_name].side_pok = value;
			delay = req_arg.delayComplete;
			delay_sip(delay, source_name);
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
		string source_name;
		int delay;
		begin
			source_name = req_arg.sourceName;
			delay = $urandom_range(0,20);
			delay_sip(delay, source_name);
			sip_vif[source_name].prim_pok = value;
			delay = req_arg.delayComplete;	
			delay_sip(delay, source_name);
			req_arg.setComplete();
		end
	endtask

