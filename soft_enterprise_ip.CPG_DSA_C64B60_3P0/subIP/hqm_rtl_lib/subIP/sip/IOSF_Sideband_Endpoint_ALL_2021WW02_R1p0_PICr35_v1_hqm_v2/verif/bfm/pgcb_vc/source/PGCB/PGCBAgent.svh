
class PGCBAgent extends PowerGatingBaseAgent;
	//=========================================================================
	// PUBLIC VARIABLES
	//=========================================================================
	PGCBAgentSequencer sequencer;                         // ptr to this agents primary sequencer
	PGCBAgentFabricResponder responder; 
	PGCBAgentSIPResponder sip_responder;
	PGCBAgentDriver driver;                               // ptr to this agents driver

	ovm_object cfg_temp;

	PGCBAgentFabricFSM fabricFSM[$];
	PGCBAgentSIPFSM sipFSM[$];
	//col change
	PowerGatingBaseFSM		fab_fsm[string];
	PowerGatingBaseFSM		sip_fsm[string];
	PGCBAgentDriver_Col 	driver_c;	
	//END col change	
	//=========================================================================
	// OVM Macros for public variables
	//=========================================================================
	//Below exports the is_active variable as a configurable variable
	`ovm_component_utils_begin(PGCBAgent)
		`ovm_field_enum(ovm_active_passive_enum, is_active, OVM_ALL_ON)
        `ovm_field_int(hasPrinter, OVM_ALL_ON | OVM_BIN)
		`ovm_field_string(interfaceName, OVM_ALL_ON | OVM_BIN)
	`ovm_component_utils_end

	//=========================================================================
	// PROTECTED VARIABLES
	//=========================================================================
	
	//=========================================================================
	// PRIVATE VARIABLES
	//=========================================================================	
	int num_sip_pgcb;
	int num_fab_pgcb;
	int num_pmc_wake;
	int num_sw_req;	
	int num_sb_ep;
	int num_prim_ep;	
	int num_fet;
	bit bfm_drives_pok;
	bit bfm_drives_fet_en_ack;
	//=========================================================================
	// PUBLIC FUNCTIONS
	//=========================================================================

	/**************************************************************************
	*  @brief Constructor.
	**************************************************************************/
	function new(string name, ovm_component parent);
		super.new(name,parent);	
	endfunction: new

	/**************************************************************************
	*  @brief : description of what this method does
	*
	*  @param someArgument_arg : description of some argument
	**************************************************************************/
	virtual function void get_cfg_info();
		if (!get_config_object({get_name(), "ConfigObject"}, cfg_temp, 0))begin
			string str;
			$sformat(str, "%s", get_name());
     		`ovm_fatal("CCAgent", {"PowerGatingConfig Configuration object", str,  "ConfigObject cannot found. The object name should be set to <agent name>ConfigObject."})	
		end
   		if (!($cast(cfg, cfg_temp)))
    	 `ovm_fatal("PGCBAgent", "Type mismatch while casting PowerGatingConfig object")

	 	if(!get_config_int("POWERGATING_NUM_SIP_PGCB", num_sip_pgcb)) begin
			//phase 2
			_phase = PowerGating::PHASE_2;
			`ovm_info(get_full_name(), $psprintf("PGCBAgent POWERGATING_NUM_SIP_PGCB not found. Expected scope to match %s. So the agent is configured with collage interface. ", get_full_name()), OVM_LOW)	
	 	end
		else begin
			assert(get_config_int("POWERGATING_NUM_SIP_PGCB", num_sip_pgcb));
			assert(get_config_int("POWERGATING_NUM_FAB_PGCB", num_fab_pgcb));
			assert(get_config_int("POWERGATING_NUM_PMC_WAKE", num_pmc_wake));
			assert(get_config_int("POWERGATING_NUM_SW_REQ", num_sw_req));		
			assert(get_config_int("POWERGATING_NUM_SB_EP", num_sb_ep));
			assert(get_config_int("POWERGATING_NUM_PRIM_EP", num_prim_ep));
			assert(get_config_int("POWERGATING_NUM_FET", num_fet));
			assert(get_config_int("POWERGATING_IS_ACTIVE", IS_ACTIVE));		
			assert(get_config_int("POWERGATING_BFM_DRIVES_POK", bfm_drives_pok));		
			assert(get_config_int("POWERGATING_BFM_DRIVES_FET_EN_ACK", bfm_drives_fet_en_ack));			
	
			cfg.SetNumFab(num_fab_pgcb);
			cfg.SetNumSIP(num_sip_pgcb);
			cfg.SetNumFET(num_fet);
			cfg.num_pmc_wake = num_pmc_wake;
			cfg.num_sw_req = num_sw_req;
			cfg.num_sb_ep = num_sb_ep;
			cfg.num_prim_ep = num_prim_ep;
			cfg.bfm_drives_pok = bfm_drives_pok;
			cfg.bfm_drives_fet_en_ack = bfm_drives_fet_en_ack;
			if (IS_ACTIVE == 1 && is_active != OVM_ACTIVE) begin
  				`ovm_warning(get_full_name(), "IS_ACTIVE in the test-island was set to 1 but CCAgent's is_active was not set to 1. Over-riding with IS_ACTIVE in the test-island")
 				is_active = OVM_ACTIVE;
			end
			else if(IS_ACTIVE == 0 && is_active == OVM_ACTIVE) begin
  				`ovm_warning(get_full_name(), "IS_ACTIVE in the test-island was set to 0 but CCAgent's is_active was not set to 0. Over-riding with IS_ACTIVE in the test-island")			
				is_active = OVM_PASSIVE;
			end	
		end
	endfunction   
	virtual function void build();
		super.build();
	endfunction : build

	virtual function void connect();
		super.connect();
	endfunction : connect
	//=========================================================================
	// PROTECTED FUNCTIONS
	//=========================================================================	
	/**************************************************************************
	*  @brief : builds all active components (e.g. sequencer, driver, responder)
	**************************************************************************/
	protected virtual function void buildActiveComponents();
		//col change
		if(_phase == PowerGating::PHASE_1)  begin	
			driver = PGCBAgentDriver::type_id::create({get_name(),"driver"},this);
		end
		else begin
			driver_c = PGCBAgentDriver_Col::type_id::create({get_name(),"driver_col"},this);			
		end
		//END col change
		`ovm_info(get_full_name(), "Driver CREATED", OVM_HIGH)
		sequencer = PGCBAgentSequencer::type_id::create({get_name(),"sequencer"},this);
		`ovm_info(get_full_name(), "Sequencer CREATED", OVM_HIGH)
		sip_responder = PGCBAgentSIPResponder::type_id::create({get_name(),".SIPResponder"},this);
		`ovm_info(get_full_name(), "SIP Responder CREATED", OVM_HIGH)
		responder = PGCBAgentFabricResponder::type_id::create({get_name(),".Responder"},this);
		`ovm_info(get_full_name(), "Fab Responder CREATED", OVM_HIGH)		
	endfunction: buildActiveComponents

	
	/**************************************************************************
	*  @brief : builds all active components (e.g. sequencer to driver, responder to driver/sequencer)
	**************************************************************************/
	protected virtual function void connectActiveComponents();
		//col change
		if(_phase == PowerGating::PHASE_1)  begin	
			driver.seq_item_port.connect(sequencer.seq_item_export);
			`ovm_info(get_full_name(), "Driver and Sequencer CONNECTED", OVM_HIGH)
			driver.setVIF(_vif);	
			`ovm_info(get_full_name(), "Interface passed into driver", OVM_HIGH)
		
			driver.setCfg(cfg);

			for(int n = 0; n < cfg.num_fab_pgcb; n ++) begin
				PGCBAgentFabricFSM fabricFSM_temp;
				fabricFSM_temp = new({get_name(), cfg.cfg_fab_pgcb[n].name, "Fab"}, this); 
				fabricFSM_temp.ap.connect(responder.monitor_i.analysis_export);
				fabricFSM_temp.setVIF(_vif);	
				fabricFSM_temp.setSource(n);	
				fabricFSM_temp.setCfg(cfg);
				fabricFSM[n] = fabricFSM_temp;
			end
			for(int n = 0; n < cfg.num_sip_pgcb; n ++) begin
				PGCBAgentSIPFSM sipFSM_temp;
				sipFSM_temp = new({get_name(), cfg.cfg_sip_pgcb[n].name, "SIP"}, this);
				sipFSM_temp.ap.connect(sip_responder.monitor_i.analysis_export);
				sipFSM_temp.setVIF(_vif);	
				sipFSM_temp.setSource(n);	
				sipFSM_temp.setCfg(cfg);
				sipFSM[n] = sipFSM_temp;
			end
		end
		else if(_phase == PowerGating::PHASE_2) begin
			//col change
			driver_c.seq_item_port.connect(sequencer.seq_item_export);
			`ovm_info(get_full_name(), "Driver and Sequencer CONNECTED", OVM_HIGH)
			driver_c.setVIF(_vif);	
			`ovm_info(get_full_name(), "Interface passed into driver", OVM_HIGH)
			driver_c.setCfg(cfg);
			driver_c.set_intf(reset_if, sip_if, fab_if);			
			
			foreach(cfg.cfg_sip_pgcb_n[n]) begin
				assert($cast(sip_fsm[n], create_component("PGCBAgentSIPFSM_Col", {n, "sipFSM_col"})));
				sip_fsm[n].ap.connect(sip_responder.monitor_i.analysis_export);
				sip_fsm[n].set_sip_intf(sip_if[n]);
				//sip_fsm[n].set_fet_intf(fet_if[cfg.cfg_sip_pgcb_n[n].fet_name]);
				sip_fsm[n].name = n;
				sip_fsm[n].setVIF(_vif);	
				sip_fsm[n].setCfg(cfg);
			end
			foreach(cfg.cfg_fab_pgcb_n[n]) begin
				assert($cast(fab_fsm[n], create_component("PGCBAgentFabricFSM_Col", {n, "fabFSM_col"})));
				fab_fsm[n].ap.connect(responder.monitor_i.analysis_export);
				fab_fsm[n].set_fab_intf(fab_if[n]);
				fab_fsm[n].set_sip_intf(sip_if[cfg.sip_belongs_to_fabric[n]]);
				fab_fsm[n].setSource(cfg.fab_index[n]);
				fab_fsm[n].name = n;
				fab_fsm[n].setVIF(_vif);	
				fab_fsm[n].setCfg(cfg);
			end				
			//END col change			
		end
		responder.setTargetSequencer(sequencer);
		sip_responder.setTargetSequencer(sequencer);

	endfunction: connectActiveComponents

	
	/**************************************************************************
	*  @brief : looks up the interface container for the agent, assuming a standard naming convention.
	**************************************************************************/
	protected virtual function void get_intf_p1(); 
		sla_vif_container #(virtual PowerGatingNoParamIF) slaAgentIFContainer;
		ovm_object tmpPtrToAgentIFContainer;
		string fullNameOfVirtualInterfaceContainer, fatalMsg;
		//fullNameOfVirtualInterfaceContainer = {cfg.test_isand_name,"IFContainer"};
		fullNameOfVirtualInterfaceContainer = interfaceName;
		if(!get_config_object(fullNameOfVirtualInterfaceContainer, tmpPtrToAgentIFContainer)) begin
			//col change
			_phase = PowerGating::PHASE_2;
			`ovm_info(get_full_name(), $psprintf("Failed to find the interface container named %s. So the agent is configured with collage interface.", fullNameOfVirtualInterfaceContainer), OVM_LOW)				
			//END col change		
		end
	
		/*else begin
			$sformat(fatalMsg, );
			`ovm_fatal(get_full_name(), fatalMsg);	
		end 
*/
		else begin
		assert($cast(slaAgentIFContainer, tmpPtrToAgentIFContainer)) begin
			_vif = slaAgentIFContainer.get_v_if();                           //SLA will return the virtual interface here.
			assert (_vif != null) else begin
				$sformat(fatalMsg, "Failed to find the interface inside the '%s' vif. Be sure to match the name of the Agent to the name of the container. Format of container name = {'agentName',IFContainer}. ex: FooAgent = new('myFoo1'), requires foo_sla_vif_container = new('myFoo1IFContainer')", fullNameOfVirtualInterfaceContainer);
				`ovm_fatal(get_full_name(), fatalMsg)
			end
		end else begin
			$sformat(fatalMsg, "Failed to find %s virtual interface container. Be sure to match the name of the Agent to the name of the container. ex: FooAgent = new('myFoo1'), requires foo_sla_vif_container = new('myFoo1IFContainer')", fullNameOfVirtualInterfaceContainer);
			`ovm_fatal(get_full_name(), fatalMsg);
		end	
		end
		
	endfunction : get_intf_p1
endclass : PGCBAgent
