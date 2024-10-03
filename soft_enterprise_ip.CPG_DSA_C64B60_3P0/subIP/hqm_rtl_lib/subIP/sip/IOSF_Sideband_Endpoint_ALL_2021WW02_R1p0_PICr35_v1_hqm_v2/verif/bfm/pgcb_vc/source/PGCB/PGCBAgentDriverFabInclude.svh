
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
		int source;
		int delay;
		bit val;
		begin
			source = req_arg.source;
			delay = delay_arg;
			val = val_arg;
			delay_fab(delay);
			_vif.fab_pmc_idle[source] = val;
			delay = req_arg.delayComplete;
			delay_fab(delay);				
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
		int source;
		int delay;
		bit assert_nack;
		begin
			source = req_arg.source;
			delay = req_arg.delay_pg_req;
			assert_nack = req_arg.send_fab_nack;		
			fork 
				begin
					delay_fab(delay);
					//Assert the corresponding SIP pg_req
					if(!cfg.sip_belongs_to_fabric.exists(source)) begin
						`ovm_error(get_name(), $psprintf("There is no SIP interface associated with fabric interface number %3d. During configuration, please AddSIPPGCB and specify fabric_index", source))
					end
				end
				begin
					wait(_vif.fab_pmc_idle[source] === 0);
					//Exit and then assert NACK after counting the delay
					assert_nack = 1;
				end
			join_any
			disable fork;
			if(assert_nack == 0) begin
					_vif.ip_pmc_pg_req_b[cfg.sip_belongs_to_fabric[source]] = 0;
					//wait for ack 
					wait(_vif.pmc_ip_pg_ack_b[cfg.sip_belongs_to_fabric[source]] === 0);
					
					//and then assert the fabric ack here
					delay = req_arg.delay_fab_pg_ack;
					delay_fab(delay);
					_vif.fab_pmc_pg_rdy_ack_b[source] = 0;
			end
			else if(assert_nack) begin
					delay = req_arg.delay_fab_nack;
					delay_fab(delay);
					//Assert the NACK
					_vif.fab_pmc_pg_rdy_nack_b[source] = 0;

			end
			delay = req_arg.delayComplete;
			delay_fab(delay);
	   
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
		int source;
		int delay;
		begin
			source = req_arg.source;
			delay = delay_arg;
			delay_fab(delay);

			if(!cfg.sip_belongs_to_fabric.exists(source)) begin
				`ovm_error(get_name(), $psprintf("There is no SIP interface associated with fabric interface number %3d. During configuration, please AddSIPPGCB and specify fabric_index", source))
			end
			_vif.ip_pmc_pg_req_b[cfg.sip_belongs_to_fabric[source]] = 1;
			//wait for ack 
			wait(_vif.pmc_ip_pg_ack_b[cfg.sip_belongs_to_fabric[source]] === 1);
			delay_fab(delay);
			//and then assert the fabric ack here
			_vif.fab_pmc_pg_rdy_ack_b[source] = 1;
			delay = req_arg.delayComplete;
			delay_fab(delay);	
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
		int source;
		int delay;
		bit val;
		begin
			source = req_arg.source;
			delay = delay_arg;
			val = val_arg;
			delay_fab(delay);
			_vif.fab_pmc_pg_rdy_nack_b[source] = val;
			delay = req_arg.delayComplete;
			delay_fab(delay);
		
			req_arg.setComplete();
		end
	endtask 


