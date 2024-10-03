        class HIPPowergate_ungate_seq extends hip_pg_base_seq;

                hip_pg_power_gate_seq hip_pg_power_gateSeq;
	        hip_pg_power_ungate_seq hip_pg_power_ungateSeq;

		`ovm_sequence_utils(HIPPowergate_ungate_seq, hip_pg_sequencer);
	
		function new(string name = "HIPPowergate_ungate_seq", ovm_component parent = null);
			super.new(name);
		endfunction

                task body();
                  
		  //SIP Ungate HIP Power  
		  `ovm_do (hip_pg_power_ungateSeq)
		  #10ns;
		  //SIP Gate HIP Power
		  `ovm_do (hip_pg_power_gateSeq)
		  #1us;
		
	        endtask: body


    endclass //HIPPowergate_ungate_seq


	class HIPPowergate_ungate extends PowerGatingBaseTest;
		
		`ovm_component_utils(PowerGatingSaolaPkg::HIPPowergate_ungate)
	
		function new(string name = "HIPPowergate_ungate", ovm_component parent = null);
			super.new(name, parent);
		endfunction
                
                HIPPowergate_ungate_seq HIPPowergate_ungate_seq1;

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
			HIPPowergate_ungate_seq1 = new();
                        
  			`ovm_info(get_type_name(),"RUNNING",OVM_LOW)
			#200us;
			//start test
			/*------------------------------------------------------
                             1.      Mimic SIP ungating the HIP	
                             2.	Mimic SIP gating the HIP
			--------------------------------------------------------*/
		       
			 //`ovm_info(get_type_name(),"RUNNING HIP Power UnGate",OVM_NONE)
		         //hip_pg_power_ungateSeq.start(sla_env.hip_pg_vc1.sequencer);
			 //TODO: Spy on something in env to determine when to power gate instead of just delay
                         //#11ns;
			 //`ovm_info(get_type_name(),"RUNNING HIP Power Gate",OVM_NONE)
                         //hip_pg_power_gateSeq.start(sla_env.hip_pg_vc1.sequencer);
                        //`ovm_info(get_type_name(),"Will start to end test",OVM_NONE)
			HIPPowergate_ungate_seq1.start(sla_env.hip_pg_vc1.sequencer); 
			global_stop_request();

  		endtask

		function void report();
			ovm_report_info("HIPPowergate_ungate", "Test Passed!");
		endfunction

	endclass

