

//cover state in PWRON and ACC PG
//set per instance = 1
covergroup cov_pon_acc_state;
	option.per_instance = 1;
	option.comment = "Cover PWRON and Accessible PG state";
	pon_acc: coverpoint state {
		bins pon_state = {PowerGating::PWRON};
		bins acc_pg_state = {PowerGating::ACPOF};
		}
endgroup

//cover state where IP is woken up by pmc_wake from acc state 
covergroup cov_pmc_wake_in_acc_state; 
	option.per_instance = 1;
	option.comment = "Covers IP is woken up by pmc_wake from accessible POFF state";
	in_acc: coverpoint state {
		bins acc_pg_state = {PowerGating::ACPOF};
	}
endgroup

//cover state sw_pg_req_b asserted when pmc_wake is asserted. IP must not power gate
covergroup cov_sw_pg_asd_pmc_wake1; 
	option.per_instance = 1;
	option.comment = "Covers state where sw_pg_req_b deasserts when IP is in Acc PG state.";
	pmc_wake: coverpoint vif.pmc_ip_pg_wake[cfg.cfg_sip_pgcb[i].pmc_wake_index] {
		bins pmc_wake_asserted = {1};
	}
endgroup


//cover state INACC-POFF
//this needs a disable condition
//set per instance = 1
covergroup cov_inacc_state;
	option.per_instance = 1;
	option.comment = "Covers In-Accessible PG state";
	incc: coverpoint state {
		bins inacc_poff_state = {PowerGating::INAPF};
		}
endgroup
covergroup cov_pmc_wake_in_inacc_state; 
	option.per_instance = 1;
	option.comment = "Covers IP is woken up by pmc_wake from inaccessible POFF and PON state";
	inacc: coverpoint state {
		bins inacc_poff_state = {PowerGating::INAPF};
		bins inacc_pon_state = {PowerGating::INAPN};
	}
endgroup






