class PowerGatingParamConfig;
	int num_sip_pgcb;
	int num_fab_pgcb;
	int num_sw_req;
	int num_pmc_wake;
	int num_vnn_ack_req;
	int num_sb_ep;
	int num_prim_ep;
	bit no_fab;
	bit no_sip;
	int num_d3;
	int num_d0i3;
	bit is_active;
	int num_fet;
	string interface_name;
	bit bfm_drives_pok;
	bit	bfm_drives_fet_en_ack;
	
	virtual PowerGatingNoParamIF pgIF;

endclass: PowerGatingParamConfig


