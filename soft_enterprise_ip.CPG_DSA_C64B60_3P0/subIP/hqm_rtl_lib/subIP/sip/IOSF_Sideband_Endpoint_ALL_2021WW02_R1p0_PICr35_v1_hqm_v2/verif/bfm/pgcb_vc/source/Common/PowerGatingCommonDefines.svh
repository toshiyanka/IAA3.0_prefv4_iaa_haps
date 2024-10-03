
`define chassis_power_gating_error(CHECK_ID,  MSG) \
		if(cfg.disable_all_checks == 0 && !$test$plusargs("CHASSIS_PG_DISABLE_ALL_CHECKS")) begin \
			`ovm_error(CHECK_ID, MSG) \
		end \
