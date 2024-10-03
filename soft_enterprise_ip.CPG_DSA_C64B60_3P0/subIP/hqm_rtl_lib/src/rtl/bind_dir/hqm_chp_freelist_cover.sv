`ifdef INTEL_INST_ON

module hqm_chp_freelist_cover import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*; ();

  logic      hqm_gated_rst_n;
  logic      hqm_gated_clk;

  logic      freelist_push_v;
  chp_flid_t freelist_push_data;

  logic      freelist_pop_v;
  chp_flid_t freelist_pop_data;
  logic      freelist_pop_v_0f;
  logic      freelist_pop_v_1f;
  logic      freelist_pop_v_2f;

  assign hqm_gated_clk = hqm_chp_freelist.clk;
  assign hqm_gated_rst_n = hqm_chp_freelist.rst_n;

  assign freelist_pop_v = hqm_chp_freelist.freelist_pop_v;
  assign freelist_push_v = hqm_chp_freelist.freelist_push_v;
  assign freelist_push_data = hqm_chp_freelist.freelist_push_data;
  assign freelist_pop_data = hqm_chp_freelist.freelist_pop_data;


`ifdef HQM_COVER_ON

  covergroup COVERGROUP @(posedge hqm_gated_clk);

  CP_freelist_push_v : coverpoint { freelist_push_v } iff ( hqm_gated_rst_n )
  {  
          bins BIN0 = (1[* 2:10]);
  }

  CP_freelist_pop_v : coverpoint { freelist_pop_v } iff ( hqm_gated_rst_n )
  {  
          bins BIN0 = (1[* 2:10]);
  }


  endgroup

COVERGROUP u_COVERGROUP = new();



`endif

endmodule


bind hqm_chp_freelist hqm_chp_freelist_cover i_hqm_chp_freelist_cover();

`endif
