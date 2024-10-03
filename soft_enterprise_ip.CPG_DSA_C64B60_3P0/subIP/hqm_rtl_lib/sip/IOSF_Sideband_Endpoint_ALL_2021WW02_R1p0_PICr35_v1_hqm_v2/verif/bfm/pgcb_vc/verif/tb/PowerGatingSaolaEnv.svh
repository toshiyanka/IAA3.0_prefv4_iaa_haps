
/*
================================================================================
  Copyright (c) 2011 Intel Corporation, all rights reserved.

  THIS PROGRAM IS AN UNPUBLISHED WORK FULLY PROTECTED BY COPYRIGHT LAWS AND IS 
  CONSIDERED A TRADE SECRET BELONGING TO THE INTEL CORPORATION.
================================================================================

  Author          : Alamelu Ramaswamy
  Email           : 
  Phone           : 916-377-2848
  Date            : July 18th, 2012

================================================================================
 Description     : 
This is the env for all the power gating VC
//The  CC and LC are connected to each other for validation purposes
================================================================================
*/

class PowerGatingSaolaEnv extends ovm_env;
	
        // Variable: ti_path
        //
        // Hierarchical path to test island used to create key for retrieving virtual
        // interface from config DB
        //protected string ti_path  = "";
    
        // variable: is_active
        //
        // Indicates whether env is active or passive in testbench
        //protected ovm_active_passive_enum is_active = OVM_ACTIVE;

        `ovm_component_utils_begin(PowerGatingSaolaEnv)
	     //`ovm_field_string(                         ti_path,       OVM_ALL_ON)
             //`ovm_field_enum  (ovm_active_passive_enum, is_active,     OVM_ALL_ON)
	`ovm_component_utils_end

	CCAgent ccAgent;
	CCAgent ccAgent_passive;	

	PGCBAgent pgcbAgent;
	PGCBAgent pgcbAgent_active;	
        
	//Hip CC Agents
        //hip_pg_vc hip_pg_vc1;
        hip_pg_agent hip_pg_vc1;

	CCAgent	ccAgent_col;	
	PGCBAgent pgcbAgent_col;	
	CCAgent	ccAgentCsme2_col;	
	PGCBAgent pgcbAgentCsme2_col;		

	PowerGatingConfig cc_cfg;
	PowerGatingConfig cc_cfg_pgcb;
	PowerGatingConfig get_cfg;
	TestScoreboard testSB;
	PowerGatingConfig cc_cfg_col;
	PowerGatingConfig cc_cfg_col_pgcb;	
	PowerGatingMonitor mon;

	hip_pg_config hip_cfg;

	//This is for being able to read the interface values from the test
	virtual PowerGatingNoParamIF _vif;
	virtual PowerGatingSIPIF	sip_vif;

	function new(string name, ovm_component parent);
		super.new(name, parent);
		//Create Hip PG VC
		//hip_pg_vc1 = hip_pg_vc::type_id::create("hip_pg_vc1", this);

	endfunction

	function void build();
                
	    /*DBV
                string inst_name;
                ovm_object tmp;
                //`ifdef _OVM
                //      mphy_utils_pkg::ovm_container #(virtual hip_pg_if) hip_pg_intfc; 
		//`endif
                virtual hip_pg_if _vif;
                ovm_container #(virtual hip_pg_if) hip_pg_intfc2;
                int i;
                
		// set up config db entries needed by HIP PG VC.  Note that these use
                // hierarchical scoping in the config database to ensure that config
                // objects are only visible by the HIP PG VC instantiations for which
                // they're intended.
                //`MPHYTB_ASSERT(get_config_string("ti_path",ti_path));
                set_config_string("hip_pg_vc1*","ti_path",ti_path);
		PowerGatingTestbenchTop.ti_hip_pg_if
                set_config_int   ("hip_pg_vc1*","num_domains",NUM_POWER_DOMAINS);
                set_config_int   ("hip_pg_vc1*","is_active",is_active);

		// hip_pg_vc provides its own ovm_container class, so non-CVE customers
                // can use this same approach to put the interfaces into the OVM config
                // object database. However, this means we grab the existing interfaces
                // and put them into the containers that the VC will expect to see...
          
                for (i=0;i<NUM_POWER_DOMAINS;i++) begin
          
                    //`ifdef _OVM
                    //  `MPHYTB_ASSERT(get_config_object($psprintf("%0s.hip_pg_intf%0d",ti_path,i),tmp));
                    //  `MPHYTB_ASSERT($cast(hip_pg_intfc,tmp));
                    //  _vif = hip_pg_intfc.val;
                    //`endif // `ifdef _OVM
               
                    `ifdef _SAOLA
                      _vif = sla_resource_db#(virtual hip_pg_if)::get($psprintf("%0s.hip_pg_intf%0d",ti_path,i));
                    `endif // `ifdef _SAOLA
                   
                      hip_pg_intfc2 = new();
                      hip_pg_intfc2.val = _vif;
                      set_config_object("hip_pg_vc1*",$psprintf("interface %0d",i),hip_pg_intfc2,0);
                end
                */   
               
                   
	        // Turn off all the sequencers by default
	        set_config_int("*sequencer", "count", 0);
	        set_config_int("*ccAgent01_passive", "is_active", 0);
		set_config_int("*ccAgent*col", "is_active", 1);
		set_config_int("*pgcbAgent*col", "is_active", 1);

		set_config_int("*pgcbAgent01*", "hasPrinter", 1);

		set_config_int("*ccAgent01*", "hasPrinter", 1);

		set_config_int("*pgcbAgentCsme*", "hasPrinter", 1);
		set_config_int("*ccAgentCsme*", "hasPrinter", 1);
		
                set_config_int("*hip_pg_vc_all*", "is_active", 1);

		//ovm_top.set_config_int("*", "disable_eot_check", 1);

		super.build();

		pgcbAgent = PGCBAgent::type_id::create("pgcbAgent01", this);
		pgcbAgent_active = PGCBAgent::type_id::create("pgcbAgent01_active", this);

		//DBV
		//Create Hip CC agents
		hip_pg_vc1 = hip_pg_agent::type_id::create("hip_pg_vc_all", this);


		ccAgent = CCAgent::type_id::create("ccAgent01", this);
		ccAgent_passive = CCAgent::type_id::create("ccAgent01_passive", this);

		//col change
		`ifdef CHASSIS_PG_P2
		ccAgent_col = CCAgent::type_id::create("ccAgentCsme1_col", this);
		pgcbAgent_col = PGCBAgent::type_id::create("pgcbAgentCsme1_col", this);
		ccAgentCsme2_col = CCAgent::type_id::create("ccAgentCsme2_col", this);
		pgcbAgentCsme2_col = PGCBAgent::type_id::create("pgcbAgentCsme2_col", this);
		`endif
		//END col change

		cc_cfg = PowerGatingConfig::type_id::create({"ccAgent01","ConfigObject"}, this);
		cc_cfg_pgcb = new({"pgcbAgent01","ConfigObject"});

                hip_cfg = hip_pg_config::type_id::create({"config"}, this);


		`ovm_info(get_full_name(), "Agents created", OVM_HIGH)
		
		/********
		CC
		**********/	
	   cc_cfg.SetTrackerName("CCAgentTracker");
			
		cc_cfg.AddFETBlock(.index(0), .name("DOM0"));
		cc_cfg.AddFETBlock(.index(1), .name("DOM1"));		
		cc_cfg.AddFETBlock(.index(2), .name("DOM2"));	
		cc_cfg.AddFETBlock(.index(3), .name("DOM3"));	

		cc_cfg.AddFabricPGCB(.index(0), .name("FAB0"), .fet_index(0),.hys(300ns), .ungate_priority(4));
		cc_cfg.AddFabricPGCB(.index(1), .name("FAB1"), .fet_index(1),.hys(400ns), .ungate_priority(4));
		
		cc_cfg.AddSIPPGCB(.index(0), .name("PGD0"), .fet_index(0), .ungate_priority(1), .pmc_wake_index(0), .sw_ent_index(1), .SB_array({0}));
		cc_cfg.AddSIPPGCB(.index(1), .name("PGD1"), .fet_index(0), .ungate_priority(2), .pmc_wake_index(1), .sw_ent_index(0), .fabric_index(1));
		cc_cfg.AddSIPPGCB(.index(2), .name("PGD2"), .fet_index(1), .ungate_priority(3), .initial_state(PowerGating::POWER_UNGATED), .pmc_wake_index(2), .sw_ent_index(2));
		cc_cfg.AddSIPPGCB(.index(3), .name("PGD3"), .fet_index(2), .ungate_priority(4), .pmc_wake_index(2), .sw_ent_index(2), .fabric_index(0));

	
		cc_cfg.AddSIP(.name("GPIO"), .sip_type(PowerGating::HOST), .pgcb_array({0, 1}), .AON_prim_array({0}), .d3({0}), . d0i3({0}));
		cc_cfg.AddSIP(.name("TEST"), .sip_type(PowerGating::HOST), .AON_prim_array({1}));


		cc_cfg.AddSBEP(.index(0), .source_id('hE8));
		cc_cfg.AddSBEP(.index(1), .source_id('hB5));
		cc_cfg.AddSBEP(.index(2), .source_id('hA2));
		cc_cfg.AddPrimEP(.index(0), .AON_EP(1), .pmc_wake_index(3));


		/*****************
		PGCB
		******************/
		cc_cfg_pgcb.SetTrackerName("PGCBAgentTracker");
		
		//cc_cfg_pgcb.SetNumPMCWake(3);
		//cc_cfg_pgcb.SetNumSWEntities(2);
		cc_cfg_pgcb.AddFETBlock(.index(0), .name("FET0"));
		cc_cfg_pgcb.AddFETBlock(.index(1), .name("FET1"));		
		cc_cfg_pgcb.AddFETBlock(.index(2), .name("FET2"));	
		cc_cfg_pgcb.AddFETBlock(.index(3), .name("FET3"));

		cc_cfg_pgcb.AddFabricPGCB(.index(0), .name("FAB0"), .fet_index(0));
		//int .index, string .name, int .fet_index = 0, time .hys = 0ps, int sip_mapping{$}, int fabric_mapping{$}, bit initial_state
		cc_cfg_pgcb.AddFabricPGCB(.index(1), .name("FAB1"), .fet_index(1));
		
		cc_cfg_pgcb.AddSIPPGCB(.index(0), .name("SIP0"), .fet_index(0), .pmc_wake_index(0), .sw_ent_index(1), .SB_array({0}));
		cc_cfg_pgcb.AddSIPPGCB(.index(1), .name("SIP1"), .fet_index(0), .pmc_wake_index(1), .sw_ent_index(0), .fabric_index(1));
		cc_cfg_pgcb.AddSIPPGCB(.index(2), .name("SIP2"), .fet_index(1), .initial_state(PowerGating::POWER_UNGATED), .pmc_wake_index(2), .sw_ent_index(2));
		cc_cfg_pgcb.AddSIPPGCB(.index(3), .name("SIP3"), .fet_index(2), .pmc_wake_index(2), .sw_ent_index(2), .fabric_index(0));
	
		cc_cfg_pgcb.AddSIP(.name("CSME"), .sip_type(PowerGating::HOST), .pgcb_array({0, 1}), .AON_prim_array({0}));
		
		cc_cfg_pgcb.AddSBEP(.index(0), .source_id('hE8));
		cc_cfg_pgcb.AddSBEP(.index(1), .source_id('hB5));
		cc_cfg_pgcb.AddSBEP(.index(2), .source_id('hA2));
		cc_cfg_pgcb.AddPrimEP(.index(0), .AON_EP(1), .pmc_wake_index(3));	
	
		//cc_cfg_pgcb.SetAgentWakeModel();
		//cc_cfg.disable_eot_check = 0;
		//cc_cfg_pgcb.cfg_sip_pgcb[0].ignore_sw_req = 1;
  		set_config_object("*", "ccAgent01ConfigObject",cc_cfg,0);

		//DBV talk to Bill about this
		set_config_object("*", "config",hip_cfg,0);

		`ovm_info(get_full_name(), "Set config object CC", OVM_HIGH)

 		set_config_object("*", "pgcbAgent01ConfigObject",cc_cfg_pgcb,0);
		set_config_object("*", "pgcbAgent01_activeConfigObject",cc_cfg_pgcb,0);
               
		//scoreboard
		testSB = TestScoreboard::type_id::create("SB", this);
		
		/*****************
		*Passive agent
		******************/		
		cc_cfg = new({"ccAgent01_passive","ConfigObject"});
		cc_cfg.SetTestIslandName("ccAgent_pas");
		cc_cfg.SetTrackerName("CCAgentTracker_pas");

		cc_cfg.AddFETBlock(.index(0), .name("DOM0"));
		cc_cfg.AddFETBlock(.index(1), .name("DOM1"));		
		cc_cfg.AddFETBlock(.index(2), .name("DOM2")); 	
		cc_cfg.AddFETBlock(.index(3), .name("DOM3"));	

		cc_cfg.AddFabricPGCB(.index(0), .name("FAB0"), .fet_index(0),.hys(300ns), .ungate_priority(4));
		cc_cfg.AddFabricPGCB(.index(1), .name("FAB1"), .fet_index(0),.hys(400ns), .ungate_priority(4));
		
		cc_cfg.AddSIPPGCB(.index(0), .name("PGD1"), .fet_index(0), .ungate_priority(1), .pmc_wake_index(0), .sw_ent_index(1), .SB_array({0}));
		cc_cfg.AddSIPPGCB(.index(1), .name("PGD2"), .fet_index(0), .ungate_priority(2), .pmc_wake_index(1), .sw_ent_index(0), .fabric_index(1));
		cc_cfg.AddSIPPGCB(.index(2), .name("PGD3"), .fet_index(1), .ungate_priority(3), .initial_state(PowerGating::POWER_UNGATED), .pmc_wake_index(2), .sw_ent_index(2));

		cc_cfg.AddSIPPGCB(.index(3), 
			.name("PGD4"), 
			.fet_index(2), 
			.ungate_priority(4), 
			.pmc_wake_index(2), 
			.sw_ent_index(2), 
			.fabric_index(0)
		);
	
		cc_cfg.AddSIP(.name("GPIO"), .sip_type(PowerGating::HOST), .pgcb_array({0, 1, 2}), .AON_prim_array({0}));
		cc_cfg.AddSIP(.name("TEST"), .sip_type(PowerGating::HOST), .AON_prim_array({1}));

		cc_cfg.AddSBEP(.index(0), .source_id('hE8));
		cc_cfg.AddSBEP(.index(1), .source_id('hB5));
		cc_cfg.AddSBEP(.index(2), .source_id('hA2));
		cc_cfg.AddPrimEP(.index(0), .AON_EP(1), .pmc_wake_index(3));		
		set_config_object("*", "ccAgent01_passiveConfigObject",cc_cfg,0);


		//col change
		`ifdef CHASSIS_PG_P2
		//CCAgent
		cc_cfg_col = new({"ccAgentCsme1_col","ConfigObject"});
		cc_cfg_col.SetTrackerName("CCAgentTracker_csme1");
		//cc_cfg.disable_all_checks = 1;
		//cc_cfg.AddFETBlock(.index(0), .name("FET"));
		//cc_cfg.AddFabricPGCB(.index(0), .name("FAB"), .fet_index(0),.hys(300ns), .ungate_priority(3));
		cc_cfg_col.AddSIPPGCB(/*.index(0), */
				.name("KVM"), 
				/*.fet_index(0),*/ 
				.ungate_priority(1), 
				/*.pmc_wake_index(0), 
				.sw_ent_index(1), 
				.SB_array({0})*/
			   	.side_pid({'hE2})
			);
		cc_cfg_col.AddSIPPGCB(/*.index(0), */
				.name("PTIO"), 
				/*.fet_index(0),*/ 
				.ungate_priority(1), 
				/*.pmc_wake_index(0), 
				.sw_ent_index(1), 
				.SB_array({0})*/
			   	.side_pid({'hE3}),
				.fabric_index(0)
			);			
		cc_cfg_col.AddFabricPGCB(/*.index(0),*/
			.name("PTIO_F"), 
			/*.fet_index(0),*/
			.hys(300ns), 
			.ungate_priority(4));			
		cc_cfg_col.AddSIP(.name("CSME1"), 
				/*.sip_type(PowerGating::HOST),
				.pgcb_array({0}), 
				.AON_prim_array({0})*/
				.pgcb_name({"KVM"})
			);	
		cc_cfg_col.AddSBEP(.source_id('hE2), .ip_ready('hA0));
		//cc_cfg.AddPrimEP(.index(0), .AON_EP(1), .pmc_wake_index(2));			

		cc_cfg_col_pgcb = new({"pgcbAgentCsme1_col","ConfigObject"});
		//cc_cfg.disable_all_checks = 1;
		//cc_cfg.AddFETBlock(.index(0), .name("FET"));
		//cc_cfg.AddFabricPGCB(.index(0), .name("FAB"), .fet_index(0),.hys(300ns), .ungate_priority(3));
		cc_cfg_col_pgcb.AddSIPPGCB(/*.index(0), */
				.name("KVM"), 
				/*.fet_index(0),*/ 
				.ungate_priority(1), 
				/*.pmc_wake_index(0), 
				.sw_ent_index(1), 
				.SB_array({0})*/
			   	.side_pid({'hE2})
			);
		cc_cfg_col_pgcb.AddSIPPGCB(/*.index(0), */
				.name("PTIO"), 
				/*.fet_index(0),*/ 
				.ungate_priority(1), 
				/*.pmc_wake_index(0), 
				.sw_ent_index(1), 
				.SB_array({0})*/
			   	.side_pid({'hE3}),
				.fabric_name("PTIO_F")
			);			
		cc_cfg_col_pgcb.AddFabricPGCB(/*.index(0),*/
			.name("PTIO_F"), 
			/*.fet_index(0),*/
			.hys(300ns), 
			.ungate_priority(4));			
		cc_cfg_col_pgcb.AddSIP(.name("CSME1"), 
				/*.sip_type(PowerGating::HOST),
				.pgcb_array({0}), 
				.AON_prim_array({0})*/
				.pgcb_name({"KVM"})
			);	
		cc_cfg_col_pgcb.AddSBEP(.source_id('hE2), .ip_ready('hA0));
		cc_cfg_col_pgcb.SetTrackerName("PGCBAgentTracker_csme1");
		set_config_object("*", "ccAgentCsme1_colConfigObject",cc_cfg_col,0);
		set_config_object("*", "pgcbAgentCsme1_colConfigObject",cc_cfg_col_pgcb,0);
		`endif

		//second inastance
		//CCAgent
		cc_cfg_col = new({"ccAgentCsme2_col","ConfigObject"});
		cc_cfg_col.SetTrackerName("CCAgentTracker_csme2");
		cc_cfg_col.AddSIPPGCB(
				.name("SUS"), 
			   	.side_pid({'hE4})
			);
		cc_cfg_col.AddSIP(.name("CSME2"), 
				.pgcb_name({"SUS"})
			);
                
		//HIP Configuration
		hip_cfg.name="hip_all";
                hip_cfg.domain_controlled_by_pmc=0;
                hip_cfg.domain_controlled_by_pg=1;
                hip_cfg.t_T0_ps=0;
                hip_cfg.t_T1_ps=0;
                hip_cfg.t_T2_ps=0;
                hip_cfg.t_T3_ps=0;
                hip_cfg.t_T10_ps=0;
                hip_cfg.t_T11_ps=0;
                hip_cfg.t_T12_ps=0;
                hip_cfg.t_T13_ps=0;
                hip_cfg.t_T14_ps=0;
                hip_cfg.t_T_poweron_ps=0;
                hip_cfg.t_T_ip_prep_reset_exit_ps=0;
                hip_cfg.t_T_sbwake_clkreq_p_ps=0;
                hip_cfg.t_T_pok_assert_ps=0;
                hip_cfg.t_T_pok_deassert_ps=0;
                hip_cfg.t_T_pok_clkreq_n_ps=0;
                hip_cfg.t_T_ip_prep_reset_entry_ps=0;
                hip_cfg.t_T_powerdown_ps=0;
	
		set_config_object("*", "ccAgentCsme2_colConfigObject",cc_cfg_col,0);
		set_config_object("*", "pgcbAgentCsme2_colConfigObject",cc_cfg_col,0);
		//END col change

	endfunction

	virtual function void connect();
		sla_vif_container #(virtual PowerGatingNoParamIF) slaAgentIFContainer;
		sla_vif_container #(virtual PowerGatingSIPIF) slaAgentIFContainer_sip;
		//sla_vif_container #(virtual ReadIF) slaReadIFContainer;
		ovm_object tmpPtrToAgentIFContainer;
		string fullNameOfVirtualInterface, fatalMsg;
		
		fullNameOfVirtualInterface = "envIFContainer";
		
		assert(get_config_object(fullNameOfVirtualInterface, tmpPtrToAgentIFContainer)) else begin
			$sformat(fatalMsg, "Failed to find the interface container named %s.", fullNameOfVirtualInterface);
			`ovm_fatal(get_full_name(), fatalMsg);	
		end		

		assert($cast(slaAgentIFContainer, tmpPtrToAgentIFContainer)) begin
			_vif = slaAgentIFContainer.get_v_if();		//SLA will return the virtual interface here.
			assert (_vif != null) else begin
				$sformat(fatalMsg, "Failed to find the interface inside the '%s' vif. Be sure to match the name of the Agent to the name of the container. Format of container name = {'agentName',IFContainer}. ex: FooAgent = new('myFoo1'), requires foo_sla_vif_container = new('myFoo1IFContainer')", fullNameOfVirtualInterface);
				`ovm_fatal(get_full_name(), fatalMsg)
			end
		end else begin
			$sformat(fatalMsg, "Failed to find %s virtual interface container. Be sure to match the name of the Agent to the name of the container. ex: FooAgent = new('myFoo1'), requires foo_sla_vif_container = new('myFoo1IFContainer')", fullNameOfVirtualInterface);
			`ovm_fatal(get_full_name(), fatalMsg);
		end
		pgcbAgent.monitorAnalysisPort.connect(testSB.monitor.analysis_export);
		//col change
		`ifdef CHASSIS_PG_P2
		assert(get_config_object("sipIFContainer", tmpPtrToAgentIFContainer));
		assert($cast(slaAgentIFContainer_sip, tmpPtrToAgentIFContainer));
		sip_vif = slaAgentIFContainer_sip.get_v_if();
	`endif
		//END col change
	endfunction : connect

endclass : PowerGatingSaolaEnv
	

