
//TODO: shoudl we be importing the pkg here?
//`include "PowerGatingSaolaPkg.svh"
//`include "PutGetTestProgram.svh" 
//`include "mock_dut/command_queue.svh"

// The testbench top.
module PowerGatingTestbenchTop (input side_pok_temp);


	import ovm_pkg::*;
	import sla_pkg::*;
	import PowerGatingSaolaPkg::*;
	reg clock;
	reg jtag_clock;
	reg reset_b = 0;
	parameter int NUM_SIP_PGCB = 4;
	parameter int NUM_FAB_PGCB = 2;
	parameter int NUM_FET = 4;	
	parameter int NUM_PMC_WAKE = 4;
	//DBV Possible Typo?? Changing to 4 parameter int NUM_SW_REQ = 3;
	parameter int NUM_SW_REQ = 4;

	parameter int NUM_PRIM_EP = 2;
	parameter int NUM_SB_EP = 3;
	parameter int BFM_DRIVES_FET_EN_ACK = 1;
	parameter int NUM_D3 = 2;



	logic[NUM_SW_REQ-1:0] pmc_ip_sw_pg_req_b;
	logic[NUM_SIP_PGCB-1:0] ip_pmc_pg_req_b;
	logic[NUM_SIP_PGCB-1:0] pmc_ip_pg_ack_b;
	logic[NUM_PMC_WAKE-1:0] pmc_ip_pg_wake;

	logic[NUM_SIP_PGCB-1:0] pmc_ip_restore_b;

	//Is this needed??
	logic[NUM_PRIM_EP-1:0] prim_pok;
	logic[NUM_SB_EP-1:0] side_pok;	

	logic[NUM_FAB_PGCB-1:0] fab_pmc_idle;
	logic[NUM_FAB_PGCB-1:0] pmc_fab_pg_rdy_req_b;
	logic[NUM_FAB_PGCB-1:0] fab_pmc_pg_rdy_ack_b;
	logic[NUM_FAB_PGCB-1:0] fab_pmc_pg_rdy_nack_b;

	logic[NUM_FET-1:0] fet_en_b;
	logic[NUM_FET-1:0] fet_en_ack_b;

	//------------------------HIP PG signals------------------------------------//
	// Interface signals for each HIP voltage domain under control of PMC
        logic pmc_phy_pwr_en;
        logic phy_pmc_pwr_stable;
        logic pmc_phy_reset_b;
        logic pmc_phy_fw_en_b;
     
        // Interface signals for IOSF Power Management
        logic pmc_phy_sbwake;
        logic phy_pmc_sbpwr_stable;
        logic iosf_side_pok_h;
        logic iosf_side_rst_b;
     
        // Interface signals for dynamic power gating of each HIP gated voltage domain
        logic soc_phy_pwr_req;
        logic phy_soc_pwr_ack;
        logic pmc_phy_pmctrl_en;
        logic pmc_phy_pmctrl_pwr_en;
        logic phy_pmc_pmctrl_pwr_stable;
     
        // Interface signal for messages for IOSF-SB power management
        logic forcePwrGatePOK;
	//------------------------------------------------------------------------//


