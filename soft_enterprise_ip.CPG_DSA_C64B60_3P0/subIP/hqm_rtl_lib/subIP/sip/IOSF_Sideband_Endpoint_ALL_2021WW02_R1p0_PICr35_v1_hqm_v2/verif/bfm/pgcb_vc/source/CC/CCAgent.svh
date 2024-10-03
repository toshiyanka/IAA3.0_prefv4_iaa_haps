class CCCfgNamePair;
	string scope;
	PowerGatingParamConfig cfg;
endclass

class CCAgent extends PowerGatingBaseAgent;
	//=========================================================================
	// PUBLIC VARIABLES
	//=========================================================================

	CCAgentSequencer 		sequencer;                         
	CCAgentResponder 		responder; 
	CCAgentSIPResponder 	sip_responder;
 	CCAgentArbiter 			arbiter;

	CCAgentDriver 			driver;       	
	CCAgentFabricFSM 		fabricFSM[$];
	CCAgentSIPFSM 			sipFSM[$];
	
	//col change
	static CCAgentSequencer _sequencer_c;
	static CCAgentBCSequencer _sequencer_bc_c;
	static CCAgentArbiter 	_arbiter_c;
	CCAgentDriver_Col 		driver_c; 

	PowerGatingBaseFSM		fab_fsm[string];
	PowerGatingBaseFSM		sip_fsm[string];
	//END col change

	PowerGatingParamConfig 	param_cfg;

	//=========================================================================
	// OVM Macros for public variables
	//=========================================================================
	`ovm_component_utils_begin(CCAgent)
		`ovm_field_enum(ovm_active_passive_enum, is_active, OVM_ALL_ON)
        `ovm_field_int(hasPrinter, OVM_ALL_ON | OVM_BIN)
	`ovm_component_utils_end

	//=========================================================================
	// PROTECTED VARIABLES
	//=========================================================================

	//=========================================================================
	// PRIVATE VARIABLES
	//=========================================================================
	local static CCCfgNamePair _cfgList[$];
	//=========================================================================
	// PUBLIC FUNCTIONS
	//=========================================================================

	static function void set_configuration(string scope, PowerGatingParamConfig cfg);
		CCCfgNamePair temp;
		temp = new();
		temp.cfg = cfg;
		temp.scope = scope;
		_cfgList.push_back(temp);
	endfunction

	/**************************************************************************
	*  @brief Constructor.
	**************************************************************************/
	function new(string name, ovm_component parent);
		super.new(name,parent);	
	endfunction: new
	/**************************************************************************
	*implement the virtual functions to get cfg 
	**************************************************************************/
	virtual function void get_cfg_info();
		ovm_object cfg_temp;		
		if (!get_config_object({get_name(), "ConfigObject"}, cfg_temp, 0)) begin
			string str;
			$sformat(str, "%s", get_name());
     		`ovm_fatal("CCAgent", {"PowerGatingConfig Configuration object", str,  "ConfigObject cannot found. The object name should be set to <agent name>ConfigObject."})	
		end
   		if (!($cast(cfg, cfg_temp)))
    	 `ovm_fatal("CCAgent", "Type mismatch while casting PowerGatingConfig object")
	endfunction

	/**************************************************************************
	*implement the virtual functions to get itnerface for phase 1
	**************************************************************************/

	virtual function void get_intf_p1();
		foreach(_cfgList[n]) begin
			if(ovm_is_match(_cfgList[n].scope, get_full_name())) begin
				param_cfg = _cfgList[n].cfg;
				break;
			end
		end
		if(param_cfg == null) begin
			//col change
			//phase 2
			_phase = PowerGating::PHASE_2;
			`ovm_info(get_full_name(), $psprintf("PowerGatingParamConfig Configuration object not found. Expected scope to match %s. But there was no configuration object set (using set_configuration method) with the scope from CCAgentTI. So the agent is configured with collage interface. ", get_full_name()), OVM_LOW)	
		end
		else begin
			//phase 1
			cfg.num_sip_pgcb = param_cfg.num_sip_pgcb ;
			cfg.num_fab_pgcb = param_cfg.num_fab_pgcb ;
			cfg.num_sw_req = param_cfg.num_sw_req ;
			cfg.num_pmc_wake = param_cfg.num_pmc_wake ;
			cfg.num_vnn_ack_req = param_cfg.num_vnn_ack_req ;
			cfg.num_sb_ep = param_cfg.num_sb_ep ;
			cfg.num_prim_ep = param_cfg.num_prim_ep ;
			cfg.no_fab = param_cfg.no_fab ;
			cfg.no_sip = param_cfg.no_sip ;
			cfg.num_d3 = param_cfg.num_d3 ;
			cfg.num_d0i3 = param_cfg.num_d0i3 ;
			IS_ACTIVE = param_cfg.is_active ;
			cfg.num_fet = param_cfg.num_fet ;

			cfg.bfm_drives_pok = param_cfg.bfm_drives_pok;
			cfg.bfm_drives_fet_en_ack = param_cfg.bfm_drives_fet_en_ack;
			_vif = param_cfg.pgIF;

			if (IS_ACTIVE == 1 && is_active != OVM_ACTIVE) begin
  				`ovm_warning(get_full_name(), "IS_ACTIVE in the test-island was set to 1 but CCAgent's is_active was not set to 1. Over-riding with IS_ACTIVE in the test-island")
 				is_active = OVM_ACTIVE;
			end
			else if(IS_ACTIVE == 0 && is_active == OVM_ACTIVE) begin
  				`ovm_warning(get_full_name(), "IS_ACTIVE in the test-island was set to 0 but CCAgent's is_active was not set to 0. Over-riding with IS_ACTIVE in the test-island")	
				is_active = OVM_PASSIVE;
			end
		end
		//END col change
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
			driver = CCAgentDriver::type_id::create({get_name(),"driver"},this);
			sequencer = CCAgentSequencer::type_id::create({get_name(),"sequencer"},this);
			cfg.arb_sem = new(1);	
		end
		else begin
			driver_c = CCAgentDriver_Col::type_id::create({get_name(),"driver_col"},this);
			if(_sequencer_c == null) begin
				_sequencer_c = CCAgentSequencer::type_id::create({get_name(),"sequencer"},this);
				_sequencer_bc_c = CCAgentBCSequencer::type_id::create({get_name(),"bc_sequencer"},this);
			end
			cfg.arb_sem_c = new(1);	

		end
		//END col change
		`ovm_info(get_full_name(), "Sequencer CREATED", OVM_HIGH)
		`ovm_info(get_full_name(), "Driver CREATED", OVM_HIGH)		
		responder = CCAgentResponder::type_id::create({get_name(),".Responder"},this);
		sip_responder = CCAgentSIPResponder::type_id::create({get_name(),".SIPResponder"},this);
		`ovm_info(get_full_name(), "Responder CREATED", OVM_HIGH)
		//col change
		if(_phase == PowerGating::PHASE_1)  begin	
			arbiter = CCAgentArbiter::type_id::create({get_name(),".Arbiter"},this);
		end
		else begin
			if(_arbiter_c == null) _arbiter_c = CCAgentArbiter::type_id::create({get_name(),".Arbiter"},this);

		end
		//END col change		
		`ovm_info(get_full_name(), "Arbiter CREATED", OVM_HIGH)
	
	endfunction: buildActiveComponents

	/**************************************************************************
	*  @brief : builds all active components (e.g. sequencer to driver, responder to driver/sequencer)
	**************************************************************************/
	protected virtual function void connectActiveComponents();
		//col change
		if(_phase == PowerGating::PHASE_1) begin	
			driver.seq_item_port.connect(sequencer.seq_item_export);
			`ovm_info(get_full_name(), "Driver and Sequencer CONNECTED", OVM_HIGH)
			driver.setVIF(_vif);	
			`ovm_info(get_full_name(), "Interface passed into driver", OVM_HIGH)
			driver.setCfg(cfg);
	
			//END col change
			if(cfg.no_fab === 0) begin
				for(int n = 0; n < cfg.num_fab_pgcb; n++) begin
					CCAgentFabricFSM fabricFSM_temp;
					//PowerGatingBaseFSM fabricFSM_temp;
					//assert($cast(fabricFSM_temp, create_component("CCAgentFabricFSM", {n, "fabFSM_col"})));
					fabricFSM_temp = new({get_name(), cfg.cfg_fab_pgcb[n].name, "Fab"}, this);
					fabricFSM_temp.ap.connect(responder.monitor_i.analysis_export);
					fabricFSM_temp.setVIF(_vif);	
					fabricFSM_temp.setSource(n);	
					fabricFSM_temp.setCfg(cfg);
					fabricFSM[n] = fabricFSM_temp;
				end
			end
			if(cfg.no_sip === 0) begin
				for(int n = 0; n < cfg.num_sip_pgcb; n++) begin
					CCAgentSIPFSM sipFSM_temp;
					//PowerGatingBaseFSM sipFSM_temp;
					//assert($cast(sipFSM_temp, create_component("CCAgentSIPFSM", {n, "sipFSM_col"})));
					sipFSM_temp = new({get_name(), cfg.cfg_sip_pgcb[n].name, "SIP"}, this);
					sipFSM_temp.ap.connect(sip_responder.monitor_i.analysis_export);
					sipFSM_temp.setVIF(_vif);	
					sipFSM_temp.setSource(n);	
					sipFSM_temp.setCfg(cfg);
					sipFSM[n] = sipFSM_temp;
				end
			end
			arbiter.setTargetSequencer(sequencer);	
			arbiter.setCfg(cfg);
			arbiter.setVIF(_vif);		
			sip_responder.ap.connect(arbiter.monitor_i);
			responder.ap.connect(arbiter.monitor_i);			
			responder.setTargetSequencer(sequencer);
			sip_responder.setTargetSequencer(sequencer);				
		end
		else if(_phase == PowerGating::PHASE_2) begin
			//connect to boardcast port since sequencer is static

			_sequencer_bc_c.seq_item_port.connect(_sequencer_c.seq_item_export);
			`ovm_info(get_full_name(), "Sequencer BC and Sequencer CONNECTED", OVM_HIGH)
			_sequencer_bc_c.ap.connect(driver_c.analysis_export.analysis_export);
			`ovm_info(get_full_name(), "Driver and Sequencer BC CONNECTED", OVM_HIGH)

			driver_c.setVIF(_vif);	
			`ovm_info(get_full_name(), "Interface passed into driver", OVM_HIGH)
			driver_c.setCfg(cfg);
			driver_c.set_intf(reset_if, sip_if, fab_if);
			driver_c.set_static_intf(sip_if_all);	
			
			//col change
			foreach(cfg.cfg_sip_pgcb_n[n]) begin
				assert($cast(sip_fsm[n], create_component("CCAgentSIPFSM_Col", {n, "sipFSM_col"})));
				sip_fsm[n].ap.connect(sip_responder.monitor_i.analysis_export);
				sip_fsm[n].set_sip_intf(sip_if[n]);
				//sip_fsm[n].set_fet_intf(fet_if[cfg.cfg_sip_pgcb_n[n].fet_name]);
				sip_fsm[n].setSource(cfg.sip_index[n]);
				sip_fsm[n].name = n;
				sip_fsm[n].setVIF(_vif);	
				sip_fsm[n].setCfg(cfg);
			end
			foreach(cfg.cfg_fab_pgcb_n[n]) begin
				assert($cast(fab_fsm[n], create_component("CCAgentFabricFSM_Col", {n, "fabFSM_col"})));
				fab_fsm[n].ap.connect(responder.monitor_i.analysis_export);
				fab_fsm[n].set_fab_intf(fab_if[n]);
				fab_fsm[n].set_sip_intf(sip_if[cfg.sip_belongs_to_fabric[n]]);
				fab_fsm[n].setSource(cfg.fab_index[n]);
				fab_fsm[n].name = n;
				fab_fsm[n].setVIF(_vif);	
				fab_fsm[n].setCfg(cfg);
			end		
			_arbiter_c.setTargetSequencer(_sequencer_c);	
			_arbiter_c.setCfg(cfg);
			_arbiter_c.setResetVIF(reset_if);		
			sip_responder.ap.connect(_arbiter_c.monitor_i);
			responder.ap.connect(_arbiter_c.monitor_i);			
			responder.setTargetSequencer(_sequencer_c);
			sip_responder.setTargetSequencer(_sequencer_c);					
			//END col change
		end	

	endfunction: connectActiveComponents

endclass : CCAgent
