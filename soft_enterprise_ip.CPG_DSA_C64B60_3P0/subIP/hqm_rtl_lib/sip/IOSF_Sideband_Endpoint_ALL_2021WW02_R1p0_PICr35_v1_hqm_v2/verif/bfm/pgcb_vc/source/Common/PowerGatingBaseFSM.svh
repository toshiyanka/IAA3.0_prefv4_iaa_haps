class PowerGatingBaseFSM extends ovm_component;

	PowerGating::MonitorState state;
	virtual PowerGatingNoParamIF vif;
	int i;
	PowerGatingMonitorSeqItem x;
	PowerGatingConfig cfg;

	//col change
	string name;
	virtual PowerGatingSIPIF sip_if;
	virtual PowerGatingFabricIF fab_if;
	//END col change	

	//analysis port that sends to the responder
	ovm_analysis_port #(PowerGatingMonitorSeqItem) ap;

	`ovm_component_utils(PowerGatingBaseFSM)
	function new(string name = "", ovm_component parent);
		super.new(name, parent);
		x = new({name, "sipState"});
		ap = new({name, "sipFSM_ap"}, this);		
	endfunction

	function setVIF(virtual PowerGatingNoParamIF vif_arg);
		vif = vif_arg;
	endfunction: setVIF

	function setCfg(PowerGatingConfig cfg_arg);
		cfg = cfg_arg;
	endfunction: setCfg

	function setSource(int source);
		i = source;
	endfunction: setSource

	//col change
	function set_sip_intf(virtual PowerGatingSIPIF sip);
		sip_if = sip;
	endfunction
	
	function set_fab_intf(virtual PowerGatingFabricIF fab);
		fab_if = fab;
	endfunction	
	//END col change

	function PowerGating::MonitorState getCurrentState();
		return state;
	endfunction: getCurrentState		
endclass: PowerGatingBaseFSM	
