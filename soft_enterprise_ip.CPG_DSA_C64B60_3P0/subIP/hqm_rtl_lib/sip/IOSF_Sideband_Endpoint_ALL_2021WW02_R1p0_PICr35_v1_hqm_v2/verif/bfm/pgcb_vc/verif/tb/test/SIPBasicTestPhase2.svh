	class SIPBasicTestPhase2 extends PowerGatingBaseTest;
		SIPBaseTestPhase2Seq seq;
		`ovm_component_utils(PowerGatingSaolaPkg::SIPBasicTestPhase2)
	
		function new(string name = "SIPBasicTestPhase2", ovm_component parent = null);
			super.new(name, parent);
		endfunction

		function void build();
			set_config_int("sla_env", "data_phase_mode", SLA_RANDOM_NONE );
			set_config_int("*", "count", 0);
			set_config_int("*","recording_detail", OVM_FULL);
	  		ovm_top.set_report_verbosity_level(OVM_FULL);   
			
			super.build();
		endfunction

		function void connect();
			super.connect();   
		endfunction  
  		task run();
			seq = new();

  			`ovm_info(get_type_name(),"RUNNING",OVM_LOW)
			#200us;
			fork
				begin		
					//start test
					seq.start(sla_env.ccAgent_col._sequencer_c);				
				end
				begin
					//#1us;
					//sla_env.sip_vif.ip_pmc_pg_req_b = 1'b1;
					#20us;
					sla_env.sip_vif.ip_pmc_pg_req_b = 1'b0;
					#15us;
					sla_env.sip_vif.ip_pmc_pg_req_b = 1'b1;
					#5us;
				end
			join
		   	/*forever begin
			fork
				f1();
				reset();
			join_any
			disable fork;
			$display($psprintf("+++++++++++++++ @ %f ns Disabled all forks +++++++++++++++++", $time/1000));
			end
			*/
			#100us;
			global_stop_request();

  		endtask

		task f1();
			forever begin			
			#5us;
			fork
				f2();
			join_none
			end
		endtask

		task reset();
			#300us;
			$display($psprintf("+++++++++++++++ @ %f ns Global reset occured +++++++++++++++++", $time/1000));
		endtask
		task f2();			
			fork
				begin
					#1us;
				end
				begin
					#500ns;
					$display($psprintf("+++++++++++++++ @ %f ns f2 reset occured +++++++++++++++++", $time/1000));
				end
			join_any
			disable fork;
			$display($psprintf("+++++++++++++++ @ %f ns Disabled f2 forks +++++++++++++++++", $time/1000));
		endtask
		function void report();
			ovm_report_info("SIPBasicTest", "Test Passed!");
		endfunction

	endclass
	


		
