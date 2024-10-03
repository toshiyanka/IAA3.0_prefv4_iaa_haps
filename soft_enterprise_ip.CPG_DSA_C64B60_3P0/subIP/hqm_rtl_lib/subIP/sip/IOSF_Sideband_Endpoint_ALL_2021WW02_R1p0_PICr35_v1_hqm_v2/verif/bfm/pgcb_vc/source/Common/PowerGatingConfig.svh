class PowerGatingConfig extends ovm_object;

	int num_sip_pgcb;
	int num_fab_pgcb;
	int num_fet;
	int num_sw_req;
	int num_pmc_wake;
	int num_vnn_ack_req;
	int num_sb_ep;
	int num_prim_ep;
	bit no_fab;
	bit no_sip;
	bit bfm_drives_pok;
	bit	bfm_drives_fet_en_ack;

	int num_d3;
	int num_d0i3;

	bit disable_config = 1;
	bit disable_fet_gate_check = 0;
	bit disable_fet_ungate_check = 0;
	bit disable_all_checks = 0;
	
	bit disable_eot_check;

	bit random_priority_mode;
	bit[MAX_FET-1:0] fetONMode;
	bit[MAX_FET-1:0] fetONMode_prev;
	bit fetONMode_n[string];
	bit fetONMode_n_prev[string];
	string test_island_name;

	PowerGatingSIPPGCBConfig cfg_sip_pgcb[$];
	PowerGatingFabricConfig cfg_fab_pgcb[$];
	PowerGatingSIPConfig cfg_sip[$];

	PowerGatingBaseConfig 	cfg_fet[$];
	PowerGatingBaseConfig	cfg_pmc_wake[int];

	PowerGatingBaseConfig	cfg_vnn_ack[int];
	PowerGatingBaseConfig	cfg_vnn_req[int];

	PowerGatingEPConfig	cfg_side_ep[$];	
	PowerGatingEPConfig	cfg_prim_ep[$];

	PowerGatingSIPConfig cfg_pmc_wake_aon[int]; //reusing the SIP config here

	string tracker_name = "PG_TRACKER";

	string sip_name_pmc_wake[int];
	string sip_name_vnn_ack[int];
	string sip_name_vnn_req[int];
	string sip_name_sb_ep[int];
	string sip_name_prim_ep[int];
	string sip_name_d3[int];
	string sip_name_d0i3[int];
	int sip_belongs_to_fabric[int];

	semaphore arb_sem;
	static semaphore arb_sem_c;
	//col change
	static int 						num_pmc_wake_n;
	static int 						num_vnn_ack;
	static int 						num_vnn_req;
	static int 						num_side_n;
	static int 						num_prim_n;
	static int 						num_fet_n;


	PowerGating::Phase				phase;
	PowerGatingSIPPGCBConfig 		cfg_sip_pgcb_n[string];
	PowerGatingFabricConfig 		cfg_fab_pgcb_n[string];
	PowerGatingSIPConfig 			cfg_sip_n[string];
	//PowerGatingSIPPGCBConfig 	cfg_aon_n[string];
	string 							sip_belongs_to_fabric_n[string];
	PowerGatingBaseConfig 			cfg_fet_n[string];
	static PowerGatingBaseConfig 	cfg_fet_n_all[string];
	static PowerGatingSIPPGCBConfig cfg_sip_pgcb_n_all[string];	
	//this is for backward compatibility
	static int							sip_index[string];
	static int							fab_index[string];
	static int							fet_index[string];
	static string						sip_name[int];
	static string						fab_name[int];
	static string						pmc_wake_name[int];
	static string						side_pok_name[int];
	static string						vnn_ack_name[int];
	static string						vnn_req_name[int];
	
	static PowerGatingSIPPGCBConfig 	cfg_sip_pgcb_all[$];	
	static PowerGatingSIPConfig 		cfg_sip_all[$];

	static PowerGatingEPConfig			cfg_side_ep_all[$];	
	static PowerGatingEPConfig			cfg_prim_ep_all[$];
	//END this is for backward compatibility
	//END col change

   `ovm_object_utils_begin(PowerGatingConfig)
   		`ovm_field_int(disable_eot_check, OVM_ALL_ON)
   `ovm_object_utils_end

	function new(string name = "");        
		int i;
 		super.new(name);
		if(ovm_top.get_config_int("disable_eot_check", i)) begin
			disable_eot_check = i;
		end
	endfunction

	function getSIPPGCBConfig(output PowerGatingSIPPGCBConfig cfgSIPPGCB[]);
		cfgSIPPGCB = cfg_sip_pgcb;
	endfunction: getSIPPGCBConfig

	function getFabricPGCBConfig(output PowerGatingFabricConfig cfgFabPGCB[]);
		cfgFabPGCB = cfg_fab_pgcb;
	endfunction

	function getSIPConfig(output PowerGatingSIPConfig cfgSIP[]);
		cfgSIP = cfg_sip;
	endfunction

	function SetTestIslandName(string str);
		test_island_name = str;
	endfunction

	function SetNumSIP(int num);
		num_sip_pgcb = num;
	endfunction

	function SetNumFab(int num);
		num_fab_pgcb = num;
	endfunction
	
	function SetNoSIP(int num);
		no_sip = num;
	endfunction

	function SetNoFab(int num);
		no_fab = num;
	endfunction

	function SetNumFET(int num);
		num_fet = num;
	endfunction

	function SetRandomPriorityMode();
		random_priority_mode = 1;
	endfunction
	
	function bit GetRandomPriorityMode();
		return random_priority_mode;
	endfunction

	function SetTrackerName(string name);
		tracker_name = name;
	endfunction

	function DisableConfigPrinting();
		disable_config = 1;
	endfunction

	function EnableConfigPrinting();
		disable_config = 0;
	endfunction

	function DisableFetGateCheck();
		disable_fet_gate_check = 1;
	endfunction
	function DisableFetUnGateCheck();
		disable_fet_ungate_check = 1;
	endfunction

	function AddSIPPGCB(
		int index = -1, 
		string name, 
		PowerGating::InitialState initial_state = PowerGating::POWER_GATED, 
		int fet_index = -1, 
		int sip_index = -1, //deprecated
		int ungate_priority = 0, 
		int sw_ent_index = -1, 
		bit ignore_sw_req = 0, 
		int pmc_wake_index = -1, 
		int SB_array[] = {}, 
		int prim_array[] = {},
		int fabric_index = -1,
		bit	initial_restore_asserted = 0,
		//col change
		logic[7:0] fabric_name = "",
		logic[7:0] side_pid[] = {}
		//END col change
	);
		PowerGatingSIPPGCBConfig cfg_temp;
		//TODO: make sure that the num does not already exist
		cfg_temp = PowerGatingSIPPGCBConfig::type_id::create();
		cfg_temp.index = index;
		cfg_temp.name = name;
		cfg_temp.initial_state = initial_state;
		cfg_temp.ungate_priority = ungate_priority;
		cfg_temp.ignore_sw_req = ignore_sw_req;
		cfg_temp.initial_restore_asserted = initial_restore_asserted;
		cfg_temp.fet_index = fet_index;

		//col change
		//CASE 1 - phase 1. fet is specified and index is specified
		if(fet_index != -1 && index != -1) begin
		//END col change			
			cfg_temp.fet_name = cfg_fet[fet_index].name;
			cfg_temp.sw_ent_index = sw_ent_index;
			cfg_temp.pmc_wake_index = pmc_wake_index;
	
			cfg_temp.SB_index = SB_array;
			cfg_temp.prim_index = prim_array;
			cfg_temp.fabric_index = fabric_index;
			cfg_sip_pgcb[index] = cfg_temp;
	
			sip_name_pmc_wake[pmc_wake_index] = name;
			foreach(SB_array[n]) begin
				sip_name_sb_ep[SB_array[n]] = name;
			end
			foreach(prim_array[n]) begin
				sip_name_prim_ep[prim_array[n]] = name;
			end
		
			if(fet_index != -1) begin
				if(cfg_fet[fet_index] == null)
				`ovm_error(get_full_name(), "First use the AddFetBlock method to add a fet block before adding a PGCB");
			end
			if(fet_index != -1) begin
				cfg_fet[fet_index].pgcb_index.push_front(index);
			end
	
			//PMC WAKE
			if(pmc_wake_index != -1) begin
				if(cfg_pmc_wake[pmc_wake_index] == null) begin
					//create it
					PowerGatingBaseConfig cfg_temp;
					cfg_temp = PowerGatingBaseConfig::type_id::create();
					cfg_pmc_wake[pmc_wake_index] = cfg_temp;
				end
				//add to it
				cfg_pmc_wake[pmc_wake_index].pgcb_index.push_front(index);
			end
	
			//FABRIC and SIP mapping
			//check if does not already exist
			if(sip_belongs_to_fabric.exists(fabric_index) && fabric_index != -1) begin
				`ovm_error(get_full_name(), "User has added a SIP PGCB and specified a fabric_index that has already been assigned. Only one SIP interface can belong to a fabric");
			end
			else begin
				sip_belongs_to_fabric[fabric_index] = index;
			end
		end

		//col change
		//CASE 2 -  phase 2: fet is not specified and index is -1
		else if(fet_index == -1 && index == -1) begin
			cfg_temp.side_pid = side_pid;
			cfg_sip_pgcb_n[name] = cfg_temp;

			//this is for backward compatibility
			num_pmc_wake_n++;
			cfg_temp.pmc_wake_index = num_pmc_wake_n;
			cfg_sip_pgcb_all.push_front(cfg_temp);
			//TODO: check there are no duplicates
			this.sip_index[name] = cfg_sip_pgcb_all.size() - 1;
			sip_name[cfg_sip_pgcb_all.size() - 1] = name;
			//END this is for backward compatibility			
	
			//sip_name_pmc_wake[pmc_wake_index] = name;
			//foreach(SB_array[n]) begin
			//	sip_name_sb_ep[SB_array[n]] = name;
			//end
			//foreach(prim_array[n]) begin
			//	sip_name_prim_ep[prim_array[n]] = name;
			//end
		
			//TODO: add this back. This may notbe needed since there is no sharing of pmc_wake anymore
			//PMC WAKE
			//if(pmc_wake_index != -1) begin
			//	if(cfg_pmc_wake[pmc_wake_index] == null) begin
			//		//create it
			//		PowerGatingBaseConfig cfg_temp;
			//		cfg_temp = PowerGatingBaseConfig::type_id::create();
			//		cfg_pmc_wake[pmc_wake_index] = cfg_temp;
			//	end
			//	//add to it
			//	cfg_pmc_wake[pmc_wake_index].pgcb_index.push_front(index);
			//end

		end		
		//CASE 3 - phase 2 with backward compatibility mode: fet is not specified and index is not -1		
		else if(fet_index == -1 && index != -1) begin
			//TODO: backward compatibility of the configuration!!
		end
		else
			`ovm_fatal(get_full_name(), "User has specified illegal combination of fet_index and index");
		//END col change			
	endfunction


	//col change
	function set_fet_fab_name(string name, string fet_name, string fabric_name, int num_side, int num_prim, int num_d3, int num_d0i3, bit AON = 0);
		if(AON == 0) begin
			if(cfg_fet_n[fet_name] == null) begin
				cfg_fet_n[fet_name] = new();
				fet_index[fet_name] = num_fet_n;
				num_fet_n++;
			end
			cfg_fet_n[fet_name].pgcb_name.push_front(name);		
			if(cfg_fet_n_all[fet_name] == null) begin
				cfg_fet_n_all[fet_name] = new();
			end
			cfg_fet_n_all[fet_name].pgcb_name.push_front(name);		
			
			if(cfg_sip_pgcb_n[name] == null) begin
				`ovm_error(get_full_name(), $psprintf("User instantiated an SIP PGCB interface with name %s but did not configure that SIP PGCB", name));		
			end
			else begin
				cfg_sip_pgcb_n[name].fet_name = fet_name;
				cfg_sip_pgcb_n[name].fabric_name = fabric_name;	
				cfg_sip_pgcb_n[name].num_side = num_side;
				cfg_sip_pgcb_n[name].num_prim = num_prim;
				cfg_sip_pgcb_n[name].num_d3 = num_d3;
				cfg_sip_pgcb_n[name].num_d0i3 = num_d0i3;
				//set the static hash
				cfg_sip_pgcb_n_all[name] = cfg_sip_pgcb_n[name];				
			end

			if(sip_belongs_to_fabric_n.exists(fabric_name) && fabric_name != "") begin
				`ovm_error(get_full_name(), "User has added a SIP PGCB and specified a fabric_name that has already been assigned. Only one SIP interface can belong to a fabric");
			end
			else begin
				sip_belongs_to_fabric_n[fabric_name] = name;
			end		
		end


			//check NUM_SIDE equal to size of these ararys. Have to do in the agent
			if(num_side != cfg_sip_pgcb_n[name].side_pid.size()) begin
				`ovm_fatal(get_full_name(), $psprintf("User specified NUM_SIDE parameter in the TI = %d for IP %s. But the side_pid array size is not equal to NUM_SIDE parameter", num_side, name));		
			end

			//this is for backward compatibility
			for(int k = 0; k < cfg_sip_pgcb_n[name].side_pid.size(); k++) begin
				for(int i = 0; i < cfg_side_ep_all.size(); i++) begin
					if(cfg_side_ep_all[i].source_id == cfg_sip_pgcb_n[name].side_pid[k]) begin
						cfg_sip_pgcb_all[this.sip_index[name]].SB_index[k] = i;
					end
				end
			end
			/*for(int k = 0; k < num_side; k++) begin				
				cfg_sip_pgcb_all[this.sip_index[name]].SB_index[k] = num_side_n;
				cfg_side_ep_all[num_side_n] = get_ep_config(
												.index(num_side_n), 
												.AON_EP(AON), 
												.pmc_wake_index(-1), 
												.source_id(cfg_sip_pgcb_n[name].side_pid[k]));
				
				sip_name_sb_ep[num_side_n] = name;
				num_side_n++;
			end
			for(int k = 0; k < num_prim; k++) begin
				cfg_sip_pgcb_all[this.sip_index[name]].prim_index[k] = num_prim_n;
				cfg_prim_ep_all[num_prim_n] = get_ep_config(
												.index(num_prim_n), 
												.AON_EP(AON), 
												.pmc_wake_index(-1), 
												.source_id('h00));	
				sip_name_prim_ep[num_prim_n] = name;
				num_prim_n++;
			end
			*/
			//END this is for backward compatibility

	endfunction
	//END col change


	function AddFETBlock(int index, string name);
		PowerGatingBaseConfig cfg_temp;
		cfg_temp = PowerGatingBaseConfig::type_id::create();
		cfg_temp.index = index;
		cfg_temp.name = name;
		cfg_fet[index] = cfg_temp;
	endfunction


	function AddFabricPGCB(
		int index = -1, 
		string name, 
		int fet_index = -1, //col change. changed defalt value to -1. can have potential impact on backward ocmpatibility 
		time hys = 0ps, 
		int sip_pgcb_dependency[] = {}, 
		PowerGating::InitialState initial_state = PowerGating::POWER_GATED, 
		int ungate_priority = 0);

		PowerGatingFabricConfig cfg_temp;

		cfg_temp = PowerGatingFabricConfig::type_id::create();
		cfg_temp.index = index;
		cfg_temp.name = name;	
		cfg_temp.hys = hys;
		cfg_temp.sip_pgcb_dependency = sip_pgcb_dependency;
		cfg_temp.initial_state = initial_state;
		cfg_temp.ungate_priority = ungate_priority;

		//col change
		//CASE 1 - phase 1. fet is specified and index is specified		
		if(index != -1 && fet_index != -1) begin
			cfg_fab_pgcb[index] = cfg_temp;
			cfg_temp.fet_index = fet_index;		
			cfg_temp.fet_name = cfg_fet[fet_index].name;				
		end
		//CASE 2 -  phase 2: fet is not specified and index is -1
		else if(fet_index == -1 && index == -1) begin
			cfg_fab_pgcb_n[name] = cfg_temp;
			cfg_fab_pgcb.push_front(cfg_temp);
			//TODO: check there are no duplicates
			fab_index[name] = cfg_fab_pgcb.size() - 1;
			fab_name[cfg_fab_pgcb.size() - 1] = name;			
		end
		//CASE 3 - phase 2 with backward compatibility mode: fet is not specified and index is not -1		
		else if(fet_index == -1 && index != -1) begin
			//TODO:
		end
		else
			`ovm_fatal(get_full_name(), "AddFabricPGCB:User has specified illegal combination of fet_index and index");		
		//END col change
		
	endfunction

	function PowerGatingEPConfig get_ep_config(
		int index = -1,
		bit AON_EP = 0,
		int pmc_wake_index = -1,
		logic[7:0] source_id = 'h00
	);
		PowerGatingEPConfig cfg_temp;
		cfg_temp = PowerGatingEPConfig::type_id::create();
		cfg_temp.index = index;

		if(AON_EP == 1'b1) begin
			cfg_temp.AON_EP = 1;
			cfg_temp.pmc_wake_index = pmc_wake_index;
			sip_name_pmc_wake[pmc_wake_index] = sip_name_sb_ep[index];
		end
		cfg_temp.source_id = source_id;
		return cfg_temp;
	endfunction

	function AddSBEP(int index = -1, bit[7:0] source_id = 0, bit AON_EP = 0, int pmc_wake_index = 0,
		bit 	boot_prep_early = 0, 
		bit 	ip_ready = 0, //ip-ready default is 1??
		bit 	boot_prep_general = 0,
		bit 	reset_prep_reset_start = 0,
		bit 	reset_prep_general = 0,
		bit 	reset_prep_link_turnoff = 0);

		PowerGatingEPConfig temp;
		temp = PowerGatingEPConfig::type_id::create();
	   	temp = get_ep_config(index, AON_EP, pmc_wake_index, source_id);
		temp.boot_prep_early = boot_prep_early; 
		temp.ip_ready = ip_ready;
		temp.boot_prep_general = boot_prep_general; 
		temp.reset_prep_reset_start = reset_prep_reset_start;
		temp.reset_prep_general = reset_prep_general;
		temp.reset_prep_link_turnoff = reset_prep_link_turnoff;

		if(AON_EP == 1'b1) begin
			if(cfg_pmc_wake_aon[pmc_wake_index] == null) begin
				PowerGatingSIPConfig cfg_temp;
				cfg_temp = PowerGatingSIPConfig::type_id::create();
				cfg_temp.AON_SB_index.push_front(index);
				cfg_temp.index = pmc_wake_index;
				cfg_pmc_wake_aon[pmc_wake_index] = cfg_temp;
			end
			cfg_pmc_wake_aon[pmc_wake_index].AON_SB_index.push_front(index);
		end	
		if(index != -1) begin
			cfg_side_ep[index] = temp;
		end
		else begin
			cfg_side_ep_all[num_side_n] = temp;
			num_side_n++;
		end		
	endfunction


	function AddPrimEP(int index, bit[7:0] source_id = 0, bit AON_EP = 0, int pmc_wake_index = 0);

		cfg_prim_ep[index] = get_ep_config(index, AON_EP, pmc_wake_index, source_id);
		if(AON_EP == 1'b1) begin
			if(cfg_pmc_wake_aon[pmc_wake_index] == null) begin
				PowerGatingSIPConfig cfg_temp;
				cfg_temp = PowerGatingSIPConfig::type_id::create();
				cfg_temp.AON_prim_index.push_front(index);
				cfg_temp.index = pmc_wake_index;				
				cfg_pmc_wake_aon[pmc_wake_index] = cfg_temp;				
			end
			cfg_pmc_wake_aon[pmc_wake_index].AON_prim_index.push_front(index);
		end		
	endfunction

	function AddSIP(
		string name, 
		PowerGating::SIPType sip_type = PowerGating::HOST, 
		int pgcb_array[] = {}, 
		int AON_SB_array[] = {}, 
		int AON_prim_array[] = {}, 
		int d3[]= {}, 
		int d0i3[] = {},
		int clkreq0_check_indices[] = {},
		//col change
		string pgcb_name[] = {},
		int vnn_ack_req_index = -1 
		//END col change
	);
		PowerGatingSIPConfig cfg_temp;
		cfg_temp = PowerGatingSIPConfig::type_id::create();
		cfg_temp.name = name;

		cfg_temp.sip_type = sip_type;
		cfg_temp.pgcb_index = pgcb_array;
		cfg_temp.AON_SB_index = AON_SB_array;
		cfg_temp.AON_prim_index = AON_prim_array;
		cfg_temp.clkreq0_check_indices = clkreq0_check_indices;
		cfg_temp.vnn_ack_req_index = vnn_ack_req_index;
		//populate all_* arrays here
		//TODO: cant concatenate arrays. Fix this
		/*foreach(cfg_temp.pgcb_index[i]) begin
			cfg_temp.clkreq0_check_indices = {cfg_temp.clkreq0_check_indices, cfg_temp.pgcb_index[i].clkreq0_check_indices};
		end
		*/	
		foreach(AON_SB_array[n]) begin
			sip_name_sb_ep[AON_SB_array[n]] = name;
		end
		foreach(AON_prim_array[n]) begin
			sip_name_prim_ep[AON_prim_array[n]] = name;
		end
		foreach(pgcb_array[n]) begin
			cfg_sip_pgcb[pgcb_array[n]].sip_name = name;
			cfg_sip_pgcb[pgcb_array[n]].sip_index = (cfg_sip.size() - 1);
		end
		foreach(d3[n]) begin
			sip_name_d3[d3[n]] = name;
		end
		foreach(d0i3[n]) begin
			sip_name_d0i3[d3[n]] = name;
		end	

		//col change
		if(pgcb_name.size() != 0) begin
			int i = 0;
			cfg_temp.pgcb_name = pgcb_name;
			//this is for backward compatibility
			foreach(pgcb_name[s]) begin
				cfg_temp.pgcb_index[i] = this.sip_index[s];
				i++;
			end
			//END this is for backward compatibility
			cfg_sip_n[name] = cfg_temp;
		end
		if(AON_SB_array.size() == 0 && pgcb_array.size() == 0) begin
			`ovm_fatal(get_full_name(), $psprintf("Addsip function for IP '%s' has pgcb_array.size() and AON_SB_array.size() are zero, either of them should have non zero value",name))
		end
		//END col chage
		cfg_sip.push_front(cfg_temp);
		cfg_sip_all.push_front(cfg_temp);
		
	endfunction

	function get_all_pg_arrays(
								input int sip,
								input bit get_sb,
								input bit aon_sb_registration = 0,
								ref int boot_pgcb_wake[$],
								ref int boot_pgcb_pg_ack[$],
								ref int boot_ungated_ack[$],
								ref int side_pok[$],
								ref int prim_pok[$],
								ref int boot_ungated_side_pok[$],
								ref int boot_ungated_prim_pok[$],
								ref logic[7:0] 	force_message_dest_id[$],
								ref int			clkreq0_check_indices[$],
								ref logic[7:0] 	boot_prep_early[$], 
								ref logic[7:0] 	ip_ready[$],
								ref logic[7:0] 	boot_prep_general[$], 
								ref logic[7:0] 	reset_prep_reset_start[$],
								ref logic[7:0] 	reset_prep_general[$],
								ref logic[7:0] 	reset_prep_link_turnoff[$]								
							);
						for(int l = 0; l < cfg_sip[sip].pgcb_index.size(); l++) begin
								int pgcb_index = cfg_sip[sip].pgcb_index[l];
								//populate the PG wake and PG ACK indices for the group here
								int exists[$];
								exists = boot_pgcb_wake.find_first with (item == cfg_sip_pgcb[pgcb_index].pmc_wake_index);
								if(exists.size() == 0)							
									boot_pgcb_wake.push_back(cfg_sip_pgcb[pgcb_index].pmc_wake_index);
								//PG ACK index
								boot_pgcb_pg_ack.push_back(pgcb_index);	
								if(cfg_sip_pgcb[pgcb_index].initial_state == PowerGating::POWER_UNGATED)
								begin
									boot_ungated_ack.push_back(pgcb_index);	
									boot_ungated_side_pok = {boot_ungated_side_pok, cfg_sip_pgcb[pgcb_index].SB_index};
									boot_ungated_prim_pok = {boot_ungated_prim_pok, cfg_sip_pgcb[pgcb_index].prim_index};
								end
								else if(cfg_sip_pgcb[pgcb_index].initial_state == PowerGating::POWER_UNGATED_POK0)
								begin
									boot_ungated_ack.push_back(pgcb_index);	
								end
								
								for(int m = 0; m < cfg_sip_pgcb[pgcb_index].SB_index.size(); m ++) begin
									int sb_index = cfg_sip_pgcb[pgcb_index].SB_index[m];
									side_pok.push_back(sb_index);
									// populate the force message EP ids here
									force_message_dest_id.push_back(cfg_side_ep[sb_index].source_id);
									cfg_sip[sip].side_pid.push_back(cfg_side_ep[sb_index].source_id);
									if(get_sb) 
										get_all_sb_registration(sb_index, 
											boot_prep_early, 
											ip_ready,
											boot_prep_general, 
											reset_prep_reset_start,
											reset_prep_general,
											reset_prep_link_turnoff
										);
								end
								for(int m = 0; m < cfg_sip_pgcb[pgcb_index].prim_index.size(); m ++) begin
									prim_pok.push_back(cfg_sip_pgcb[pgcb_index].prim_index[m]);
								end
							end
							for(int m = 0; m < cfg_sip[sip].AON_SB_index.size(); m++) begin
								int sb_index = cfg_sip[sip].AON_SB_index[m];
								int exists[$];
								exists = boot_pgcb_wake.find_first with (item == cfg_side_ep[sb_index].pmc_wake_index);						
								side_pok.push_back(sb_index);
								// populate the force message EP ids here
								force_message_dest_id.push_back(cfg_side_ep[sb_index].source_id);	
								cfg_sip[sip].side_pid.push_back(cfg_side_ep[sb_index].source_id);

								//In random mode, SB registration is only support for IPs which have a PGCB.
								//So adding addtional code to support IPs which have a AON SB index. This additional
								//get_all_sb_registration will get set in chassis_config when called in random mode.
								if(get_sb && aon_sb_registration) 
									 	get_all_sb_registration(sb_index, 
											boot_prep_early, 
											ip_ready,
											boot_prep_general, 
											reset_prep_reset_start,
											reset_prep_general,
											reset_prep_link_turnoff
										);


								//AON pmc wake
								if(exists.size() == 0)
									boot_pgcb_wake.push_back(cfg_side_ep[sb_index].pmc_wake_index);
							end
							for(int m = 0; m < cfg_sip[sip].AON_prim_index.size(); m++) begin
								int prim_index = cfg_sip[sip].AON_prim_index[m];
								int exists[$];
								exists = boot_pgcb_wake.find_first with (item == cfg_prim_ep[prim_index].pmc_wake_index);											
								prim_pok.push_back(cfg_sip[sip].AON_prim_index[m]);
								//AON pmc wake
								if(exists.size() == 0)
									boot_pgcb_wake.push_back(cfg_prim_ep[prim_index].pmc_wake_index);
							end

							clkreq0_check_indices = cfg_sip[sip].clkreq0_check_indices;

		endfunction	

	   	//get all SB information like Prep and IP_READY.
		function get_all_sb_registration(
								input int sb_index,		
								ref logic[7:0] 	boot_prep_early[$], 
								ref logic[7:0] 	ip_ready[$],
								ref logic[7:0] 	boot_prep_general[$], 
								ref logic[7:0] 	reset_prep_reset_start[$],
								ref logic[7:0] 	reset_prep_general[$],
								ref logic[7:0] 	reset_prep_link_turnoff[$]
							);
				if(cfg_side_ep[sb_index].boot_prep_early == 1) boot_prep_early.push_back(cfg_side_ep[sb_index].source_id);
				if(cfg_side_ep[sb_index].boot_prep_general == 1) boot_prep_general.push_back(cfg_side_ep[sb_index].source_id);
				if(cfg_side_ep[sb_index].ip_ready == 1) ip_ready.push_back(cfg_side_ep[sb_index].source_id);
				if(cfg_side_ep[sb_index].reset_prep_reset_start == 1) reset_prep_reset_start.push_back(cfg_side_ep[sb_index].source_id);
				if(cfg_side_ep[sb_index].reset_prep_general == 1) reset_prep_general.push_back(cfg_side_ep[sb_index].source_id);
		endfunction
	
	static function int getSIPPGCBIndex(string name);
		if(!sip_index.exists(name)) 
			`ovm_error("PowerGatingConfig", $psprintf("User called the static method getSIPPGCBIndex for PGCB name = %s. This name does not exist", name))
		else
			return sip_index[name];
	endfunction
		
endclass: PowerGatingConfig
