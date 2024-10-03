

	genvar gen_var;
	/**********************************
	//MACRO
	***********************************/
	`define chassis_pg_coverage(NAME, PROP) \
			NAME: cover property (@(posedge clk) disable iff (reset_b !== 1) PROP); \
	
	`define chassis_dfx_coverage(NAME, PROP) \
			NAME: cover property (@(posedge jtag_tck) disable iff (reset_b !== 1) PROP); \

	//Bug fix HSDES 1204719334 for REQNAME
	`define chassis_pg_full_handshake(REQNAME, ACKNAME, REQ, ACK) \
		a_``REQNAME``Rose:assert property( \
			@(posedge clk) \
			disable iff (reset_b !== 1) \
			$rose(``REQ``[gen_var]) && $past(``REQ``[gen_var]) === 0 \
			|-> (``ACK``[gen_var] === 0 || $past(``ACK``[gen_var]) === 0) \
		); \
		a_``REQNAME``Fell:assert property( \
			@(posedge clk) \
			disable iff (reset_b !== 1) \
			$fell(``REQ``[gen_var]) && $past(``REQ``[gen_var]) === 1 \
			|-> (``ACK``[gen_var] === 1 || $past(``ACK``[gen_var]) === 1) \
		); \
		a_``ACKNAME``Rose:assert property( \
			@(posedge clk) \
			disable iff (reset_b !== 1) \
			$rose(``ACK``[gen_var]) \
			|-> (``REQ``[gen_var] === 1 || $past(``REQ``[gen_var]) === 1) \
		); \
		a_``ACKNAME``Fell:assert property( \
			@(posedge clk) \
			disable iff (reset_b !== 1) \
			$fell(``ACK``[gen_var]) \
			|-> (``REQ``[gen_var] === 0 || $past(``REQ``[gen_var]) === 0) \
		); \
		a_``ACKNAME``GateFuture:assert property( \
			@(posedge clk) \
			disable iff(reset_b !== 1) \
			$fell(``REQ``[gen_var]) \
			|-> (``ACK``[gen_var] === 0 [->1]) \
		); \
		a_``ACKNAME``UngateFuture:assert property( \
			@(posedge clk) \
			disable iff(reset_b !== 1) \
			$rose(``REQ``[gen_var]) \
			|-> (``ACK``[gen_var] === 1 [->1]) \
		); \

	/**********************************
	// Assertions and coverage
	***********************************/
	//fet handshake
	generate for (gen_var = 0; gen_var < NUM_FET; gen_var = gen_var + 1)		
		begin: generate_fet_assertions_cov
			if(NO_SIP_PGCB == 0 || NO_FAB_PGCB === 0) begin : fet_handshake_gen
				`chassis_pg_full_handshake(FetEn, FetEnAck, fet_en_b, fet_en_ack_b)
			`ifndef DISABLE_CHASSIS_POWER_GATING_COVERAGE
				//coverage
				`chassis_pg_coverage(cov_fet_fell, $fell(fet_en_b[gen_var]))
				`chassis_pg_coverage(cov_fet_rose, $rose(fet_en_b[gen_var]))
			`endif
			end
		end: generate_fet_assertions_cov
	endgenerate


	//SIP handshake
	generate for (gen_var = 0; gen_var < NUM_SIP_PGCB; gen_var = gen_var + 1) 
		begin: generate_sip_assertions_cov
			if(NO_SIP_PGCB == 0) begin : sip_handshake_gen
				//check
				`chassis_pg_full_handshake(SIPPGReq, SIPPGAck, ip_pmc_pg_req_b, pmc_ip_pg_ack_b)	
			`ifndef DISABLE_CHASSIS_POWER_GATING_COVERAGE
				//coverage
				//pg req/ack
				`chassis_pg_coverage(cov_pg_req_ack_rose, $rose(ip_pmc_pg_req_b[gen_var]) |-> $rose(pmc_ip_pg_ack_b[gen_var]) [->1])
				`chassis_pg_coverage(cov_pg_req_ack_fell, $fell(ip_pmc_pg_req_b[gen_var]) |-> $fell(pmc_ip_pg_ack_b[gen_var]) [->1])	
				//restore
				`chassis_pg_coverage(cov_restore_fell, $fell(pmc_ip_restore_b[gen_var]))
				//sw_pg_req assertionm followed by pg_req_b assertion. Still does not check that all other PG conditions are false. So this is not complete.
				//TODO: this does not apply for fabric interface
				`chassis_pg_coverage(cov_sw_pg_fell, $fell(pmc_ip_sw_pg_req_b[gen_var]) && ip_pmc_pg_req_b[gen_var] == 1 |-> $fell(ip_pmc_pg_req_b[gen_var]) [->1])
				//deassert sw_pg_req-b when IP is in acc pg state. IP must not wake up
				`chassis_pg_coverage(cov_sw_pg_rose, $rose(pmc_ip_sw_pg_req_b[gen_var]) && ip_pmc_pg_req_b[gen_var] == 0)				
			`endif
			end
		end: generate_sip_assertions_cov
	endgenerate

	
	//SIP VNN_ACK_REQ
	generate for (gen_var = 0; gen_var < NUM_VNN_ACK_REQ; gen_var = gen_var + 1) 
		begin: generate_sip_vnn_ack_req_assertions
				//check
				a_IpPmcVnnReqRose:assert property(
					@(posedge clk)
					disable iff (reset_b !== 1)
					$rose(ip_pmc_vnn_req[gen_var]) 
					|-> pmc_ip_vnn_ack[gen_var] === 0				   
				);
				a_IpPmcVnnReqfell:assert property(
					@(posedge clk)
					disable iff (reset_b !== 1)
					$fell(ip_pmc_vnn_req[gen_var]) 
					|-> ##[1:$] $fell(pmc_ip_vnn_ack[gen_var])				   
				);

				a_PmcIpVnnReqFell:assert property(
					@(posedge clk)
					disable iff (reset_b !== 1)
					$fell(pmc_ip_vnn_ack[gen_var]) 
					|-> ip_pmc_vnn_req[gen_var] === 0				   
				);
				a_IpPmcVnnReqRoseVSPmcIpVnnAckRose:assert property(
					@(posedge clk)
					disable iff (reset_b !== 1)
					$rose(ip_pmc_vnn_req[gen_var]) 
					|-> ##[1:$] $rose(pmc_ip_vnn_ack[gen_var])				   
				);

		end: generate_sip_vnn_ack_req_assertions
	endgenerate


	//cover bypass and override signals
	`ifdef ENABLE_PG_DFX_COVERAGE
	generate for (gen_var = 0; gen_var < NUM_SIP_PGCB; gen_var = gen_var + 1) 
		begin: generate_dfx_cov
			if(NO_SIP_PGCB == 0) begin
				//rose bypass when ovd = 0
				`chassis_dfx_coverage(cov_bypass_rose_ovr0, $rose(fdfx_pgcb_bypass[gen_var]) && fdfx_pgcb_ovr[gen_var] == 0)	
				//rose ovd when bypass = 1
				`chassis_dfx_coverage(cov_ovr_rose_bypass1, $rose(fdfx_pgcb_ovr[gen_var]) && fdfx_pgcb_bypass[gen_var] == 1)	
				//rose of both together
				`chassis_dfx_coverage(cov_rose_ovr_bypass, $rose(fdfx_pgcb_ovr[gen_var]) && $rose(fdfx_pgcb_bypass[gen_var]))	
			end
		end: generate_dfx_cov
	endgenerate
	`endif


	`ifndef DISABLE_CHASSIS_POWER_GATING_COVERAGE
	`ifndef DISABLE_CHASSIS_PG_PERMUTE_COV
	covergroup cov_permute_acc_state @(pmc_ip_pg_ack_b);
		option.comment = "Cover each PGCB in Acc state while other PGCBs are in Pwron state";
		permute_acc_states: coverpoint pmc_ip_pg_ack_b iff (($countones(side_pok) == NUM_SB_EP) && ($countones(prim_pok) == NUM_PRIM_EP || NO_PRIM_EP));
	endgroup
	cov_permute_acc_state cover_permute_acc_state = new();
	//permute pmc_wake in Acc state as well as inaccessible state.
	covergroup cov_permute_pmc_wake_inacc @(pmc_ip_pg_wake);
		option.comment = "Cover each PGCB receiving pmc_wake in different order while in Acc state";
		permute_pmc_wake_inacc: coverpoint pmc_ip_pg_wake iff (($countones(side_pok) == 0) && ($countones(prim_pok) == 0 || NO_PRIM_EP));
	endgroup
	cov_permute_pmc_wake_inacc cover_permute_pmc_wake_inacc = new();

	`endif
	// cover reset deassertion
	pgcb_reset_deassertion: cover property (@(posedge clk) $rose(reset_b));	
	//cover pmc_wake
	generate for (gen_var = 0; gen_var < NUM_PMC_WAKE; gen_var = gen_var + 1) 
		begin: generate_wake_cov
			`chassis_pg_coverage(cov_pmc_wake_rose, $rose(pmc_ip_pg_wake[gen_var]))
		end: generate_wake_cov
	endgenerate
	//cover pok
	generate for (gen_var = 0; gen_var < NUM_SB_EP; gen_var = gen_var + 1) 
		begin: generate_side_pok_cov
			`chassis_pg_coverage(cov_side_pok_rose, $rose(side_pok[gen_var]))
			`chassis_pg_coverage(cov_side_pok_fell, $fell(side_pok[gen_var]))
		end: generate_side_pok_cov
	endgenerate
	generate for (gen_var = 0; gen_var < NUM_PRIM_EP; gen_var = gen_var + 1) 
		begin: generate_prim_pok_cov
			if(NO_PRIM_EP == 0) begin : prim_pok_cov_gen
				`chassis_pg_coverage(cov_prim_pok_rose, $rose(prim_pok[gen_var]))
				`chassis_pg_coverage(cov_prim_pok_fell, $fell(prim_pok[gen_var]))
			end
		end: generate_prim_pok_cov
	endgenerate
	`endif

	//fabric handshake
	generate for (gen_var = 0; gen_var < NUM_FAB_PGCB; gen_var = gen_var + 1) 
	begin: generate_fabric_assertions_cov
	if(NO_FAB_PGCB === 0) begin : fab_assn_gen
	
		a_FabPGReqFell:assert property(
			@(posedge clk)
			disable iff (reset_b !== 1)
			$fell(pmc_fab_pg_rdy_req_b[gen_var]) 
			|-> (fab_pmc_pg_rdy_ack_b[gen_var] === 1) || (fab_pmc_pg_rdy_nack_b[gen_var] === 1)				   
		);
		a_FabPGReqRose:assert property(
			@(posedge clk)
			disable iff (reset_b !== 1)
			$rose(pmc_fab_pg_rdy_req_b[gen_var]) 

			  |-> ((fab_pmc_pg_rdy_ack_b[gen_var] ^ fab_pmc_pg_rdy_nack_b[gen_var]) === 1'b1)			   
		);
		a_FabPGAckRose:assert property(
			@(posedge clk)
			disable iff (reset_b !== 1)
			$rose(fab_pmc_pg_rdy_ack_b[gen_var]) 
			|-> (pmc_fab_pg_rdy_req_b[gen_var] === 1'b1)
			);
		a_FabPGAckFell:assert property(
			@(posedge clk)
			disable iff (reset_b !== 1)
			$fell(fab_pmc_pg_rdy_ack_b[gen_var]) 
			|-> (pmc_fab_pg_rdy_req_b[gen_var] === 1'b0)
			);
		
		a_FabPGNackRose:assert property(
			@(posedge clk)
			disable iff (reset_b !== 1)
			$rose(fab_pmc_pg_rdy_nack_b[gen_var]) 
			|-> (pmc_fab_pg_rdy_req_b[gen_var] === 1'b1)
			);
		a_FabPGNackFell:assert property(
			@(posedge clk)
			disable iff (reset_b !== 1)
			$fell(fab_pmc_pg_rdy_nack_b[gen_var]) 
			|-> (pmc_fab_pg_rdy_req_b[gen_var] === 1'b0)
			);
		a_AckNackMutex:assert property(
			@(posedge clk)
			disable iff (reset_b !== 1)
			((fab_pmc_pg_rdy_ack_b[gen_var] | fab_pmc_pg_rdy_nack_b[gen_var]) === 1'b1)
			);

		a_FabPGReqFutureAck:assert property(
			@(posedge clk)
			disable iff (reset_b !== 1)
			$fell(pmc_fab_pg_rdy_req_b[gen_var]) 
			|-> ((fab_pmc_pg_rdy_ack_b[gen_var] === 0) || (fab_pmc_pg_rdy_nack_b[gen_var] === 0))[->1]				   
		);
		a_FabUGReqFutureAck:assert property(
			@(posedge clk)
			disable iff (reset_b !== 1)
			$rose(pmc_fab_pg_rdy_req_b[gen_var]) 
			  |-> (fab_pmc_pg_rdy_ack_b[gen_var] === 1'b1) [->1]		   
		);
	`ifndef DISABLE_CHASSIS_POWER_GATING_COVERAGE
		//coverage
		//fab idle
		`chassis_pg_coverage(cov_fab_idle_rose, $rose(ip_pmc_pg_req_b[gen_var]))
		`chassis_pg_coverage(cov_fab_idle_fell, $fell(ip_pmc_pg_req_b[gen_var]))
		//pg req/ack
		`chassis_pg_coverage(cov_fab_pg_req_rose, $rose(pmc_fab_pg_rdy_req_b[gen_var]) |-> $rose(fab_pmc_pg_rdy_ack_b[gen_var]) [->1])
		`chassis_pg_coverage(cov_fab_pg_req_fell_ack, $fell(pmc_fab_pg_rdy_req_b[gen_var]) |-> $fell(fab_pmc_pg_rdy_ack_b[gen_var]) [->1])
		`chassis_pg_coverage(cov_fab_pg_req_fell_nack, $fell(pmc_fab_pg_rdy_req_b[gen_var]) |-> $fell(fab_pmc_pg_rdy_nack_b[gen_var]) [->1])
	`endif
	end	
	end: generate_fabric_assertions_cov

	endgenerate


