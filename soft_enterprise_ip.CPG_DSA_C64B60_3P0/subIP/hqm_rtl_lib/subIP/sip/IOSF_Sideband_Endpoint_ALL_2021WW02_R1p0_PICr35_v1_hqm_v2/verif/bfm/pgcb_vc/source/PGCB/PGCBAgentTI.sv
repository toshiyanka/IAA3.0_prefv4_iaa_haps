module PGCBAgentTI #(
	parameter int NUM_SIP_PGCB = 1,
	parameter int NUM_FET = 1,
	parameter int NUM_SW_REQ = 1,
	parameter int NUM_PMC_WAKE = 1,
	parameter int NUM_FAB_PGCB = 1,
	parameter int NUM_VNN_ACK_REQ = 1,
	parameter int NUM_PRIM_EP = 1,
	parameter int NUM_SB_EP = 1,
	parameter int NUM_D3 = 1,
	parameter int NUM_D0I3 = 1,	
	parameter string test_island_name = "",
	parameter bit NO_FAB_PGCB = 0,
	parameter bit NO_SIP_PGCB = 0,
	parameter bit NO_PRIM_EP = 0,
	parameter bit IS_ACTIVE = 1,
	parameter string IP_ENV_TO_PGCB_AGENT_PATH = "",
	parameter bit BFM_DRIVES_POK = 1,
	parameter bit BFM_DRIVES_FET_EN_ACK = 0
)
(	

	interface powerGatingIF
);
   	import ovm_pkg::*;
	import PowerGatingParamsPkg::*;
	import CCAgentPkg::*;


	bit[MAX_SIP-NUM_SW_REQ:0] temp_pmc_ip_sw_pg_req_b;

	bit[MAX_SIP-NUM_SIP_PGCB:0] temp_ip_pmc_pg_req_b;
	bit[MAX_SIP-NUM_SIP_PGCB:0] temp_pmc_ip_pg_ack_b;
	bit[MAX_SIP-NUM_PMC_WAKE:0] temp_pmc_ip_pg_wake;

	bit[MAX_SIP-NUM_SIP_PGCB:0] temp_pmc_ip_restore_b;

	//bit[MAX_SIP-NUM_SIP_PGCB:0] temp_ip_pmc_save_req_b;
	//bit[MAX_SIP-NUM_SIP_PGCB:0] temp_pmc_ip_save_ack_b;
	//Is this needed??
	bit[MAX_SIP-NUM_PRIM_EP:0] temp_prim_pok;
	bit[MAX_SIP-NUM_SB_EP:0] temp_side_pok;

	bit[MAX_FAB-NUM_FAB_PGCB:0] temp_fab_pmc_idle;
	bit[MAX_FAB-NUM_FAB_PGCB:0] temp_pmc_fab_pg_rdy_req_b;
	bit[MAX_FAB-NUM_FAB_PGCB:0] temp_fab_pmc_pg_rdy_ack_b;
	bit[MAX_FAB-NUM_FAB_PGCB:0] temp_fab_pmc_pg_rdy_nack_b;

	bit[MAX_FET-NUM_FET:0] temp_fet_en_b;
	bit[MAX_FET-NUM_FET:0] temp_fet_en_ack_b;

	bit[MAX_SIP-NUM_VNN_ACK_REQ:0] temp_pmc_ip_vnn_ack;
	bit[MAX_SIP-NUM_VNN_ACK_REQ:0] temp_ip_pmc_vnn_req;

	PowerGatingNoParamIF pgIF();

	

   	generate if (!IS_ACTIVE) begin: ASSIGN_PASSIVE_BLK

	//This is jsut for the monitor	
	assign pgIF.clk = powerGatingIF.clk;
	assign pgIF.reset_b = powerGatingIF.reset_b;
	
	assign pgIF.pmc_ip_sw_pg_req_b = {temp_pmc_ip_sw_pg_req_b, powerGatingIF.pmc_ip_sw_pg_req_b[NUM_SW_REQ-1:0]};
	assign pgIF.ip_pmc_pg_req_b = {temp_ip_pmc_pg_req_b, powerGatingIF.ip_pmc_pg_req_b};
	assign pgIF.pmc_ip_pg_ack_b = {temp_pmc_ip_pg_ack_b, powerGatingIF.pmc_ip_pg_ack_b[NUM_SIP_PGCB-1:0]};
	assign pgIF.pmc_ip_pg_wake = {temp_pmc_ip_pg_wake, powerGatingIF.pmc_ip_pg_wake[NUM_PMC_WAKE-1:0]};
	
	assign pgIF.pmc_ip_restore_b = {temp_pmc_ip_restore_b, powerGatingIF.pmc_ip_restore_b[NUM_SIP_PGCB-1:0]};

	assign pgIF.prim_pok = {temp_prim_pok, powerGatingIF.prim_pok[NUM_PRIM_EP-1:0]};
	assign pgIF.side_pok = {temp_side_pok, powerGatingIF.side_pok[NUM_SB_EP-1:0]};

	assign pgIF.prim_rst_b = powerGatingIF.prim_rst_b[NUM_PRIM_EP-1:0];
	assign pgIF.side_rst_b = powerGatingIF.side_rst_b[NUM_SB_EP-1:0];	

	assign pgIF.pmc_ip_vnn_ack = {temp_pmc_ip_vnn_ack,powerGatingIF.pmc_ip_vnn_ack[NUM_VNN_ACK_REQ-1:0]};	
	assign pgIF.ip_pmc_vnn_req = {temp_ip_pmc_vnn_req,powerGatingIF.ip_pmc_vnn_req[NUM_VNN_ACK_REQ-1:0]};	

	assign pgIF.fab_pmc_idle= {temp_fab_pmc_idle, powerGatingIF.fab_pmc_idle};
	assign pgIF.pmc_fab_pg_rdy_req_b = {temp_pmc_fab_pg_rdy_req_b, powerGatingIF.pmc_fab_pg_rdy_req_b[NUM_FAB_PGCB-1:0]};
	assign pgIF.fab_pmc_pg_rdy_ack_b = {temp_fab_pmc_pg_rdy_ack_b,powerGatingIF.fab_pmc_pg_rdy_ack_b};
	assign pgIF.fab_pmc_pg_rdy_nack_b = {temp_fab_pmc_pg_rdy_nack_b,powerGatingIF.fab_pmc_pg_rdy_nack_b};
	assign pgIF.fet_en_b = {temp_fet_en_b, powerGatingIF.fet_en_b[NUM_FET-1:0]};
	assign pgIF.fet_en_ack_b = {temp_fet_en_ack_b, powerGatingIF.fet_en_ack_b};	
	assign pgIF.ip_pmc_d3 = powerGatingIF.ip_pmc_d3;
	assign pgIF.ip_pmc_d0i3 = powerGatingIF.ip_pmc_d0i3;


   end: ASSIGN_PASSIVE_BLK
   else begin: ASSIGN_ALL_BLK
	assign pgIF.clk = powerGatingIF.clk;
	assign pgIF.reset_b = powerGatingIF.reset_b;
	assign pgIF.pmc_ip_sw_pg_req_b = {temp_pmc_ip_sw_pg_req_b, powerGatingIF.pmc_ip_sw_pg_req_b[NUM_SW_REQ-1:0]};
	assign powerGatingIF.ip_pmc_pg_req_b = pgIF.ip_pmc_pg_req_b[NUM_SIP_PGCB-1:0];
	assign pgIF.pmc_ip_pg_ack_b = {temp_pmc_ip_pg_ack_b, powerGatingIF.pmc_ip_pg_ack_b[NUM_SIP_PGCB-1:0]};
	assign pgIF.pmc_ip_pg_wake = {temp_pmc_ip_pg_wake, powerGatingIF.pmc_ip_pg_wake[NUM_PMC_WAKE-1:0]};

	assign pgIF.pmc_ip_restore_b = {temp_pmc_ip_restore_b, powerGatingIF.pmc_ip_restore_b[NUM_SIP_PGCB-1:0]};

	assign pgIF.prim_rst_b = powerGatingIF.prim_rst_b[NUM_PRIM_EP-1:0];
	assign pgIF.side_rst_b = powerGatingIF.side_rst_b[NUM_SB_EP-1:0];		

	assign pgIF.pmc_ip_vnn_ack = {temp_pmc_ip_vnn_ack,powerGatingIF.pmc_ip_vnn_ack[NUM_VNN_ACK_REQ-1:0]};	
	assign powerGatingIF.ip_pmc_vnn_req = pgIF.ip_pmc_vnn_req[NUM_VNN_ACK_REQ-1:0];	

	assign powerGatingIF.fab_pmc_idle = pgIF.fab_pmc_idle[NUM_FAB_PGCB-1:0];
	assign pgIF.pmc_fab_pg_rdy_req_b = {temp_pmc_fab_pg_rdy_req_b, powerGatingIF.pmc_fab_pg_rdy_req_b[NUM_FAB_PGCB-1:0]};	
	assign powerGatingIF.fab_pmc_pg_rdy_ack_b = pgIF.fab_pmc_pg_rdy_ack_b[NUM_FAB_PGCB-1:0];
	assign powerGatingIF.fab_pmc_pg_rdy_nack_b = pgIF.fab_pmc_pg_rdy_nack_b[NUM_FAB_PGCB-1:0];
	assign pgIF.fet_en_b = {temp_fet_en_b, powerGatingIF.fet_en_b};
	//assign pgIF.fet_en_ack_b = {temp_fet_en_ack_b, powerGatingIF.fet_en_ack_b};		
	assign pgIF.ip_pmc_d3 = powerGatingIF.ip_pmc_d3;
	assign pgIF.ip_pmc_d0i3 = powerGatingIF.ip_pmc_d0i3;


   end: ASSIGN_ALL_BLK
   endgenerate



	generate if(IS_ACTIVE && BFM_DRIVES_POK) begin : active_pok_gen
		assign powerGatingIF.prim_pok = pgIF.prim_pok[NUM_PRIM_EP-1:0];
		assign powerGatingIF.side_pok = pgIF.side_pok[NUM_SB_EP-1:0];
	end
	else if(IS_ACTIVE && !BFM_DRIVES_POK)  begin : active_pok_gen
		assign pgIF.prim_pok = {temp_prim_pok, powerGatingIF.prim_pok[NUM_PRIM_EP-1:0]};
		assign pgIF.side_pok = {temp_side_pok, powerGatingIF.side_pok[NUM_SB_EP-1:0]};
	end
	endgenerate


	generate if(IS_ACTIVE && BFM_DRIVES_FET_EN_ACK) begin : active_fet_en_ack_gen
		assign powerGatingIF.fet_en_ack_b = pgIF.fet_en_ack_b[NUM_FET-1:0];
	end
	else if(IS_ACTIVE && !BFM_DRIVES_FET_EN_ACK)  begin: active_fet_en_ack_gen
		assign pgIF.fet_en_ack_b = {temp_fet_en_ack_b, powerGatingIF.fet_en_ack_b};
	end
	endgenerate	
	initial begin

		sla_pkg::sla_vif_container #(virtual PowerGatingNoParamIF) iFContainer;
		int test;
		

		if(IP_ENV_TO_PGCB_AGENT_PATH == "" || IP_ENV_TO_PGCB_AGENT_PATH == "*") begin
			`ovm_error("CCAgent TI", "Must not set the parameter IP_ENV_TO_PGCB_AGENT_PATH to empty string or *. It has to be the OVM name of the IP's env and CCAgent. Please see integration guide. If this is not set correctly, it will cause integration issues at SOC level.")
		end
		set_config_int(IP_ENV_TO_PGCB_AGENT_PATH, "POWERGATING_NUM_SIP_PGCB", NUM_SIP_PGCB);		
		set_config_int(IP_ENV_TO_PGCB_AGENT_PATH, "POWERGATING_NUM_FAB_PGCB", NUM_FAB_PGCB);
		set_config_int(IP_ENV_TO_PGCB_AGENT_PATH, "POWERGATING_NUM_PMC_WAKE", NUM_PMC_WAKE);
		set_config_int(IP_ENV_TO_PGCB_AGENT_PATH, "POWERGATING_NUM_SW_REQ", NUM_SW_REQ);		
		set_config_int(IP_ENV_TO_PGCB_AGENT_PATH, "POWERGATING_NUM_SB_EP", NUM_SB_EP);
		set_config_int(IP_ENV_TO_PGCB_AGENT_PATH, "POWERGATING_NUM_PRIM_EP", NUM_PRIM_EP);		
		//set_config_int(IP_ENV_TO_PGCB_AGENT_PATH, "POWERGATING_NO_FAB", NO_FAB_PGCB);
		//set_config_int(IP_ENV_TO_PGCB_AGENT_PATH, "POWERGATING_NO_SIP", NO_SIP_PGCB);
		set_config_int(IP_ENV_TO_PGCB_AGENT_PATH, "POWERGATING_IS_ACTIVE", IS_ACTIVE);
		set_config_int(IP_ENV_TO_PGCB_AGENT_PATH, "POWERGATING_NUM_FET", NUM_FET);
		set_config_int(IP_ENV_TO_PGCB_AGENT_PATH, "POWERGATING_BFM_DRIVES_POK", BFM_DRIVES_POK);
		set_config_int(IP_ENV_TO_PGCB_AGENT_PATH, "POWERGATING_BFM_DRIVES_FET_EN_ACK", BFM_DRIVES_FET_EN_ACK);


		set_config_string(IP_ENV_TO_PGCB_AGENT_PATH, "interfaceName", {$psprintf("%m"), "IFContainer"});	

		iFContainer = new("IFContainer");
        iFContainer.set_v_if(pgIF);
        set_config_object(IP_ENV_TO_PGCB_AGENT_PATH, {$psprintf("%m"), "IFContainer"},iFContainer,0);
	end


	
endmodule:PGCBAgentTI
