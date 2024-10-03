`ifdef INTEL_INST_ON

module hqm_pm_unit_inst import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*; ();

`ifdef INTEL_INST_ON

logic side_rst_b;
logic prim_freerun_clk;
logic [1:0] pm_state;
logic pgcb_clk;

logic pgcb_fet_en_b;
logic pgcb_isol_en_b;
logic prim_freerun_prim_gated_rst_b_sync;
logic pmsm_pgcb_req_b;
logic fuse_force_on;
logic fuse_proc_disable;
logic [1:0] pm_state_f;
logic [1:0] pmsm_state_f;
logic [1:0] pmsm_state_nxt;

logic    pm_fsm_d0tod3_ok;
logic pm_fsm_d3tod0_ok;
logic hqm_clk_enable_int;

assign side_rst_b = hqm_pm_unit.side_rst_b;
assign prim_freerun_clk = hqm_pm_unit.prim_freerun_clk;
assign pm_state = hqm_pm_unit.pm_state;
assign pgcb_clk = hqm_pm_unit.pgcb_clk;
assign pgcb_fet_en_b     = hqm_pm_unit.pgcb_fet_en_b;
assign pgcb_isol_en_b    = hqm_pm_unit.pgcb_isol_en_b;
assign prim_freerun_prim_gated_rst_b_sync    = hqm_pm_unit.prim_freerun_prim_gated_rst_b_sync;
assign pmsm_pgcb_req_b   = hqm_pm_unit.pmsm_pgcb_req_b;
assign fuse_force_on     = hqm_pm_unit.fuse_force_on;
assign fuse_proc_disable = hqm_pm_unit.fuse_proc_disable;
assign pmsm_state_f      = hqm_pm_unit.pmsm_state_f;
assign pmsm_state_nxt    = hqm_pm_unit.i_hqm_pmsm.pmsm_state_nxt;
assign pgcb_pmc_pg_req_b = hqm_pm_unit.pgcb_pmc_pg_req_b;
assign pmc_pgcb_pg_ack_b = hqm_pm_unit.pmc_pgcb_pg_ack_b;

assign pm_fsm_d0tod3_ok = hqm_pm_unit.pm_fsm_d0tod3_ok;
assign pm_fsm_d3tod0_ok = hqm_pm_unit.pm_fsm_d3tod0_ok;
assign hqm_clk_enable_int = hqm_pm_unit.hqm_clk_enable_int;


///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
logic side_rst_b_f;

logic prim_freerun_prim_gated_rst_b_sync_f;
logic pmsm_pgcb_req_b_f;

logic prim_reset_released;
logic cfg_pm_pmcsr_disable_f;
logic cfg_pm_pmcsr_disable_change;
logic cfg_pm_pmcsr_disable_change_f;

always_ff @(posedge pgcb_clk) begin

  cfg_pm_pmcsr_disable_change_f = cfg_pm_pmcsr_disable_change;

end

always_ff @(posedge prim_freerun_clk ) begin
 side_rst_b_f <= side_rst_b;
 prim_freerun_prim_gated_rst_b_sync_f <= prim_freerun_prim_gated_rst_b_sync;
 pm_state_f <= pm_state;
 pmsm_pgcb_req_b_f <= pmsm_pgcb_req_b;
 cfg_pm_pmcsr_disable_f <= hqm_pm_unit.cfg_pm_pmcsr_disable_f.DISABLE;
end

assign prim_reset_released = prim_freerun_prim_gated_rst_b_sync & ~prim_freerun_prim_gated_rst_b_sync_f;
assign cfg_pm_pmcsr_disable_change = (cfg_pm_pmcsr_disable_f!=hqm_pm_unit.cfg_pm_pmcsr_disable.DISABLE) & prim_freerun_prim_gated_rst_b_sync;


  always_ff @(posedge prim_freerun_clk) begin

  //if ($test$plusargs("HQM_DEBUG_LOW") | $test$plusargs("HQM_DEBUG_MED") | $test$plusargs("HQM_DEBUG_HIGH")) begin

        if (pmsm_state_nxt != pmsm_state_f) $display ("@%0tps, [PM_UNIT_DEBUG] PMSM transition from PMSM:%s->PMSM:%s " , $time, hqm_pm_unit.pmsm_state_f.name,hqm_pm_unit.i_hqm_pmsm.pmsm_state_nxt.name); 
        if ($rose(prim_freerun_prim_gated_rst_b_sync))          $display ("@%0tps, [PM_UNIT_DEBUG] prim_freerun_prim_gated_rst_b_sync               deasserted." , $time);
	if ($fell(prim_freerun_prim_gated_rst_b_sync))          $display ("@%0tps, [PM_UNIT_DEBUG] prim_freerun_prim_gated_rst_b_sync                 asserted." , $time);
        


        if ($rose(hqm_clk_enable_int))          $display ("@%0tps, [PM_UNIT_DEBUG] hqm_clk_enable_int                 asserted.", $time);
        if ($fell(hqm_clk_enable_int))          $display ("@%0tps, [PM_UNIT_DEBUG] hqm_clk_enable_int               deasserted.", $time);

        if (prim_reset_released ) begin
          $display ("@%0tps, [PM_UNIT_DEBUG] Reset Released pm_state:%s" , $time, hqm_pm_unit.pm_state.name);
          $display ("@%0tps, [PM_UNIT_DEBUG] cfg_pm_pmcsr_disable:%h" , $time, hqm_pm_unit.cfg_pm_pmcsr_disable.DISABLE);
          $display ("@%0tps, [PM_UNIT_DEBUG] fuse_force_on:%h" , $time, fuse_force_on);
          $display ("@%0tps, [PM_UNIT_DEBUG] fuse_proc_disable:%h" , $time, fuse_proc_disable);
        end
        
        if ((pm_state_f != pm_state))  $display ("@%0tps, [PM_UNIT_DEBUG] >>>>>>>>>>>>>>>>>>>>>>>>>>>>  pm_state_nxt:%s " , $time, hqm_pm_unit.pm_state.name);
        
        if ($fell(hqm_pm_unit.cfg_pm_pmcsr_disable_f.DISABLE)) $display ("@%0tps, [PM_UNIT_DEBUG] cfg_pm_pmcsr_disable.DISABLE deasserted." , $time);

  //end

  end // always_ff

  // pgcb_clk related 
  always_ff @(posedge prim_freerun_clk) begin

