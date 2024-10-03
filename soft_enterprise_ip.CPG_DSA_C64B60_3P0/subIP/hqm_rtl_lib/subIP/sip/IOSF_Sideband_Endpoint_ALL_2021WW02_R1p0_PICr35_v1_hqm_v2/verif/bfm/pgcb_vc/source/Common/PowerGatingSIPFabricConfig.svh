class PowerGatingBaseConfig extends ovm_object;
	int index;
	string name;

	///used in fet, SIP and pmc_wake configs. So adding to common config
	int pgcb_index[$]; 

	//col change
	string pgcb_name[$]; 
	//END col change
	int clkreq0_check_indices[$];

	//common to fab and PGCB
	int fet_index;
	string fet_name;
	PowerGating::InitialState initial_state;	
	int ungate_priority;

	//common to PGCB and EP
	int pmc_wake_index;

	//common to PGCB and EP
	int vnn_ack_req_index;

   `ovm_object_utils_begin(PowerGatingBaseConfig)
   `ovm_object_utils_end
	function new(string name = "");        
 		super.new(name);
	endfunction

	function string getName();
		return name;
	endfunction: getName

	function int getFETNum();
		return fet_index;
	endfunction: getFETNum

	function string getFETName();
		return fet_name;
	endfunction
endclass


class PowerGatingEPConfig extends PowerGatingBaseConfig;
	bit AON_EP;
	logic[7:0] source_id;

	/*
	logic[7:0] 	boot_prep_early[$]; 
	logic[7:0] 	ip_ready[$];
	logic[7:0] 	boot_prep_general[$];
	logic[7:0] 	reset_prep_reset_start[$];
	logic[7:0] 	reset_prep_general[$]; 
	logic[7:0] 	reset_prep_link_turnoff[$];
	*/
	bit 	boot_prep_early; 
	bit 	ip_ready;
	bit 	boot_prep_general;
	bit 	reset_prep_reset_start;
	bit 	reset_prep_general; 
	bit 	reset_prep_link_turnoff;

   `ovm_object_utils_begin(PowerGatingEPConfig)
   `ovm_object_utils_end
	function new(string name = "");        
 		super.new(name);
	endfunction
endclass

class PowerGatingFabricConfig extends PowerGatingBaseConfig;
	time hys;
	int sip_pgcb_dependency[];

   `ovm_object_utils_begin(PowerGatingFabricConfig)
   `ovm_object_utils_end
	function new(string name = "");        
 		super.new(name);
	endfunction

	function time getHys();
		return hys;
	endfunction: getHys
endclass

class PowerGatingSIPPGCBConfig extends PowerGatingBaseConfig;
	string sip_name;
	int sip_index;	
	int sw_ent_index;
	
	//PGCBAgent
	bit ignore_sw_req;

	int fabric_index;
	bit initial_restore_asserted;
	int clkreq0_check_indices[];

	//SIP config for AON domain
	int SB_index[$];
	int prim_index[$];

	//col change
	string fabric_name;
	int num_side = 0;
	int num_prim = 0;
	int num_d3 = 0;
	int num_d0i3 = 0;
	logic[7:0] side_pid[];
	logic[7:0] prim_pid[];
	//END col change

   `ovm_object_utils_begin(PowerGatingSIPPGCBConfig)
   `ovm_object_utils_end

	function new(string name = "");        
 		super.new(name);
	endfunction

	function int getSWEntIndex();
		return sw_ent_index;
	endfunction: getSWEntIndex

	function int getPMCWakeIndex();
		return pmc_wake_index;
	endfunction: getPMCWakeIndex

	function int getVNNAckReqIndex();
		return vnn_ack_req_index;
	endfunction: getVNNAckReqIndex


	function string getSIPName();
		return sip_name;
	endfunction

	function getSideEPIndex(output int SBArray[]);
		SBArray = SB_index;
	endfunction
	function getPrimEPIndex(output int primArray[]);
		primArray = prim_index;
	endfunction	
endclass: PowerGatingSIPPGCBConfig


class PowerGatingSIPConfig extends PowerGatingBaseConfig;
	int AON_SB_index[$];
	int AON_prim_index[$];	
	PowerGating::SIPType sip_type;
	logic[7:0] side_pid[$];

	/*
	int			boot_pgcb_wake[$];
	int			boot_pgcb_pg_ack[$];
	int			boot_ungated_ack[$];	
	int			boot_ungated_side_pok[$];
	int			boot_ungated_prim_pok[$];
	int			side_pok[$];
	int			prim_pok[$];
	int			reset_pgcb_wake[$];
	int			reset_pgcb_pg_ack[$];
	int			reset_ungated_ack[$];			
	*/
	//col change
	string aon_name[$];
	//END col change

   `ovm_object_utils_begin(PowerGatingSIPConfig)
   `ovm_object_utils_end
	function new(string name = "");        
 		super.new(name);
	endfunction

endclass
