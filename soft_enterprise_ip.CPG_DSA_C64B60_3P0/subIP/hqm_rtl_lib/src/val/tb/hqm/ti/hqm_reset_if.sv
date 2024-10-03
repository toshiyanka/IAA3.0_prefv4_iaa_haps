`ifndef HQM_RESET_IF__SV
`define HQM_RESET_IF__SV

interface hqm_reset_if ();

  logic clk;
  logic aon_clk;
  logic powergood_rst_b;
  logic prim_rst_b;
  logic prim_pok;
  logic prim_clkreq;
  logic prim_clkack;
  logic side_pok;
  logic side_clkreq;
  logic side_clkack;
  logic side_clk;
  logic side_rst_b;
  logic ip_block_fp;
  logic [15:0] early_fuses;
  logic ip_ready;                      //-- former config_ack;
  logic reset_prep_ack;
  logic prim_pwrgate_pmc_wake;
  logic side_pwrgate_pmc_wake;
  logic hw_reset_force_pwr_on;
  logic fdfx_sync_rst;
  real  vcccfn_voltage;                 // -- VCCCFN voltage
  logic vcccfn_pwr_on;                  // -- VCCCFN power on indication (1=on)
  real  vcccfn_on_thresh_out;           // -- VCCCFN on voltage threshold
  real  vcccfn_ret_thresh_out;          // -- VCCCFN retentionvoltage threshold
  logic pm_ip_clk_halt_b_2;
  logic pm_ip_vdom_xclk_halt_b_2;
  logic flcp_reset_b;
  logic flcp_clk;
  logic flcp_clk_out;
  logic flcp_slsr_in;
  logic flcp_slsr_out;
  logic lcp_shift_done_status;


  initial begin
    drive_reset_if_initial_val();
  end

  ip_ready_asserts_within_100clks_after_side_rst: assert property (@(posedge side_clk)  disable iff (side_rst_b !== 1'b_1) $rose(side_rst_b) |-> ##[0:100] ip_ready) $display("ip_ready_asserts_within_100clks_after_side_rst PASSED"); 
                                                  else                        $display("ip_ready_asserts_within_100clks_after_side_rst assertion FAILED"); 

 // -- Initial val -- //
  function drive_reset_if_initial_val();
    if ($test$plusargs("HQM_HW_RESET_FORCE_PWR_ON")) begin
       hw_reset_force_pwr_on <= '1;
    end else begin
       hw_reset_force_pwr_on <= '0;
    end
  endfunction

endinterface : hqm_reset_if

`endif