//	input logic side_pok_temp;
	 
	PowerGatingIF#(
	.NUM_SIP_PGCB(NUM_SIP_PGCB),
	.NUM_FET(NUM_FET),
	.NUM_FAB_PGCB(NUM_FAB_PGCB),
	.NUM_SW_REQ(NUM_SW_REQ),
	.NUM_PMC_WAKE(NUM_PMC_WAKE),
	.NUM_PRIM_EP(NUM_PRIM_EP),
	.NUM_SB_EP(NUM_SB_EP),
	.NUM_D3(NUM_D3),

	//.NO_FAB(1),
	.test_island_name("ccAgent")		 
	 ) ccIF ();
	assign ccIF.clk = clock;
	assign ccIF.jtag_tck = jtag_clock;

	assign ccIF.reset_b = reset_b;
	assign pmc_ip_sw_pg_req_b = ccIF.pmc_ip_sw_pg_req_b[NUM_SW_REQ-1:0];
	assign ccIF.ip_pmc_pg_req_b[NUM_SIP_PGCB-1:0] = ip_pmc_pg_req_b;
	assign pmc_ip_pg_ack_b = ccIF.pmc_ip_pg_ack_b[NUM_SIP_PGCB-1:0];
	assign pmc_ip_pg_wake = ccIF.pmc_ip_pg_wake[NUM_PMC_WAKE-1:0];
	assign pmc_ip_restore_b = ccIF.pmc_ip_restore_b;
	assign ccIF.prim_pok = prim_pok;
	assign ccIF.side_pok = side_pok;
	assign ccIF.fab_pmc_idle[NUM_FAB_PGCB-1:0] = fab_pmc_idle;
	assign pmc_fab_pg_rdy_req_b = ccIF.pmc_fab_pg_rdy_req_b[NUM_FAB_PGCB-1:0];
	assign ccIF.fab_pmc_pg_rdy_ack_b = fab_pmc_pg_rdy_ack_b;
	assign ccIF.fab_pmc_pg_rdy_nack_b = fab_pmc_pg_rdy_nack_b;
	assign fet_en_b = ccIF.fet_en_b[NUM_FET-1:0];
	//assign ccIF.fet_en_ack_b[NUM_FET-1:0] = fet_en_ack_b;
	generate if(BFM_DRIVES_FET_EN_ACK == 1) 
	begin: name1
		assign ccIF.fet_en_ack_b[NUM_FET-1:0] = fet_en_ack_b;
	end
	else begin: name1
		assign ccIF.fet_en_ack_b = ccIF.fet_en_b;
	end
	endgenerate	
	
	CCAgentTI #(
	.NUM_SIP_PGCB(NUM_SIP_PGCB),
	.NUM_FET(NUM_FET),
	.NUM_FAB_PGCB(NUM_FAB_PGCB),
	.NUM_SW_REQ(NUM_SW_REQ),
	.NUM_PMC_WAKE(NUM_PMC_WAKE),
	.NUM_PRIM_EP(NUM_PRIM_EP),
	.NUM_SB_EP(NUM_SB_EP),
	.IP_ENV_TO_CC_AGENT_PATH("*.sla_env.ccAgent01"),
		.NUM_D3(NUM_D3),
	//.NO_FAB(1),
	.test_island_name("ccAgent")		
		
	)ccTI(ccIF);


	PowerGatingIF#(
	.NUM_SIP_PGCB(NUM_SIP_PGCB),
	.NUM_FET(NUM_FET),
	.NUM_FAB_PGCB(NUM_FAB_PGCB),
	.NUM_SW_REQ(NUM_SW_REQ),
	.NUM_PMC_WAKE(NUM_PMC_WAKE),
	.NUM_PRIM_EP(NUM_PRIM_EP),
	.NUM_SB_EP(NUM_SB_EP),
		.NUM_D3(NUM_D3),
	//.NO_FAB(1),
	.test_island_name("pgcbAgent")		 
	 ) pgcbIF ();
	assign pgcbIF.clk = clock;
	assign pgcbIF.jtag_tck = jtag_clock;	
	assign pgcbIF.reset_b = reset_b;
	assign pgcbIF.pmc_ip_sw_pg_req_b = pmc_ip_sw_pg_req_b[NUM_SW_REQ-1:0];
	assign ip_pmc_pg_req_b[NUM_SIP_PGCB-1:0] = pgcbIF.ip_pmc_pg_req_b;
	assign pgcbIF.pmc_ip_pg_ack_b = pmc_ip_pg_ack_b[NUM_SIP_PGCB-1:0];
	assign pgcbIF.pmc_ip_pg_wake = pmc_ip_pg_wake[NUM_PMC_WAKE-1:0];
	assign pgcbIF.pmc_ip_restore_b = pmc_ip_restore_b;
