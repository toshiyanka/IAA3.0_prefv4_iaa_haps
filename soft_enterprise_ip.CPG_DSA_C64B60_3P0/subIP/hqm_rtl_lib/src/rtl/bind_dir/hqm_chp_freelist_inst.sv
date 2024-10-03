`ifdef INTEL_INST_ON

module hqm_chp_freelist_inst import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*; ();

`ifdef INTEL_INST_ON

  logic      hqm_gated_clk;
  logic      hqm_gated_rst_n;

  logic      freelist_push_v;
  chp_flid_t freelist_push_data;

  logic      freelist_pop_v;
  chp_flid_t freelist_pop_data;
  logic      freelist_pop_v_0f;
  logic      freelist_pop_v_1f;
  logic      freelist_pop_v_2f;

  assign hqm_gated_clk = hqm_chp_freelist.clk;
  assign hqm_gated_rst_n = hqm_chp_freelist.rst_n;

  assign freelist_pop_v = hqm_credit_hist_pipe_core.freelist_pop_v;
  assign freelist_push_v = hqm_credit_hist_pipe_core.freelist_push_v;
  assign freelist_push_data = hqm_credit_hist_pipe_core.freelist_push_data;
  assign freelist_pop_data = hqm_credit_hist_pipe_core.freelist_pop_data;


  always_ff @( posedge hqm_gated_clk or negedge hqm_gated_rst_n ) begin
    if ( ~ hqm_gated_rst_n ) begin
      freelist_pop_v_0f <= '0;
      freelist_pop_v_1f <= '0;
      freelist_pop_v_2f <= '0;
    end
    else begin
      freelist_pop_v_0f <= freelist_pop_v;
      freelist_pop_v_1f <= freelist_pop_v_0f;
      freelist_pop_v_2f <= freelist_pop_v_1f;
    end
  end

  always_ff @( posedge hqm_gated_clk ) begin
    if ($test$plusargs("HQM_DEBUG_LOW") | $test$plusargs("HQM_DEBUG_MED") | $test$plusargs("HQM_DEBUG_HIGH")) begin

      if ( hqm_gated_rst_n & hqm_credit_hist_pipe_core.reset_pf_done_f & freelist_push_v) begin
        $display("@%0tps [CHP_DEBUG] hqm_chp_freelist: push flid:0x%h par:%0d bank:0x%h bflid:0x%h"
                 , $time
                 , freelist_push_data.flid
                 , freelist_push_data.flid_parity
                 , freelist_push_data.flid[13:11]
                 , freelist_push_data.flid[10:0]
                 );
      end

      if ( hqm_gated_rst_n & hqm_credit_hist_pipe_core.reset_pf_done_f & freelist_pop_v_2f) begin
        $display("@%0tps [CHP_DEBUG] hqm_chp_freelist: pop flid:0x%h par:%0d bank:0x%h bflid:0x%h"
                 , $time
                 , freelist_pop_data.flid
                 , freelist_pop_data.flid_parity
                 , freelist_pop_data.flid[13:11]
                 , freelist_pop_data.flid[10:0]
                 );
      end

    end // if ($test$plusargs("HQM_DEBUG_LOW") | $test$plusargs("HQM_DEBUG_MED") | $test$plusargs("HQM_DEBUG_HIGH")) begin
  end // always_ff

`endif

task eot_check ( output bit pf );
  pf = 1'b0 ; //pass

endtask : eot_check

endmodule

bind hqm_chp_freelist hqm_chp_freelist_inst i_hqm_chp_freelist_inst();

`endif
