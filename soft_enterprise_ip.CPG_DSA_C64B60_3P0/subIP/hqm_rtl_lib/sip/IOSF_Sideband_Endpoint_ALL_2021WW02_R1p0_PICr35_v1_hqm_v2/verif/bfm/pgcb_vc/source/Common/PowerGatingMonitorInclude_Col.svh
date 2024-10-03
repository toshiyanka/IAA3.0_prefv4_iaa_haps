	//PMC signals
	//`CHASSIS_PG_MONITOR(pmc_ip_pg_wake, cfg.num_pmc_wake, reset_b, PMC_SIP_WAKE, PMC_SIP_WAKE_DSD, SIP, 0)
	task pmc_ip_pg_wake_monitor(); 
		PowerGatingMonitorSeqItem x; 
		forever begin 
			@(posedge sip_if.clk) 
				if (sip_if.reset_b === 1 && sip_if.pmc_ip_pg_wake === 0 && temp_pmc_ip_pg_wake === 1) begin 
					x = new(); 
					x.source = i; 
					x.startTime = $time; 
					x.typ = PowerGating::SIP; 
					x.evnt = PowerGating::PMC_SIP_WAKE_DSD; 
					x.sourceName = name;
					ap.write(x); 
				end
				if (sip_if.reset_b === 1 && sip_if.pmc_ip_pg_wake === 1 && temp_pmc_ip_pg_wake === 0) begin 
					x = new(); 
					x.source = i; 
					x.startTime = $time; 
					x.typ = PowerGating::SIP; 
					x.evnt = PowerGating::PMC_SIP_WAKE; 
					x.sourceName = name;
					ap.write(x); 
				end 
				temp_pmc_ip_pg_wake = sip_if.pmc_ip_pg_wake; 
		end 
	endtask: pmc_ip_pg_wake_monitor 

	//`CHASSIS_PG_MONITOR(pmc_ip_sw_pg_req_b, cfg.num_sip_pgcb, reset_b, SW_PG_REQ_DSD, SW_PG_REQ, SIP, 0)
	task pmc_ip_sw_pg_req_b_monitor(); 
		PowerGatingMonitorSeqItem x; 
		forever begin 
			@(posedge sip_if.clk) 
				if (sip_if.reset_b === 1 && sip_if.pmc_ip_sw_pg_req_b === 0 && temp_pmc_ip_sw_pg_req_b === 1) begin 
					x = new(); 
					x.source = i; 
					x.startTime = $time; 
					x.typ = PowerGating::SIP; 
					x.evnt = PowerGating::SW_PG_REQ; 
					x.sourceName = name;
					ap.write(x); 
				end
				if (sip_if.reset_b === 1 && sip_if.pmc_ip_sw_pg_req_b === 1 && temp_pmc_ip_sw_pg_req_b === 0) begin 
					x = new(); 
					x.source = i; 
					x.startTime = $time; 
					x.typ = PowerGating::SIP; 
					x.evnt = PowerGating::SW_PG_REQ_DSD; 
					x.sourceName = name;
					ap.write(x); 
				end 
				temp_pmc_ip_sw_pg_req_b = sip_if.pmc_ip_sw_pg_req_b; 
		end 
	endtask: pmc_ip_sw_pg_req_b_monitor
	//POK
	//`CHASSIS_PG_MONITOR(side_pok, cfg.num_sb_ep, reset_b, SIDE_POK_ASD, SIDE_POK_DSD, POK, 0)
	task side_pok_monitor(); 
		PowerGatingMonitorSeqItem x; 
		forever begin 
			@(posedge sip_if.clk) 
			for(int k = 0; k < cfg.cfg_sip_pgcb_n[name].num_side; k++) begin 
				if (sip_if.reset_b === 1 && sip_if.side_pok[k] === 0 && temp_side_pok[k] === 1) begin 
					x = new(); 
					x.source = k; 
					x.startTime = $time; 
					x.typ = PowerGating::POK; 
					x.evnt = PowerGating::SIDE_POK_DSD; 
					x.sourceName = name;
					ap.write(x); 
				end
				if (sip_if.reset_b === 1 && sip_if.side_pok[k] === 1 && temp_side_pok[k] === 0) begin 
					x = new(); 
					x.source = k; 
					x.startTime = $time; 
					x.typ = PowerGating::POK; 
					x.evnt = PowerGating::SIDE_POK_ASD; 
					x.sourceName = name;
					ap.write(x); 
				end 
				temp_side_pok[k] = sip_if.side_pok[k]; 
			end 
		end 
	endtask: side_pok_monitor 	
	task side_rst_b_monitor(); 
		PowerGatingMonitorSeqItem x; 
		forever begin 
			@(posedge sip_if.clk) 
			for(int k = 0; k < cfg.cfg_sip_pgcb_n[name].num_side; k++) begin 
				if (sip_if.reset_b === 1 && sip_if.side_rst_b[k] === 0 && temp_side_rst_b[k] === 1) begin 
					x = new(); 
					x.source = k; 
					x.startTime = $time; 
					x.typ = PowerGating::POK; 
					x.evnt = PowerGating::SIDE_RST_ASD; 
					x.sourceName = name;
					ap.write(x); 
				end
				if (sip_if.reset_b === 1 && sip_if.side_rst_b[k] === 1 && temp_side_rst_b[k] === 0) begin 
					x = new(); 
					x.source = k; 
					x.startTime = $time; 
					x.typ = PowerGating::POK; 
					x.evnt = PowerGating::SIDE_RST_DSD; 
					x.sourceName = name;
					ap.write(x); 
				end 
				temp_side_rst_b[k] = sip_if.side_rst_b[k]; 
			end 
		end 
	endtask: side_rst_b_monitor 
	//`CHASSIS_PG_MONITOR(prim_pok, cfg.num_prim_ep, reset_b, PRIM_POK_ASD, PRIM_POK_DSD, POK, 0)
	task prim_pok_monitor(); 
		PowerGatingMonitorSeqItem x; 
		forever begin 
			@(posedge sip_if.clk) 
			for(int k = 0; k < cfg.cfg_sip_pgcb_n[name].num_prim; k++) begin 
				if (sip_if.reset_b === 1 && sip_if.prim_pok[k] === 0 && temp_prim_pok[k] === 1) begin 
					x = new(); 
					x.source = k; 
					x.startTime = $time; 
					x.typ = PowerGating::POK; 
					x.evnt = PowerGating::PRIM_POK_DSD; 
					x.sourceName = name;
					ap.write(x); 
				end
				if (sip_if.reset_b === 1 && sip_if.prim_pok[k] === 1 && temp_prim_pok[k] === 0) begin 
					x = new(); 
					x.source = i; 
					x.startTime = $time; 
					x.typ = PowerGating::POK; 
					x.evnt = PowerGating::PRIM_POK_ASD; 
					x.sourceName = name;
					ap.write(x); 
				end 
				temp_prim_pok[k] = sip_if.prim_pok[k]; 
			end 
		end 
	endtask: prim_pok_monitor 
	task prim_rst_b_monitor(); 
		PowerGatingMonitorSeqItem x; 
		forever begin 
			@(posedge sip_if.clk) 
			for(int k = 0; k < cfg.cfg_sip_pgcb_n[name].num_prim; k++) begin 
				if (sip_if.reset_b === 1 && sip_if.prim_rst_b[k] === 0 && temp_prim_rst_b[k] === 1) begin 
					x = new(); 
					x.source = k; 
					x.startTime = $time; 
					x.typ = PowerGating::POK; 
					x.evnt = PowerGating::PRIM_RST_ASD; 
					x.sourceName = name;
					ap.write(x); 
				end
				if (sip_if.reset_b === 1 && sip_if.prim_rst_b[k] === 1 && temp_prim_rst_b[k] === 0) begin 
					x = new(); 
					x.source = k; 
					x.startTime = $time; 
					x.typ = PowerGating::POK; 
					x.evnt = PowerGating::PRIM_RST_DSD; 
					x.sourceName = name;
					ap.write(x); 
				end 
				temp_prim_rst_b[k] = sip_if.prim_rst_b[k]; 
			end 
		end 
	endtask: prim_rst_b_monitor 	

	//D3 D0I3
	//`CHASSIS_PG_MONITOR(ip_pmc_d3, cfg.num_d3, reset_b, D3_ASD, D3_DSD, SIP, 0)
	task ip_pmc_d3_monitor(); 
		PowerGatingMonitorSeqItem x; 
		forever begin 
			@(posedge sip_if.clk) 
			for(int k = 0; k < cfg.cfg_sip_pgcb_n[name].num_d3; k++) begin 
				if (sip_if.reset_b === 1 && sip_if.ip_pmc_d3[k] === 0 && temp_ip_pmc_d3[k] === 1) begin 
					x = new(); 
					x.source = k; 
					x.startTime = $time; 
					x.typ = PowerGating::SIP; 
					x.evnt = PowerGating::D3_DSD; 
					x.sourceName = cfg.sip_name_d3[k];
					ap.write(x); 
				end
				if (sip_if.reset_b === 1 && sip_if.ip_pmc_d3[k] === 1 && temp_ip_pmc_d3[k] === 0) begin 
					x = new(); 
					x.source = k; 
					x.startTime = $time; 
					x.typ = PowerGating::SIP; 
					x.evnt = PowerGating::D3_ASD; 
					x.sourceName = cfg.sip_name_d3[k];
					ap.write(x); 
				end 
				temp_ip_pmc_d3[k] = sip_if.ip_pmc_d3[k]; 
			end 
		end 
	endtask: ip_pmc_d3_monitor 	
	//`CHASSIS_PG_MONITOR(ip_pmc_d0i3, cfg.num_d0i3, reset_b, D0I3_ASD, D0I3_DSD, SIP, 0)
	task ip_pmc_d0i3_monitor(); 
		PowerGatingMonitorSeqItem x; 
		forever begin 
			@(posedge sip_if.clk) 
			for(int k = 0; k < cfg.cfg_sip_pgcb_n[name].num_d0i3; k++) begin 
				if (sip_if.reset_b === 1 && sip_if.ip_pmc_d0i3[k] === 0 && temp_ip_pmc_d0i3[k] === 1) begin 
					x = new(); 
					x.source = k; 
					x.startTime = $time; 
					x.typ = PowerGating::SIP; 
					x.evnt = PowerGating::D0I3_DSD; 
					x.sourceName = cfg.sip_name_d0i3[k];
					ap.write(x); 
				end
				if (sip_if.reset_b === 1 && sip_if.ip_pmc_d0i3[k] === 1 && temp_ip_pmc_d0i3[k] === 0) begin 
					x = new(); 
					x.source = k; 
					x.startTime = $time; 
					x.typ = PowerGating::SIP; 
					x.evnt = PowerGating::D0I3_ASD; 
					x.sourceName = cfg.sip_name_d0i3[k];
					ap.write(x); 
				end 
				temp_ip_pmc_d0i3[k] = sip_if.ip_pmc_d0i3[k]; 
			end 
		end 
	endtask: ip_pmc_d0i3_monitor 

