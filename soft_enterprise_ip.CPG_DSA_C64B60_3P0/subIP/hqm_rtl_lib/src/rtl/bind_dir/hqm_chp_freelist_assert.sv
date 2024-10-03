`ifdef INTEL_INST_ON

`ifndef INTEL_SVA_OFF

module hqm_chp_freelist_assert import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*; ();

  logic hqm_gated_clk;
  logic hqm_gated_rst_n;

  logic freelist_push_v;
  chp_flid_t freelist_push_data;
  logic      freelist_pop_v;
  chp_flid_t freelist_pop_data;
  logic freelist_pop_error;
  logic freelist_push_parity_chk_error;

  logic freelist_pop_v_0_f;
  logic freelist_pop_v_1_f;
  logic freelist_pop_v_2_f;
  logic freelist_push_v_on_inactive_flid_nxt, freelist_push_v_on_inactive_flid_f;

  assign hqm_gated_clk = hqm_chp_freelist.clk; 
  assign hqm_gated_rst_n = hqm_chp_freelist.rst_n;
  assign freelist_push_v = hqm_chp_freelist.freelist_push_v;
  assign freelist_push_data = hqm_chp_freelist.freelist_push_data;
  assign freelist_pop_v = hqm_chp_freelist.freelist_pop_v;
  assign freelist_pop_data = hqm_chp_freelist.freelist_pop_data;
  assign freelist_pop_error = hqm_chp_freelist.freelist_pop_error;
  assign freelist_push_parity_chk_error = hqm_chp_freelist.freelist_push_parity_chk_error;

  logic [NUM_CREDITS_PBANK-1:0]    flid_active_f   [NUM_CREDITS_BANKS-1:0];
  logic [NUM_CREDITS_PBANK-1:0]    flid_active_nxt [NUM_CREDITS_BANKS-1:0];

  logic flid_parity_error_mask ;

always_comb begin
   flid_parity_error_mask = 1'b0 ;

   if ($test$plusargs("HQM_CHP_FLID_PARITY_ERROR_INJECTION_TEST") ) begin
     flid_parity_error_mask = flid_parity_error_mask | ( freelist_push_parity_chk_error ) ;
   end

   freelist_push_v_on_inactive_flid_nxt = 1'b0; 

   for ( int i=0; i<8; i=i+1) begin
        flid_active_nxt[i] = flid_active_f[i];
   end

   if (freelist_pop_v_2_f) begin
        flid_active_nxt[freelist_pop_data.flid[NUM_CREDITS_PBANK_WIDTH +: 3]][freelist_pop_data[NUM_CREDITS_PBANK_WIDTH-1:0]] = 1'b1;
   end

   if (freelist_push_v & ~freelist_push_parity_chk_error ) begin
        flid_active_nxt[freelist_push_data.flid[NUM_CREDITS_PBANK_WIDTH +: 3]][freelist_push_data[NUM_CREDITS_PBANK_WIDTH-1:0]] = 1'b0;
   end

   // set bit if flid being pushed has not bee poped
   if ( freelist_push_v & ~freelist_push_parity_chk_error & ~flid_active_f[freelist_push_data.flid[NUM_CREDITS_PBANK_WIDTH +: 3]][freelist_push_data[NUM_CREDITS_PBANK_WIDTH-1:0]] ) begin
     freelist_push_v_on_inactive_flid_nxt = 1'b1;
   end

end

always_ff @( posedge hqm_gated_clk or negedge hqm_gated_rst_n ) begin
  if ( ~ hqm_gated_rst_n ) begin
    freelist_pop_v_0_f <= '0;
    freelist_pop_v_1_f <= '0;
    freelist_pop_v_2_f <= '0;
    freelist_push_v_on_inactive_flid_f <= 1'b0;

    for ( int i=0; i<8; i=i+1) begin
        flid_active_f[i] <= '0;
    end

  end
  else begin
    freelist_pop_v_0_f <= freelist_pop_v;
    freelist_pop_v_1_f <= freelist_pop_v_0_f;
    freelist_pop_v_2_f <= freelist_pop_v_1_f;

    freelist_push_v_on_inactive_flid_f <= freelist_push_v_on_inactive_flid_nxt;

    for ( int i=0; i<8; i=i+1) begin
        flid_active_f[i] <= flid_active_nxt[i];
    end

  end
end

`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_freelist_push_v_on_inactive_flid
                      , freelist_push_v_on_inactive_flid_f 
                      , posedge hqm_gated_clk
                      , ~ hqm_gated_rst_n
                      , `HQM_SVA_ERR_MSG( "Error: assert_forbidden_freelist_push_v_on_inactive_flid : freelist_push_v on inactive flid" )
                      , SDG_SVA_SOC_SIM
                      )


`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_freelist_pop_error
                      , freelist_pop_error 
                      , posedge hqm_gated_clk
                      , ~ hqm_gated_rst_n
                      , `HQM_SVA_ERR_MSG( "Error: assert_freelist_pop_error: freelist_pop_v request valid but no entries to pop. Check cfg" )
                      , SDG_SVA_SOC_SIM
                      )

`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_freelist_push_parity_chk_error
                      , ( freelist_push_parity_chk_error & ~ flid_parity_error_mask )
                      , posedge hqm_gated_clk
                      , ~ hqm_gated_rst_n
                      , `HQM_SVA_ERR_MSG( "Error: assert_freelist_push_parity_chk_error: freelist_push_v/freelist_pf_push_v parity error detected on flid being pushed" )
                      , SDG_SVA_SOC_SIM
                      )

endmodule

bind hqm_chp_freelist hqm_chp_freelist_assert i_hqm_chp_freelist_assert();

`endif

`endif