//   if ($test$plusargs("HQM_DEBUG_LOW") | $test$plusargs("HQM_DEBUG_MED") | $test$plusargs("HQM_DEBUG_HIGH")) begin


        if ($rose(side_rst_b))              $display ("@%0tps, [PM_UNIT_DEBUG] side_rst_b                   deasserted." , $time);
        if ($fell(side_rst_b))              $display ("@%0tps, [PM_UNIT_DEBUG] side_rst_b                     asserted." , $time);
                                            
        if ($rose(pgcb_fet_en_b))           $display ("@%0tps, [PM_UNIT_DEBUG] pgcb_fet_en_b                deasserted." , $time);
        if ($fell(pgcb_fet_en_b))           $display ("@%0tps, [PM_UNIT_DEBUG] pgcb_fet_en_b                  asserted." , $time);
                                                                                                       
        // looking for rising edge                                                                     
        if ($rose(pgcb_isol_en_b))          $display ("@%0tps, [PM_UNIT_DEBUG] pgcb_isol_en_b               deasserted.", $time);
        if ($fell(pgcb_isol_en_b))          $display ("@%0tps, [PM_UNIT_DEBUG] pgcb_isol_en_b                 asserted.", $time);
                                                                                                          
        if ($rose(pm_fsm_d0tod3_ok))        $display ("@%0tps, [PM_UNIT_DEBUG] pm_fsm_d0tod3_ok               asserted.", $time);
        if ($fell(pm_fsm_d0tod3_ok))        $display ("@%0tps, [PM_UNIT_DEBUG] pm_fsm_d0tod3_ok             deasserted.", $time);
                                                                                                          
        if ($rose(pm_fsm_d3tod0_ok))        $display ("@%0tps, [PM_UNIT_DEBUG] pm_fsm_d3tod0_ok               asserted.", $time);
        if ($fell(pm_fsm_d3tod0_ok))        $display ("@%0tps, [PM_UNIT_DEBUG] pm_fsm_d3tod0_ok             deasserted.", $time);
                                                                                                          
                                                                                                          
        if ($rose(pgcb_pmc_pg_req_b))       $display ("@%0tps, [PM_UNIT_DEBUG] pgcb_pmc_pg_req_b           deasserrted.", $time);
        if ($fell(pgcb_pmc_pg_req_b))       $display ("@%0tps, [PM_UNIT_DEBUG] pgcb_pmc_pg_req_b              asserted.", $time);
                                                                                                          
        if ($rose(pmc_pgcb_pg_ack_b))       $display ("@%0tps, [PM_UNIT_DEBUG] pmc_pgcb_pg_ack_b           deasserrted.", $time);
        if ($fell(pmc_pgcb_pg_ack_b))       $display ("@%0tps, [PM_UNIT_DEBUG] pmc_pgcb_pg_ack_b              asserted.", $time);
                                                                                                          
        if ($fell(pmsm_pgcb_req_b))         $display ("@%0tps, [PM_UNIT_DEBUG] pmsm_pgcb_req_b                asserted.", $time); 
        if ($rose(pmsm_pgcb_req_b))         $display ("@%0tps, [PM_UNIT_DEBUG] pmsm_pgcb_req_b              deasserted.", $time); 
        
//   end

  end // always_ff



















`endif

task eot_check ( output bit pf );
  pf = 1'b0 ; //pass

endtask : eot_check

endmodule

bind hqm_pm_unit hqm_pm_unit_inst i_hqm_pm_unit_inst();

`endif
