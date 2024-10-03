//=========================================================================
// Private interface container classes
//=========================================================================
//col changes
class PowerGatingResetIFContainer;
	string 						scope;
	virtual PowerGatingResetIF 	intf;
endclass
class PowerGatingSIPIFContainer;
	string 						scope;
	string 						name;
	bit							is_active;
	int							num_side;
	int							num_prim;
	int							num_d3;
	int							num_d0i3;	
	//int 						index;
	string 						fet_name;
	string 						fabric_name;
	virtual PowerGatingSIPIF 	intf;
endclass

class PowerGatingFabricIFContainer;
	string 						scope;
	string 						name;
	virtual PowerGatingFabricIF 	intf;
endclass

//END col change
class PowerGatingBaseAgent extends ovm_agent;
	//=========================================================================
	// PUBLIC VARIABLES
	//=========================================================================

	ovm_active_passive_enum 	is_active;
	bit 						hasPrinter;
	bit 						IS_ACTIVE;							//TODO: need to have an is_active per interface
	string 						interfaceName;
	PowerGatingMonitor 			monitor;                             // ptr to this agents monitor
	PowerGatingPrinter 			printer;                             // ptr to this agents printer
	PowerGatingConfig 			cfg;
	PowerGatingSIPFSM 			sipMonFSM[$];
	PowerGatingFabricFSM 		fabricMonFSM[$];
	PowerGatingMainSIPFSM 		sipMainFSM[$];

	ovm_analysis_port #(PowerGatingMonitorSeqItem) monitorAnalysisPort;
	//=========================================================================
	// PROTECTED VARIABLES
	//=========================================================================
	protected virtual PowerGatingNoParamIF 	_vif;       // ptr to the virtual interface
	//Col change
	PowerGating::Phase						_phase = PowerGating::PHASE_1;
	protected virtual PowerGatingResetIF	reset_if;

	protected virtual PowerGatingSIPIF		sip_if[string];
	static virtual PowerGatingSIPIF			sip_if_all[string];
	protected virtual PowerGatingFabricIF	fab_if[string];

	static PowerGatingResetIFContainer 		_resetIFList[$];	
	static PowerGatingSIPIFContainer 		_SIPIFList[$];
	static PowerGatingFabricIFContainer 	_FabIFList[$];	
	PowerGatingSIPFSM_Col 					sipMonFSM_c[string];
	PowerGatingFabricFSM_Col 				fabricMonFSM_c[string];
	//PowerGatingMainSIPFSM_Col 			sipMainFSM_c[string];
	PowerGatingMonitor_Col 					monitor_c;                           // ptr to this agents monitor
	//END Col change	
	//=========================================================================
	// OVM Macros for public variables
	//=========================================================================
	//Below exports the is_active variable as a configurable variable
	`ovm_component_utils_begin(PowerGatingBaseAgent)
		`ovm_field_enum(ovm_active_passive_enum, is_active, OVM_ALL_ON)
        `ovm_field_int(hasPrinter, OVM_ALL_ON | OVM_BIN)
	`ovm_component_utils_end
	
	/**************************************************************************
	*  @brief Constructor.
	**************************************************************************/
	function new(string name, ovm_component parent);
		super.new(name,parent);	
	endfunction: new
	/**************************************************************************
	*  @brief Build.
	**************************************************************************/
	virtual function void build();	
		super.build();

		//get all the configuration and interfaces and set the phase
		getConfigAndIntf();

		//PassiveComponents are things like Monitors or Coverage.
		buildPassiveComponents();		
		//ActiveComponents are things like Sequencer,Driver,Responder
		if (is_active == OVM_ACTIVE) begin
			buildActiveComponents();
		end
		//PrintComponents are things like Printer,Formatter,Spooler
		if (hasPrinter == SLA_TRUE) begin
			buildPrintComponents();
		end
		`ovm_info(get_full_name(), "Finished building.", OVM_HIGH)		
	endfunction : build
	/**************************************************************************
	*  @brief Connect.
	**************************************************************************/
	virtual function void connect();
		super.connect();

		//PassiveComponents are things like Monitors or Coverage.
		connectPassiveComponents();

		//ActiveComponents are things like Sequencer,Driver,Responder
		if (is_active == OVM_ACTIVE) begin
			connectActiveComponents();
		end

		//PrintComponents are things like Printer,Formatter,Spooler
		if (hasPrinter == SLA_TRUE) begin
			connectPrintComponents();
		end
		`ovm_info(get_full_name(), "Finished connecting.", OVM_HIGH)
		
	endfunction : connect

	//=========================================================================
	// PUBLIC FUNCTIONS
	//=========================================================================
	//col change
	static function void set_reset_if(PowerGatingResetIFContainer cfg);
		_resetIFList.push_back(cfg);
	endfunction	

	static function void set_sip_if(PowerGatingSIPIFContainer cfg);
		_SIPIFList.push_back(cfg);
	endfunction	
	static function void set_fab_if(PowerGatingFabricIFContainer cfg);
		_FabIFList.push_back(cfg);
	endfunction		
	//END col change
	function PowerGatingConfig getConfig();
		return(cfg);
	endfunction: getConfig	

	//=========================================================================
	// PROTECTED FUNCTIONS
	//=========================================================================
	/**************************************************************************
	*  @brief : builds all passive components (e.g. monitor, coverage)
	**************************************************************************/
	protected virtual function void buildPassiveComponents();
	   	monitorAnalysisPort = new({get_name(), "analysisPort"}, this);
		if(_phase == PowerGating::PHASE_1) 
			monitor = PowerGatingMonitor::type_id::create({get_name(), "monitor"},this);
		else if(_phase == PowerGating::PHASE_2)
			monitor_c = PowerGatingMonitor_Col::type_id::create({get_name(), "monitor_col"},this);

		`ovm_info(get_full_name(), "Monitor CREATED", OVM_HIGH)
	endfunction: buildPassiveComponents
	/**************************************************************************
	*  @brief : builds all active components 
	**************************************************************************/
	protected virtual function void buildActiveComponents();

	endfunction: buildActiveComponents
	/**************************************************************************
	*  @brief : builds all components necessary for printing capabilties (e.g. printers, formatters, spoolers)
	**************************************************************************/
	protected virtual function void buildPrintComponents();
		printer = PowerGatingPrinter::type_id::create( {get_name(), "printer"}, this); 
		`ovm_info(get_full_name(), "Printer CREATED", OVM_HIGH)
	endfunction: buildPrintComponents
	/**************************************************************************
	*  @brief : connects all passive components (e.g. monitor to Agent's port)
	**************************************************************************/
	protected virtual function void connectPassiveComponents();
		if(_phase == PowerGating::PHASE_1) begin
		if(cfg.no_fab === 0) begin
		for(int n = 0; n < cfg.num_fab_pgcb; n ++) begin
			PowerGatingFabricFSM fabricMonFSM_temp;
			fabricMonFSM_temp = new({get_name(), cfg.cfg_fab_pgcb[n].name, "FabMon"}, this);
			fabricMonFSM_temp.setVIF(_vif);	
			fabricMonFSM_temp.setSource(n);	
			fabricMonFSM_temp.setCfg(cfg);
			fabricMonFSM_temp.ap.connect(monitorAnalysisPort);
			fabricMonFSM[n] = fabricMonFSM_temp;
		end
		end
		if(cfg.no_sip === 0) begin
		for(int n = 0; n < cfg.num_sip_pgcb; n ++) begin
			PowerGatingSIPFSM sipMonFSM_temp;
			sipMonFSM_temp = new({get_name(), cfg.cfg_sip_pgcb[n].name, "Mon"}, this);			
			sipMonFSM_temp.setVIF(_vif);	
			sipMonFSM_temp.setSource(n);	
			sipMonFSM_temp.setCfg(cfg);
			sipMonFSM_temp.ap.connect(monitorAnalysisPort);
			sipMonFSM[n] = sipMonFSM_temp;
		end
		for(int n = 0; n < cfg.cfg_sip.size(); n ++) begin
			PowerGatingMainSIPFSM sipMainFSM_temp;
			sipMainFSM_temp = new({get_name(), cfg.cfg_sip[n].name, "SIPMon"}, this);			
			sipMainFSM_temp.setVIF(_vif);	
			sipMainFSM_temp.setSource(n);	
			sipMainFSM_temp.setCfg(cfg);
			sipMainFSM_temp.ap.connect(monitorAnalysisPort);
			sipMainFSM[n] = sipMainFSM_temp;
		end		
		end
		monitor.analysisPort.connect(monitorAnalysisPort);	
		monitor.setVIF(_vif);			
		monitor.setCfg(cfg);		
		end
		//col change
		else if(_phase == PowerGating::PHASE_2) begin
			foreach(cfg.cfg_sip_pgcb_n[n]) begin
				assert($cast(sipMonFSM_c[n], create_component("PowerGatingSIPFSM_Col", {n, "sipMonFSM_col"})));
				sipMonFSM_c[n].name = n;			
				sipMonFSM_c[n].setSource(cfg.sip_index[n]);
				sipMonFSM_c[n].set_sip_intf(sip_if[n]);
				//sipMonFSM_c[n].set_fet_intf(fet_if[cfg.cfg_sip_pgcb_n[n].fet_name]);
				sipMonFSM_c[n].set_fab_intf(fab_if[cfg.cfg_sip_pgcb_n[n].fabric_name]);
				sipMonFSM_c[n].setVIF(_vif);	
				sipMonFSM_c[n].setCfg(cfg);
				sipMonFSM_c[n].ap.connect(monitorAnalysisPort);		
			end
			foreach(cfg.cfg_fab_pgcb_n[n]) begin
				assert($cast(fabricMonFSM_c[n], create_component("PowerGatingFabricFSM_Col", {n, "fanMonFSM_col_col"})));
				fabricMonFSM_c[n].set_fab_intf(fab_if[n]);
				fabricMonFSM_c[n].set_sip_intf(sip_if[cfg.sip_belongs_to_fabric[n]]);
				fabricMonFSM_c[n].setSource(cfg.fab_index[n]);
				fabricMonFSM_c[n].name = n;
				fabricMonFSM_c[n].setVIF(_vif);	
				fabricMonFSM_c[n].setCfg(cfg);
				fabricMonFSM_c[n].ap.connect(monitorAnalysisPort);		
			end			
			//TODO: add AON FSM here
			monitor_c.analysisPort.connect(monitorAnalysisPort);	
			monitor_c.set_sip_intf(sip_if);	
			//monitor_c.set_fet_intf(fet_if);		
			monitor_c.setResetVIF(reset_if);
			monitor_c.setCfg(cfg);			
		end
		//END col change		
	endfunction: connectPassiveComponents
	/**************************************************************************
	*  @brief : builds all active components (e.g. sequencer to driver, responder to driver/sequencer)
	**************************************************************************/
	protected virtual function void connectActiveComponents();
	endfunction: connectActiveComponents
	/**************************************************************************
	*  @brief : builds all components necessary for printing capabilties (e.g. monitor to formatter to printer)
	**************************************************************************/
	protected virtual function void connectPrintComponents();
		if(_phase == PowerGating::PHASE_1) 	
			monitor.analysisPort.connect(printer.printQueue.analysis_export);
		else
			monitor_c.analysisPort.connect(printer.printQueue.analysis_export);

		if(_phase == PowerGating::PHASE_1) begin
			foreach(sipMonFSM[n]) begin
				sipMonFSM[n].ap.connect(printer.printQueue.analysis_export);
			end
			foreach(fabricMonFSM[n]) begin
				fabricMonFSM[n].ap.connect(printer.printQueue.analysis_export);
			end
			foreach(sipMainFSM[n]) begin
				sipMainFSM[n].ap.connect(printer.printQueue.analysis_export);
				//send change of PGCB state back to the FSM to aggregate
				monitorAnalysisPort.connect(sipMainFSM[n].fifo.analysis_export);
				sipMainFSM[n].setSIPFSM(sipMonFSM);
			end		
   		end
		else if(_phase == PowerGating::PHASE_2) begin
			foreach(sipMonFSM_c[n]) begin
				sipMonFSM_c[n].ap.connect(printer.printQueue.analysis_export);
			end
			foreach(fabricMonFSM_c[n]) begin
				fabricMonFSM_c[n].ap.connect(printer.printQueue.analysis_export);
			end
		end
		`ovm_info(get_full_name(), "Monitor analysis port and Printer analysis export CONNECTED", OVM_HIGH)
		printer.setCfg(cfg);
		printer.setTrackerName(cfg.tracker_name);
		printer.setSIPFSM(sipMonFSM);
		printer.setFabFSM(fabricMonFSM);
	endfunction: connectPrintComponents

	/**************************************************************************
	*  @brief : get the new interfaces
	**************************************************************************/
	//col changes
	function get_intf_p2();
		//get reset interface
		foreach(_resetIFList[n]) begin
			if(ovm_is_match(_resetIFList[n].scope, get_full_name())) begin
				reset_if = _resetIFList[n].intf;
			end
		end
		//get sip interface
		foreach(_SIPIFList[n]) begin
			if(ovm_is_match(_SIPIFList[n].scope, get_full_name())) begin
				
				if(sip_if[_SIPIFList[n].name] != null) begin
					`ovm_fatal(get_full_name(), $psprintf("PowerGatingSIPIF with NAME = '%s' has already been instantiated multiple time for this instance of the agent", _SIPIFList[n].name))
				end
				else begin
					sip_if[_SIPIFList[n].name] = _SIPIFList[n].intf;
					//configure the fet and fabric name
					cfg.set_fet_fab_name(.name(_SIPIFList[n].name), 
									.fet_name(_SIPIFList[n].fet_name), 
									.fabric_name(_SIPIFList[n].fabric_name),
									.num_side(_SIPIFList[n].num_side),
									.num_prim(_SIPIFList[n].num_prim),
									.num_d3(_SIPIFList[n].num_d3),
									.num_d0i3(_SIPIFList[n].num_d0i3));
				end
				if(is_active == OVM_ACTIVE) begin
					if(sip_if_all[_SIPIFList[n].name] != null) begin
						//TODO: add compile directive and uncomment this
						//`ovm_error(get_full_name(), $psprintf("PowerGatingSIPIF (sip_if_all) with NAME = '%s' has already been instantiated multiple time for this instance of the agent", _SIPIFList[n].name))
					end
					else
						sip_if_all[_SIPIFList[n].name] = _SIPIFList[n].intf;
				end
			end
		end
		if(sip_if.size() != cfg.cfg_sip_pgcb_n.size()) begin
			`ovm_fatal(get_full_name(), $psprintf("Could not find all PowerGatingSIPIF. User configured %d SIP PGCB using AddSIPPGCB and instantiated %d PowerGatingSIPIF in the test-island", cfg.cfg_sip_pgcb_n.size(), sip_if.size()))
		end

		//get fabric interface
		foreach(_FabIFList[n]) begin
			if(ovm_is_match(_FabIFList[n].scope, get_full_name())) begin
				if(fab_if[_FabIFList[n].name] != null) begin
					`ovm_fatal(get_full_name(), $psprintf("PowerGatingFabricIF with NAME = '%s' has already been instantiated multiple time for this instance of the agent", _FabIFList[n].name))
				end
				else begin
					fab_if[_FabIFList[n].name] = _FabIFList[n].intf;
				end
			end
		end
		//TODO: get is_active information per interface

		if(sip_if.size() == 0 && fab_if.size == 0)
			`ovm_fatal(get_full_name(), "No interfaces was found by power gating agent")
	endfunction
	//END col changes

	protected virtual function void get_cfg_info(); 
	endfunction
	protected virtual function void get_intf_p1(); 
	endfunction

	protected virtual function void getConfigAndIntf(); 
		get_cfg_info();
		get_intf_p1();
		//col change
		if(_phase == PowerGating::PHASE_2) 
			get_intf_p2();

		//set the phase
		cfg.phase = _phase;
		//END col change		
	endfunction : getConfigAndIntf
	
endclass: PowerGatingBaseAgent