//	assign prim_pok = pgcbIF.prim_pok;
//	assign side_pok = pgcbIF.side_pok;
	assign pgcbIF.prim_pok = prim_pok;
	assign pgcbIF.side_pok = side_pok;

	//assign side_pok_temp = pgcbIF.side_pok;

	assign fab_pmc_idle[NUM_FAB_PGCB-1:0] = pgcbIF.fab_pmc_idle;
	assign pgcbIF.pmc_fab_pg_rdy_req_b = pmc_fab_pg_rdy_req_b[NUM_FAB_PGCB-1:0];
	assign fab_pmc_pg_rdy_ack_b = pgcbIF.fab_pmc_pg_rdy_ack_b;
	assign fab_pmc_pg_rdy_nack_b = pgcbIF.fab_pmc_pg_rdy_nack_b;
	assign pgcbIF.fet_en_b = fet_en_b[NUM_FET-1:0];
	generate if(BFM_DRIVES_FET_EN_ACK == 1) 
	begin: name2
		assign fet_en_ack_b = pgcbIF.fet_en_ack_b[NUM_FET-1:0];
	end
	else begin: name2
		assign pgcbIF.fet_en_ack_b = pgcbIF.fet_en_b;
	end
	endgenerate
	PGCBAgentTI #(
	.NUM_SIP_PGCB(NUM_SIP_PGCB),
	.NUM_FET(NUM_FET),
	.NUM_FAB_PGCB(NUM_FAB_PGCB),
	.NUM_SW_REQ(NUM_SW_REQ),
	.NUM_PMC_WAKE(NUM_PMC_WAKE),
	.NUM_PRIM_EP(NUM_PRIM_EP),
	.NUM_SB_EP(NUM_SB_EP),
	.IP_ENV_TO_PGCB_AGENT_PATH("*.sla_env.pgcbAgent01"),
	.NUM_D3(NUM_D3),
	//.IP_ENV("*.ccAgent01"),
	//.NO_FAB(1),
	.test_island_name("pgcbAgent"),
	.BFM_DRIVES_FET_EN_ACK(BFM_DRIVES_FET_EN_ACK),	
	.BFM_DRIVES_POK(0)
	)pgcbTI(pgcbIF);



	//Another PGCB in active mode
	PowerGatingIF#(
	.NUM_SIP_PGCB(NUM_SIP_PGCB),
	.NUM_FET(NUM_FET),
	.NUM_FAB_PGCB(NUM_FAB_PGCB),
	.NUM_SW_REQ(NUM_SW_REQ),
	.NUM_PMC_WAKE(NUM_PMC_WAKE),
	.NUM_PRIM_EP(NUM_PRIM_EP),
	.NUM_SB_EP(NUM_SB_EP)
	 ) pgcbIF_active ();
	PGCBAgentTI #(
	.NUM_SIP_PGCB(NUM_SIP_PGCB),
	.NUM_FET(NUM_FET),
	.NUM_FAB_PGCB(NUM_FAB_PGCB),
	.NUM_SW_REQ(NUM_SW_REQ),
	.NUM_PMC_WAKE(NUM_PMC_WAKE),
	.NUM_PRIM_EP(NUM_PRIM_EP),
	.NUM_SB_EP(NUM_SB_EP),
	.IP_ENV_TO_PGCB_AGENT_PATH("*.sla_env.pgcbAgent01_active"),
	.test_island_name("pgcbAgent"),
	.BFM_DRIVES_FET_EN_ACK(BFM_DRIVES_FET_EN_ACK),	
	.BFM_DRIVES_POK(0)
	)pgcbTI_active(pgcbIF_active);

	PowerGatingIF#(
	.NUM_SIP_PGCB(NUM_SIP_PGCB),
	.NUM_FET(NUM_FET),
	.NUM_FAB_PGCB(NUM_FAB_PGCB),
	.NUM_SW_REQ(NUM_SW_REQ),
	.NUM_PMC_WAKE(NUM_PMC_WAKE),
	.NUM_PRIM_EP(NUM_PRIM_EP),
	.NUM_SB_EP(NUM_SB_EP),
	//DBV - This is not defined??.IS_ACTIVE(0),

	//.NO_FAB(1),
	.test_island_name("ccAgent_pas")		 
	 ) ccIF_pas ();

	CCAgentTI #(
	.NUM_SIP_PGCB(NUM_SIP_PGCB),
	.NUM_FET(NUM_FET),
	.NUM_FAB_PGCB(NUM_FAB_PGCB),
	.NUM_SW_REQ(NUM_SW_REQ),
	.NUM_PMC_WAKE(NUM_PMC_WAKE),
	.NUM_PRIM_EP(NUM_PRIM_EP),
	.NUM_SB_EP(NUM_SB_EP),
	.IP_ENV_TO_CC_AGENT_PATH("*sla_env.ccAgent01_passive"),
	.IS_ACTIVE(0),
	//.NO_FAB(1),
	.test_island_name("ccAgent_pas")		
	)ccTI_pas(ccIF_pas);
        
	//Hip pg if
	hip_pg_if #(
	) cc_hip_pg_if ();

        assign pmc_phy_pwr_en                           = cc_hip_pg_if.pmc_phy_pwr_en;
        assign cc_hip_pg_if.phy_pmc_pwr_stable          = phy_pmc_pwr_stable;
        assign pmc_phy_reset_b                          = cc_hip_pg_if.pmc_phy_reset_b;
        assign pmc_phy_fw_en_b                          = cc_hip_pg_if.pmc_phy_fw_en_b;
        assign pmc_phy_sbwake                           = cc_hip_pg_if.pmc_phy_sbwake;
        assign cc_hip_pg_if.phy_pmc_sbpwr_stable        = phy_pmc_sbpwr_stable;
        assign iosf_side_pok_h                          = iosf_side_pok_h;
        assign iosf_side_rst_b                          = iosf_side_rst_b;
        assign soc_phy_pwr_req                          = soc_phy_pwr_req;
        assign cc_hip_pg_if.phy_soc_pwr_ack             = phy_soc_pwr_ack;
        assign pmc_phy_pmctrl_en                        = cc_hip_pg_if.pmc_phy_pmctrl_en;
        assign pmc_phy_pmctrl_pwr_en                    = cc_hip_pg_if.pmc_phy_pmctrl_pwr_en;
        assign cc_hip_pg_if.phy_pmc_pmctrl_pwr_stable   = phy_pmc_pmctrl_pwr_stable;
	assign forcePwrGatePOK                          = cc_hip_pg_if.forcePwrGatePOK;



	//Hip pg ti
	hip_pg_ti #( 
	           .NUM_DOMAINS(1), 
		   .IP_ENV_TO_AGT_PATH("*sla_env.hip_pg_vc_all"),
       		   .NAME("hip_cc_agent")
	           ) ti_hip_pg_if (cc_hip_pg_if);


	`ifdef CHASSIS_PG_P2
	//col change
	// TODO: remove this eventually. Just adding it so that we can run a test

	PowerGatingResetIF  reset_if();
	PowerGatingResetTI #(
		.IP_ENV_TO_AGENT_PATH("*sla_env.ccAgentCsme1_col")
	) reset_cc_ti(reset_if);
	PowerGatingResetTI #(
		.IP_ENV_TO_AGENT_PATH("*sla_env.pgcbAgentCsme1_col")
	) reset_pgcb_ti(reset_if);

	PowerGatingSIPIF kvm_if();
	PowerGatingSIPIF ptio_if();	
	PowerGatingFabricIF fab1_if();

	PowerGatingSIPTI #(
		.NAME("KVM"), 
		.FET_NAME("FET1"), 
		.IP_ENV_TO_AGENT_PATH("*sla_env.ccAgentCsme1_col")) 
	cc_kvm_ti(kvm_if);	

	PowerGatingSIPTI #(
		.NAME("PTIO"), 
		.FET_NAME("FET23"), 
		.IP_ENV_TO_AGENT_PATH("*sla_env.ccAgentCsme1_col")) 
	cc_ptio_ti(ptio_if);	

	PowerGatingFabricTI #(
		.NAME("PTIO_F"), 
		.IP_ENV_TO_AGENT_PATH("*sla_env.ccAgentCsme1_col")) 
	cc_fab1_ti(fab1_if);	

	PowerGatingSIPTI #(
		.NAME("KVM"), 
		.FET_NAME("FET1"), 
		.IP_ENV_TO_AGENT_PATH("*sla_env.pgcbAgentCsme1_col")) 
	pgcb_kvm_ti(kvm_if);
	PowerGatingSIPTI #(
		.NAME("PTIO"), 
		.FET_NAME("FET23"), 
		.IP_ENV_TO_AGENT_PATH("*sla_env.pgcbAgentCsme1_col")) 
	pgcb_ptio_ti(ptio_if);		
	PowerGatingFabricTI #(
		.NAME("PTIO_F"), 
		.IP_ENV_TO_AGENT_PATH("*sla_env.pgcbAgentCsme1_col")) 
	pgcb_fab1_ti(fab1_if);	

	assign reset_if.clk = clock;
	assign reset_if.reset_b = reset_b;	
	assign kvm_if.reset_b = reset_b;
	assign kvm_if.clk = clock;
	//assign pgcb1_if.fet_en_ack_b = pgcb1_if.fet_en_b;	
	
	
	PowerGatingResetTI #(
		.IP_ENV_TO_AGENT_PATH("*sla_env.ccAgentCsme2_col")
	) reset_cc2_ti(reset_if);
	PowerGatingResetTI #(
		.IP_ENV_TO_AGENT_PATH("*sla_env.pgcbAgentCsme2_col")
	) reset_pgcb2_ti(reset_if);


	PowerGatingSIPIF sus_if();

	PowerGatingSIPTI #(
		.NAME("SUS"), 
		.FET_NAME("FET1"), 
		.IP_ENV_TO_AGENT_PATH("*sla_env.ccAgentCsme2_col")) 
	cc_sus_ti(sus_if);	

	PowerGatingSIPTI #(
		.NAME("SUS"), 
		.FET_NAME("FET1"), 
		.IP_ENV_TO_AGENT_PATH("*sla_env.pgcbAgentCsme2_col")) 
	pgcb_sus_ti(sus_if);

	assign sus_if.reset_b = reset_b;
	assign sus_if.clk = clock;

    //Moved this code inside the endif, otherwise it results in Error-[XMRE] Cross-module reference resolution errors
	always @(posedge kvm_if.pmc_ip_pg_wake) begin
		kvm_if.side_pok		<= 'hf;
		kvm_if.prim_pok 		<= 'hf;
	end
	always @(posedge sus_if.pmc_ip_pg_wake) begin
		sus_if.side_pok		<= 'hf;
		sus_if.prim_pok 		<= 'hf;
	end	

	//END col change
	`endif

	// Initial Reset
	initial begin	
		reset_b         <= 1'b0;
		clock         	<= 1'b1;
		#1us reset_b    <= 1'b1;
		#150us reset_b    <= 1'b0;
		#1us reset_b    <= 1'b1;
	end
	always @(posedge pgcbIF.pmc_ip_pg_wake[0]) begin
		side_pok		<= 'hf;
		prim_pok 		<= 'hf;
	end
	always @(posedge pgcbIF.reset_b) begin
		side_pok		<= 'h0;
		prim_pok 		<= 'h0;
	end
        
        //---------------------  HIP PG ---------------------------//
        always @(posedge cc_hip_pg_if.pmc_phy_pwr_en) begin
		#10ns;
	        phy_pmc_pwr_stable		<= 'h1;
	end

        always @(posedge cc_hip_pg_if.pmc_phy_sbwake) begin
		#10ns;
	        phy_pmc_sbpwr_stable		<= 'h1;
	end

	always @(posedge cc_hip_pg_if.soc_phy_pwr_req) begin
		#10ns;
	        phy_soc_pwr_ack	        	<= 'h1;
	end

	always @(posedge cc_hip_pg_if.pmc_phy_pmctrl_pwr_en) begin
		#10ns;
	        phy_pmc_pmctrl_pwr_stable      	<= 'h1;
	end

	always @(negedge cc_hip_pg_if.pmc_phy_pwr_en) begin
		#10ns;
	        phy_pmc_pwr_stable		<= 'h0;
	end

        always @(negedge cc_hip_pg_if.pmc_phy_sbwake) begin
		#10ns;
	        phy_pmc_sbpwr_stable		<= 'h0;
	end

	always @(negedge cc_hip_pg_if.soc_phy_pwr_req) begin
		#10ns;
	        phy_soc_pwr_ack	        	<= 'h0;
	end

	always @(negedge cc_hip_pg_if.pmc_phy_pmctrl_pwr_en) begin
		#10ns;
	        phy_pmc_pmctrl_pwr_stable      	<= 'h0;
	end

        //----------------------------------------------------------//

	// Generate Clock
	initial
	begin: gen_clk
		clock <= 1'b0;
		forever begin
			#5ns 
			clock      <= ~clock;
		end
	end: gen_clk
	initial
	begin: gen_jtag_clk
		jtag_clock <= 1'b0;
		forever begin
			#11ns 
			jtag_clock      <= ~jtag_clock;
		end
	end: gen_jtag_clk

	// Display which Saola componants are not used
	initial begin
		sla_pkg::sla_vif_container #(virtual PowerGatingNoParamIF) iFContainer;
		sla_pkg::sla_vif_container #(virtual PowerGatingSIPIF) iFContainer_sip;		

		`ifdef DO_NOT_USE_RM
			$display("No Saola RM");    
		`endif
		`ifdef DO_NOT_USE_SM 
			$display("No Saola SM");  
		`endif
		`ifdef DO_NOT_USE_FUSE
			$display("No Saola FUSE"); 
		`endif
		`ifdef DO_NOT_USE_IM   
			$display("No Saola IM"); 
		`endif
		`ifdef DO_NOT_USE_RAL 
			$display("No Saola RAL");  
		`endif

		iFContainer = new({"IFContainer"});
        iFContainer.set_v_if(ccTI.pgIF);
        set_config_object("*", "envIFContainer",iFContainer,0);
	`ifdef CHASSIS_PG_P2
		iFContainer_sip = new({"IFContainer_sip"});
        iFContainer_sip.set_v_if(kvm_if);
        set_config_object("*", "sipIFContainer",iFContainer_sip,0);
	`endif
		ovm_top.phase_timeout = 500000ns;  //sets max run length
		run_test ();		
	end
endmodule : PowerGatingTestbenchTop


