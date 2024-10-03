	//PMC signals
	//`CHASSIS_PG_MONITOR(pmc_ip_pg_wake, cfg.num_pmc_wake, reset_b, PMC_SIP_WAKE, PMC_SIP_WAKE_DSD, SIP, 0)
	task pmc_ip_pg_wake_monitor(); 
		PowerGatingMonitorSeqItem x; 
		forever begin 
			@(posedge _vif.clk) 
			for(int i = 0; i < cfg.num_pmc_wake; i ++) begin 
				if (_vif.reset_b === 1 && _vif.pmc_ip_pg_wake[i] === 0 && temp_pmc_ip_pg_wake[i] === 1) begin 
					x = new(); 
					x.source = i; 
					x.startTime = $time; 
					x.typ = PowerGating::SIP; 
					x.evnt = PowerGating::PMC_SIP_WAKE_DSD; 
					x.sourceName = cfg.sip_name_pmc_wake[i];
					analysisPort.write(x); 
				end
				if (_vif.reset_b === 1 && _vif.pmc_ip_pg_wake[i] === 1 && temp_pmc_ip_pg_wake[i] === 0) begin 
					x = new(); 
					x.source = i; 
					x.startTime = $time; 
					x.typ = PowerGating::SIP; 
					x.evnt = PowerGating::PMC_SIP_WAKE; 
					x.sourceName = cfg.sip_name_pmc_wake[i];
					analysisPort.write(x); 
				end 
				temp_pmc_ip_pg_wake[i] = _vif.pmc_ip_pg_wake[i]; 
			end 
		end 
	endtask: pmc_ip_pg_wake_monitor 

	//`CHASSIS_PG_MONITOR(pmc_ip_sw_pg_req_b, cfg.num_sip_pgcb, reset_b, SW_PG_REQ_DSD, SW_PG_REQ, SIP, 0)
	task pmc_ip_sw_pg_req_b_monitor(); 
		PowerGatingMonitorSeqItem x; 
		forever begin 
			@(posedge _vif.clk) 
			for(int i = 0; i < cfg.num_sip_pgcb; i ++) begin 
				if (_vif.reset_b === 1 && _vif.pmc_ip_sw_pg_req_b[i] === 0 && temp_pmc_ip_sw_pg_req_b[i] === 1) begin 
					x = new(); 
					x.source = i; 
					x.startTime = $time; 
					x.typ = PowerGating::SIP; 
					x.evnt = PowerGating::SW_PG_REQ; 
					x.sourceName = cfg.cfg_sip_pgcb[i].getName();
					analysisPort.write(x); 
				end
				if (_vif.reset_b === 1 && _vif.pmc_ip_sw_pg_req_b[i] === 1 && temp_pmc_ip_sw_pg_req_b[i] === 0) begin 
					x = new(); 
					x.source = i; 
					x.startTime = $time; 
					x.typ = PowerGating::SIP; 
					x.evnt = PowerGating::SW_PG_REQ_DSD; 
					x.sourceName = cfg.cfg_sip_pgcb[i].getName();
					analysisPort.write(x); 
				end 
				temp_pmc_ip_sw_pg_req_b[i] = _vif.pmc_ip_sw_pg_req_b[i]; 
			end 
		end 
	endtask: pmc_ip_sw_pg_req_b_monitor
	//POK
	//`CHASSIS_PG_MONITOR(side_pok, cfg.num_sb_ep, reset_b, SIDE_POK_ASD, SIDE_POK_DSD, POK, 0)
	task side_pok_monitor(); 
		PowerGatingMonitorSeqItem x; 
		forever begin 
			@(posedge _vif.clk) 
			for(int i = 0; i < cfg.num_sb_ep; i ++) begin 
				if (_vif.reset_b === 1 && _vif.side_pok[i] === 0 && temp_side_pok[i] === 1) begin 
					x = new(); 
					x.source = i; 
					x.startTime = $time; 
					x.typ = PowerGating::POK; 
					x.evnt = PowerGating::SIDE_POK_DSD; 
					x.sourceName = cfg.sip_name_sb_ep[i];
					analysisPort.write(x); 
				end
				if (_vif.reset_b === 1 && _vif.side_pok[i] === 1 && temp_side_pok[i] === 0) begin 
					x = new(); 
					x.source = i; 
					x.startTime = $time; 
					x.typ = PowerGating::POK; 
					x.evnt = PowerGating::SIDE_POK_ASD; 
					x.sourceName = cfg.sip_name_sb_ep[i];
					analysisPort.write(x); 
				end 
				temp_side_pok[i] = _vif.side_pok[i]; 
			end 
		end 
	endtask: side_pok_monitor 	
	task side_rst_b_monitor(); 
		PowerGatingMonitorSeqItem x; 
		forever begin 
			@(posedge _vif.clk) 
			for(int i = 0; i < cfg.num_sb_ep; i ++) begin 
				if (_vif.reset_b === 1 && _vif.side_rst_b[i] === 0 && temp_side_rst_b[i] === 1) begin 
					x = new(); 
					x.source = i; 
					x.startTime = $time; 
					x.typ = PowerGating::POK; 
					x.evnt = PowerGating::SIDE_RST_ASD; 
					x.sourceName = cfg.sip_name_sb_ep[i];
					analysisPort.write(x); 
				end
				if (_vif.reset_b === 1 && _vif.side_rst_b[i] === 1 && temp_side_rst_b[i] === 0) begin 
					x = new(); 
					x.source = i; 
					x.startTime = $time; 
					x.typ = PowerGating::POK; 
					x.evnt = PowerGating::SIDE_RST_DSD; 
					x.sourceName = cfg.sip_name_sb_ep[i];
					analysisPort.write(x); 
				end 
				temp_side_rst_b[i] = _vif.side_rst_b[i]; 
			end 
		end 
	endtask: side_rst_b_monitor 
	//`CHASSIS_PG_MONITOR(prim_pok, cfg.num_prim_ep, reset_b, PRIM_POK_ASD, PRIM_POK_DSD, POK, 0)
	task prim_pok_monitor(); 
		PowerGatingMonitorSeqItem x; 
		forever begin 
			@(posedge _vif.clk) 
			for(int i = 0; i < cfg.num_prim_ep; i ++) begin 
				if (_vif.reset_b === 1 && _vif.prim_pok[i] === 0 && temp_prim_pok[i] === 1) begin 
					x = new(); 
					x.source = i; 
					x.startTime = $time; 
					x.typ = PowerGating::POK; 
					x.evnt = PowerGating::PRIM_POK_DSD; 
					x.sourceName = cfg.sip_name_prim_ep[i];
					analysisPort.write(x); 
				end
				if (_vif.reset_b === 1 && _vif.prim_pok[i] === 1 && temp_prim_pok[i] === 0) begin 
					x = new(); 
					x.source = i; 
					x.startTime = $time; 
					x.typ = PowerGating::POK; 
					x.evnt = PowerGating::PRIM_POK_ASD; 
					x.sourceName = cfg.sip_name_prim_ep[i];
					analysisPort.write(x); 
				end 
				temp_prim_pok[i] = _vif.prim_pok[i]; 
			end 
		end 
	endtask: prim_pok_monitor 
	task prim_rst_b_monitor(); 
		PowerGatingMonitorSeqItem x; 
		forever begin 
			@(posedge _vif.clk) 
			for(int i = 0; i < cfg.num_prim_ep; i ++) begin 
				if (_vif.reset_b === 1 && _vif.prim_rst_b[i] === 0 && temp_prim_rst_b[i] === 1) begin 
					x = new(); 
					x.source = i; 
					x.startTime = $time; 
					x.typ = PowerGating::POK; 
					x.evnt = PowerGating::PRIM_RST_ASD; 
					x.sourceName = cfg.sip_name_prim_ep[i];
					analysisPort.write(x); 
				end
				if (_vif.reset_b === 1 && _vif.prim_rst_b[i] === 1 && temp_prim_rst_b[i] === 0) begin 
					x = new(); 
					x.source = i; 
					x.startTime = $time; 
					x.typ = PowerGating::POK; 
					x.evnt = PowerGating::PRIM_RST_DSD; 
					x.sourceName = cfg.sip_name_prim_ep[i];
					analysisPort.write(x); 
				end 
				temp_prim_rst_b[i] = _vif.prim_rst_b[i]; 
			end 
		end 
	endtask: prim_rst_b_monitor 	

	//D3 D0I3
	//`CHASSIS_PG_MONITOR(ip_pmc_d3, cfg.num_d3, reset_b, D3_ASD, D3_DSD, SIP, 0)
	task ip_pmc_d3_monitor(); 
		PowerGatingMonitorSeqItem x; 
		forever begin 
			@(posedge _vif.clk) 
			for(int i = 0; i < cfg.num_d3; i ++) begin 
				if (_vif.reset_b === 1 && _vif.ip_pmc_d3[i] === 0 && temp_ip_pmc_d3[i] === 1) begin 
					x = new(); 
					x.source = i; 
					x.startTime = $time; 
					x.typ = PowerGating::SIP; 
					x.evnt = PowerGating::D3_DSD; 
					x.sourceName = cfg.sip_name_d3[i];
					analysisPort.write(x); 
				end
				if (_vif.reset_b === 1 && _vif.ip_pmc_d3[i] === 1 && temp_ip_pmc_d3[i] === 0) begin 
					x = new(); 
					x.source = i; 
					x.startTime = $time; 
					x.typ = PowerGating::SIP; 
					x.evnt = PowerGating::D3_ASD; 
					x.sourceName = cfg.sip_name_d3[i];
					analysisPort.write(x); 
				end 
				temp_ip_pmc_d3[i] = _vif.ip_pmc_d3[i]; 
			end 
		end 
	endtask: ip_pmc_d3_monitor 	
	//`CHASSIS_PG_MONITOR(ip_pmc_d0i3, cfg.num_d0i3, reset_b, D0I3_ASD, D0I3_DSD, SIP, 0)
	task ip_pmc_d0i3_monitor(); 
		PowerGatingMonitorSeqItem x; 
		forever begin 
			@(posedge _vif.clk) 
			for(int i = 0; i < cfg.num_d0i3; i ++) begin 
				if (_vif.reset_b === 1 && _vif.ip_pmc_d0i3[i] === 0 && temp_ip_pmc_d0i3[i] === 1) begin 
					x = new(); 
					x.source = i; 
					x.startTime = $time; 
					x.typ = PowerGating::SIP; 
					x.evnt = PowerGating::D0I3_DSD; 
					x.sourceName = cfg.sip_name_d0i3[i];
					analysisPort.write(x); 
				end
				if (_vif.reset_b === 1 && _vif.ip_pmc_d0i3[i] === 1 && temp_ip_pmc_d0i3[i] === 0) begin 
					x = new(); 
					x.source = i; 
					x.startTime = $time; 
					x.typ = PowerGating::SIP; 
					x.evnt = PowerGating::D0I3_ASD; 
					x.sourceName = cfg.sip_name_d0i3[i];
					analysisPort.write(x); 
				end 
				temp_ip_pmc_d0i3[i] = _vif.ip_pmc_d0i3[i]; 
			end 
		end 
	endtask: ip_pmc_d0i3_monitor 

