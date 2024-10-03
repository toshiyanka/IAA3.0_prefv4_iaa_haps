

	/**************************************************************************
	*  Drive Fab PFET dis
	**************************************************************************/	
   function bit fetCanBeTurnedOff(int fet_index);
	   bit pull_fet = 1;
					for(int i = 0; i < cfg.num_sip_pgcb ; i ++) begin
						//Check for other SIPs in the same FET block
						if(cfg.cfg_sip_pgcb[i].fet_index === fet_index) begin
							if(_vif.pmc_ip_pg_ack_b[i] !== 0) begin
								pull_fet = 0;
								continue;
							end
						end
					end
					return pull_fet;
	endfunction: fetCanBeTurnedOff
   
	virtual task forkDriveFETOff(int delay,PowerGatingSeqItem req);
	begin
		fork
			DriveFETOff(delay, req);
		join_none
	end
	endtask
	virtual task DriveFetOffIndex(int delay_arg, int fet_index);
		bit pull_fet;
		pull_fet = 1;
			if(fetONMode[fet_index] === 0)
			begin
				if(cfg.no_sip === 0) begin
					pull_fet = fetCanBeTurnedOff(fet_index);
				end		
				if(pull_fet === 1) begin
					//drive fet en
					delay_fet(delay_arg);
					//Check the states again and randomly decide to turn off the FET
					if(cfg.no_sip === 0) begin	
						pull_fet = fetCanBeTurnedOff(fet_index);
					end				
					if(pull_fet) begin
						_vif.fet_en_b[fet_index] = 1;
						//wiat for fet ack
						wait(_vif.fet_en_ack_b[fet_index] === 1);
					end
					else if($urandom_range(0,1)) begin
						_vif.fet_en_b[fet_index] = 1;
						//wiat for fet ack
						wait(_vif.fet_en_ack_b[fet_index] === 1);					
					end
				end
			end
	endtask
	virtual task DriveFETOff(int delay_arg, PowerGatingSeqItem req_arg);
		int fet_index;
		begin
			fet_index = req_arg.source;
			DriveFetOffIndex(delay_arg, fet_index);
			req_arg.setComplete();
		end
	endtask 	
