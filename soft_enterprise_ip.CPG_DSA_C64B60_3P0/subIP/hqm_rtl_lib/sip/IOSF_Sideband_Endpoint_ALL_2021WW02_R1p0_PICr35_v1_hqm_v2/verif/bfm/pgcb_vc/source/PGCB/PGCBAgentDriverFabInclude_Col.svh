/*THIS FILE IS GENERATED. DO NOT MODIFY*/

	/**************************************************************************
	*  Drive Fab idle exit
	**************************************************************************/

	virtual task forkDriveFabIdle(int delay,PowerGatingSeqItem req, bit val);
	begin
		fork
			driveFabIdle(delay, req, val);
		join_none
	end
	endtask

	virtual task driveFabIdle(int delay_arg, PowerGatingSeqItem req_arg, bit val_arg);
		string source_name;
		int delay;
		bit val;
		begin
			source_name = req_arg.sourceName;
			delay = delay_arg;
			val = val_arg;
			delay_fab(delay, source_name);
			fab_vif[source_name].fab_pmc_idle = val;
			delay = req_arg.delayComplete;
			delay_fab(delay, source_name);				
			req_arg.setComplete();
		end
	endtask 
	/**************************************************************************
	*  Drive Fab PG ACK
	**************************************************************************/

	virtual task forkDriveFabPGAck(PGCBAgentResponseSeqItem req);
	begin
		fork
			DriveFabPGAck(req);
		join_none
	end
	endtask

	virtual task DriveFabPGAck(PGCBAgentResponseSeqItem req_arg);
		string source_name;
		int delay;
		bit assert_nack;
		begin
			source_name = req_arg.sourceName;
			delay = req_arg.delay_pg_req;
			assert_nack = req_arg.send_fab_nack;		
			fork 
				begin
					delay_fab(delay, source_name);
					//Assert the corresponding SIP pg_req
					if(!cfg.sip_belongs_to_fabric_n.exists(source_name)) begin
						`ovm_error(get_name(), $psprintf("There is no SIP interface associated with fabric interface number %3d. During configuration, please AddSIPPGCB and specify fabric_index", source_name))
					end
				end
				begin
					wait(fab_vif[source_name].fab_pmc_idle === 0);
					//Exit and then assert NACK after counting the delay
					assert_nack = 1;
				end
			join_any
			disable fork;
			if(assert_nack == 0) begin
					sip_vif[cfg.sip_belongs_to_fabric_n[source_name]].ip_pmc_pg_req_b = 0;
					//wait for ack 
					wait(sip_vif[cfg.sip_belongs_to_fabric_n[source_name]].pmc_ip_pg_ack_b === 0);
					
					//and then assert the fabric ack here
					delay = req_arg.delay_fab_pg_ack;
					delay_fab(delay, source_name);
					fab_vif[source_name].fab_pmc_pg_rdy_ack_b = 0;
			end
			else if(assert_nack) begin
					delay = req_arg.delay_fab_nack;
					delay_fab(delay, source_name);
					//Assert the NACK
					fab_vif[source_name].fab_pmc_pg_rdy_nack_b = 0;

			end
			delay = req_arg.delayComplete;
			delay_fab(delay, source_name);
	   
			req_arg.setComplete();

		end
	endtask 
	/**************************************************************************
	*  Drive Fab PG ACK deasserted
	**************************************************************************/

	virtual task forkDriveFabPGAckDe(int delay,PowerGatingSeqItem req);
	begin
		fork
			DriveFabPGAckDe(delay, req);
		join_none
	end
	endtask

	virtual task DriveFabPGAckDe(int delay_arg, PowerGatingSeqItem req_arg);
		string source_name;
		int delay;
		begin
			source_name = req_arg.sourceName;
			delay = delay_arg;
			delay_fab(delay, source_name);

			if(!cfg.sip_belongs_to_fabric_n.exists(source_name)) begin
				`ovm_error(get_name(), $psprintf("There is no SIP interface associated with fabric interface number %3d. During configuration, please AddSIPPGCB and specify fabric_index", source_name))
			end
			sip_vif[cfg.sip_belongs_to_fabric_n[source_name]].ip_pmc_pg_req_b = 1;
			//wait for ack 
			wait(sip_vif[cfg.sip_belongs_to_fabric_n[source_name]].pmc_ip_pg_ack_b === 1);
			delay_fab(delay, source_name);
			//and then assert the fabric ack here
			fab_vif[source_name].fab_pmc_pg_rdy_ack_b = 1;
			delay = req_arg.delayComplete;
			delay_fab(delay, source_name);	
			req_arg.setComplete();
		end
	endtask 
	/**************************************************************************
	*  Drive Fab PG NACK
	**************************************************************************/
	virtual task forkDriveFabPGNack(int delay,PowerGatingSeqItem req, bit val);
	begin
		fork
			DriveFabPGNack(delay, req, val);
		join_none
	end
	endtask

	virtual task DriveFabPGNack(int delay_arg, PowerGatingSeqItem req_arg, bit val_arg);
		string source_name;
		int delay;
		bit val;
		begin
			source_name = req_arg.sourceName;
			delay = delay_arg;
			val = val_arg;
			delay_fab(delay, source_name);
			fab_vif[source_name].fab_pmc_pg_rdy_nack_b = val;
			delay = req_arg.delayComplete;
			delay_fab(delay, source_name);
		
			req_arg.setComplete();
		end
	endtask 


