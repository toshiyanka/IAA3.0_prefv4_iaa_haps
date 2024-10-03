/*THIS FILE IS GENERATED. DO NOT MODIFY*/


	/**************************************************************************
	*  Drive Fab PFET dis
	**************************************************************************/	
   function bit fetCanBeTurnedOff(string fet_name);
	   bit pull_fet = 1;
					foreach(cfg.cfg_sip_pgcb_n_all[source_name]) begin
						//Check for other SIPs in the same FET block
						if(cfg.cfg_sip_pgcb_n_all[source_name].fet_name == fet_name) begin
							if(sip_vif_all[source_name].pmc_ip_pg_ack_b !== 0) begin
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
	virtual task DriveFetOffIndex(int delay_arg, string fet_name);
		bit pull_fet;
		pull_fet = 1;
			if(cfg.fetONMode_n[fet_name] === 0)
			begin
				if(cfg.no_sip === 0) begin
					pull_fet = fetCanBeTurnedOff(fet_name);
				end		
				if(pull_fet === 1) begin
					//drive fet en
					delay_fet(delay_arg);
					//Check the states again and randomly decide to turn off the FET
					if(cfg.no_sip === 0) begin	
						pull_fet = fetCanBeTurnedOff(fet_name);
					end				
					if(pull_fet) begin
						foreach(cfg.cfg_sip_pgcb_n_all[n]) begin if(fet_name == cfg.cfg_sip_pgcb_n_all[n].fet_name) begin sip_vif_all[n].fet_en_b = 1; end end
						//wiat for fet ack
						foreach(cfg.cfg_sip_pgcb_n_all[n]) begin if(fet_name == cfg.cfg_sip_pgcb_n_all[n].fet_name) begin wait(sip_vif_all[n].fet_en_ack_b === 1); end end
					end
					else if($urandom_range(0,1)) begin
						foreach(cfg.cfg_sip_pgcb_n_all[n]) begin if(fet_name == cfg.cfg_sip_pgcb_n_all[n].fet_name) begin sip_vif_all[n].fet_en_b = 1; end end
						//wiat for fet ack
						foreach(cfg.cfg_sip_pgcb_n_all[n]) begin if(fet_name == cfg.cfg_sip_pgcb_n_all[n].fet_name) begin wait(sip_vif_all[n].fet_en_ack_b === 1); end end					
					end
				end
			end
	endtask
	virtual task DriveFETOff(int delay_arg, PowerGatingSeqItem req_arg);
		string fet_name;
		begin
			fet_name =req_arg.sourceName;
			DriveFetOffIndex(delay_arg, fet_name);
			req_arg.setComplete();
		end
	endtask 	
