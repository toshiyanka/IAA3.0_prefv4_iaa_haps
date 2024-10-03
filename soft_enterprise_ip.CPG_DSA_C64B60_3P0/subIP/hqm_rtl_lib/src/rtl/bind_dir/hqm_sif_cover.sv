`ifdef INTEL_INST_ON

module hqm_sif_cover import hqm_AW_pkg::*, hqm_pkg::*, hqm_sif_pkg::*; ();

`ifdef HQM_COVER_ON

  logic [15:0] prim_clk_enable_sys_vec_q;
  logic [15:0] cmd_put_p_vec_q;
  logic [15:0] cmd_put_np_vec_q;
  logic [15:0] cmd_put_cpl_vec_q;

  always_ff @(posedge hqm_sif_core.prim_freerun_clk or negedge hqm_sif_core.prim_rst_b) begin
   if (~hqm_sif_core.prim_rst_b) begin
    prim_clk_enable_sys_vec_q <= '1;
    cmd_put_p_vec_q           <= '0;
    cmd_put_np_vec_q          <= '0;
    cmd_put_cpl_vec_q         <= '0;
   end else begin
    prim_clk_enable_sys_vec_q <= {prim_clk_enable_sys_vec_q[14:0],  hqm_sif_core.prim_clk_enable_sys};
    cmd_put_p_vec_q           <= {          cmd_put_p_vec_q[14:0], (hqm_sif_core.cmd_put & (hqm_sif_core.cmd_rtype==2'd0))};
    cmd_put_np_vec_q          <= {         cmd_put_np_vec_q[14:0], (hqm_sif_core.cmd_put & (hqm_sif_core.cmd_rtype==2'd1))};
    cmd_put_cpl_vec_q         <= {        cmd_put_cpl_vec_q[14:0], (hqm_sif_core.cmd_put & (hqm_sif_core.cmd_rtype==2'd2))};
   end
  end

  covergroup CG_SIF_PRIM_CLK @(posedge hqm_sif_core.prim_freerun_clk);
    CP_P_M7   : coverpoint cmd_put_p_vec_q[15]   & (prim_clk_enable_sys_vec_q==16'hFF00) iff (hqm_sif_core.prim_rst_b);
    CP_P_M6   : coverpoint cmd_put_p_vec_q[14]   & (prim_clk_enable_sys_vec_q==16'hFF00) iff (hqm_sif_core.prim_rst_b);
    CP_P_M5   : coverpoint cmd_put_p_vec_q[13]   & (prim_clk_enable_sys_vec_q==16'hFF00) iff (hqm_sif_core.prim_rst_b);
    CP_P_M4   : coverpoint cmd_put_p_vec_q[12]   & (prim_clk_enable_sys_vec_q==16'hFF00) iff (hqm_sif_core.prim_rst_b);
    CP_P_M3   : coverpoint cmd_put_p_vec_q[11]   & (prim_clk_enable_sys_vec_q==16'hFF00) iff (hqm_sif_core.prim_rst_b);
    CP_P_M2   : coverpoint cmd_put_p_vec_q[10]   & (prim_clk_enable_sys_vec_q==16'hFF00) iff (hqm_sif_core.prim_rst_b);
    CP_P_M1   : coverpoint cmd_put_p_vec_q[ 9]   & (prim_clk_enable_sys_vec_q==16'hFF00) iff (hqm_sif_core.prim_rst_b);
    CP_P_P0   : coverpoint cmd_put_p_vec_q[ 8]   & (prim_clk_enable_sys_vec_q==16'hFF00) iff (hqm_sif_core.prim_rst_b);
    CP_P_P1   : coverpoint cmd_put_p_vec_q[ 7]   & (prim_clk_enable_sys_vec_q==16'hFF00) iff (hqm_sif_core.prim_rst_b);
    CP_P_P2   : coverpoint cmd_put_p_vec_q[ 6]   & (prim_clk_enable_sys_vec_q==16'hFF00) iff (hqm_sif_core.prim_rst_b);
    CP_P_P3   : coverpoint cmd_put_p_vec_q[ 5]   & (prim_clk_enable_sys_vec_q==16'hFF00) iff (hqm_sif_core.prim_rst_b);
    CP_P_P4   : coverpoint cmd_put_p_vec_q[ 4]   & (prim_clk_enable_sys_vec_q==16'hFF00) iff (hqm_sif_core.prim_rst_b);
    CP_P_P5   : coverpoint cmd_put_p_vec_q[ 3]   & (prim_clk_enable_sys_vec_q==16'hFF00) iff (hqm_sif_core.prim_rst_b);
    CP_P_P6   : coverpoint cmd_put_p_vec_q[ 2]   & (prim_clk_enable_sys_vec_q==16'hFF00) iff (hqm_sif_core.prim_rst_b);
    CP_P_P7   : coverpoint cmd_put_p_vec_q[ 1]   & (prim_clk_enable_sys_vec_q==16'hFF00) iff (hqm_sif_core.prim_rst_b);
    CP_P_P8   : coverpoint cmd_put_p_vec_q[ 0]   & (prim_clk_enable_sys_vec_q==16'hFF00) iff (hqm_sif_core.prim_rst_b);
    CP_NP_M7  : coverpoint cmd_put_np_vec_q[15]  & (prim_clk_enable_sys_vec_q==16'hFF00) iff (hqm_sif_core.prim_rst_b);
    CP_NP_M6  : coverpoint cmd_put_np_vec_q[14]  & (prim_clk_enable_sys_vec_q==16'hFF00) iff (hqm_sif_core.prim_rst_b);
    CP_NP_M5  : coverpoint cmd_put_np_vec_q[13]  & (prim_clk_enable_sys_vec_q==16'hFF00) iff (hqm_sif_core.prim_rst_b);
    CP_NP_M4  : coverpoint cmd_put_np_vec_q[12]  & (prim_clk_enable_sys_vec_q==16'hFF00) iff (hqm_sif_core.prim_rst_b);
    CP_NP_M3  : coverpoint cmd_put_np_vec_q[11]  & (prim_clk_enable_sys_vec_q==16'hFF00) iff (hqm_sif_core.prim_rst_b);
    CP_NP_M2  : coverpoint cmd_put_np_vec_q[10]  & (prim_clk_enable_sys_vec_q==16'hFF00) iff (hqm_sif_core.prim_rst_b);
    CP_NP_M1  : coverpoint cmd_put_np_vec_q[ 9]  & (prim_clk_enable_sys_vec_q==16'hFF00) iff (hqm_sif_core.prim_rst_b);
    CP_NP_P0  : coverpoint cmd_put_np_vec_q[ 8]  & (prim_clk_enable_sys_vec_q==16'hFF00) iff (hqm_sif_core.prim_rst_b);
    CP_NP_P1  : coverpoint cmd_put_np_vec_q[ 7]  & (prim_clk_enable_sys_vec_q==16'hFF00) iff (hqm_sif_core.prim_rst_b);
    CP_NP_P2  : coverpoint cmd_put_np_vec_q[ 6]  & (prim_clk_enable_sys_vec_q==16'hFF00) iff (hqm_sif_core.prim_rst_b);
    CP_NP_P3  : coverpoint cmd_put_np_vec_q[ 5]  & (prim_clk_enable_sys_vec_q==16'hFF00) iff (hqm_sif_core.prim_rst_b);
    CP_NP_P4  : coverpoint cmd_put_np_vec_q[ 4]  & (prim_clk_enable_sys_vec_q==16'hFF00) iff (hqm_sif_core.prim_rst_b);
    CP_NP_P5  : coverpoint cmd_put_np_vec_q[ 3]  & (prim_clk_enable_sys_vec_q==16'hFF00) iff (hqm_sif_core.prim_rst_b);
    CP_NP_P6  : coverpoint cmd_put_np_vec_q[ 2]  & (prim_clk_enable_sys_vec_q==16'hFF00) iff (hqm_sif_core.prim_rst_b);
    CP_NP_P7  : coverpoint cmd_put_np_vec_q[ 1]  & (prim_clk_enable_sys_vec_q==16'hFF00) iff (hqm_sif_core.prim_rst_b);
    CP_NP_P8  : coverpoint cmd_put_np_vec_q[ 0]  & (prim_clk_enable_sys_vec_q==16'hFF00) iff (hqm_sif_core.prim_rst_b);
    CP_CPL_M7 : coverpoint cmd_put_cpl_vec_q[15] & (prim_clk_enable_sys_vec_q==16'hFF00) iff (hqm_sif_core.prim_rst_b);
    CP_CPL_M6 : coverpoint cmd_put_cpl_vec_q[14] & (prim_clk_enable_sys_vec_q==16'hFF00) iff (hqm_sif_core.prim_rst_b);
    CP_CPL_M5 : coverpoint cmd_put_cpl_vec_q[13] & (prim_clk_enable_sys_vec_q==16'hFF00) iff (hqm_sif_core.prim_rst_b);
    CP_CPL_M4 : coverpoint cmd_put_cpl_vec_q[12] & (prim_clk_enable_sys_vec_q==16'hFF00) iff (hqm_sif_core.prim_rst_b);
    CP_CPL_M3 : coverpoint cmd_put_cpl_vec_q[11] & (prim_clk_enable_sys_vec_q==16'hFF00) iff (hqm_sif_core.prim_rst_b);
    CP_CPL_M2 : coverpoint cmd_put_cpl_vec_q[10] & (prim_clk_enable_sys_vec_q==16'hFF00) iff (hqm_sif_core.prim_rst_b);
    CP_CPL_M1 : coverpoint cmd_put_cpl_vec_q[ 9] & (prim_clk_enable_sys_vec_q==16'hFF00) iff (hqm_sif_core.prim_rst_b);
    CP_CPL_P0 : coverpoint cmd_put_cpl_vec_q[ 8] & (prim_clk_enable_sys_vec_q==16'hFF00) iff (hqm_sif_core.prim_rst_b);
    CP_CPL_P1 : coverpoint cmd_put_cpl_vec_q[ 7] & (prim_clk_enable_sys_vec_q==16'hFF00) iff (hqm_sif_core.prim_rst_b);
    CP_CPL_P2 : coverpoint cmd_put_cpl_vec_q[ 6] & (prim_clk_enable_sys_vec_q==16'hFF00) iff (hqm_sif_core.prim_rst_b);
    CP_CPL_P3 : coverpoint cmd_put_cpl_vec_q[ 5] & (prim_clk_enable_sys_vec_q==16'hFF00) iff (hqm_sif_core.prim_rst_b);
    CP_CPL_P4 : coverpoint cmd_put_cpl_vec_q[ 4] & (prim_clk_enable_sys_vec_q==16'hFF00) iff (hqm_sif_core.prim_rst_b);
    CP_CPL_P5 : coverpoint cmd_put_cpl_vec_q[ 3] & (prim_clk_enable_sys_vec_q==16'hFF00) iff (hqm_sif_core.prim_rst_b);
    CP_CPL_P6 : coverpoint cmd_put_cpl_vec_q[ 2] & (prim_clk_enable_sys_vec_q==16'hFF00) iff (hqm_sif_core.prim_rst_b);
    CP_CPL_P7 : coverpoint cmd_put_cpl_vec_q[ 1] & (prim_clk_enable_sys_vec_q==16'hFF00) iff (hqm_sif_core.prim_rst_b);
    CP_CPL_P8 : coverpoint cmd_put_cpl_vec_q[ 0] & (prim_clk_enable_sys_vec_q==16'hFF00) iff (hqm_sif_core.prim_rst_b);
   
    CP_RI_CDS_CBD_DROP_HPAR : coverpoint { hqm_sif_core.i_hqm_ri.i_ri_cds.cbd_drop_hpar } iff ( hqm_sif_core.prim_rst_b ) ;
    CP_RI_CDS_CBD_DROP_FLR_P : coverpoint { hqm_sif_core.i_hqm_ri.i_ri_cds.cbd_drop_flr_p } iff ( hqm_sif_core.prim_rst_b ) ;
    CP_RI_CDS_CBD_DROP_FLR_NP : coverpoint { hqm_sif_core.i_hqm_ri.i_ri_cds.cbd_drop_flr_np } iff ( hqm_sif_core.prim_rst_b ) ;
    CP_RI_CDS_CBD_POISONED_P : coverpoint { hqm_sif_core.i_hqm_ri.i_ri_cds.cbd_poisoned_p } iff ( hqm_sif_core.prim_rst_b ) ;
    CP_RI_CDS_CBD_POISONED_NP : coverpoint { hqm_sif_core.i_hqm_ri.i_ri_cds.cbd_poisoned_np } iff ( hqm_sif_core.prim_rst_b ) ;

    CP_RI_PM_RST_ACT_CNT_0 : coverpoint { hqm_sif_core.i_hqm_ri.i_ri_pm.rst_act_cnt [ 0 ] } iff ( hqm_sif_core.prim_rst_b &
                                                                                                            hqm_sif_core.i_hqm_ri.func_in_rst [ 0 ] ) {
      bins RST_ACT_CNT = { [ 1 : 192 ] } ;
      ignore_bins RST_ACT_CNT_0 = { 0 } ;
    }

    XCP_RI_CDS_CBD_DROP_HPAR_W_PM_RST_ACT_CNT_0 : cross CP_RI_CDS_CBD_DROP_HPAR , CP_RI_PM_RST_ACT_CNT_0 ;
    XCP_RI_CDS_CBD_DROP_FLR_P_W_PM_RST_ACT_CNT_0 : cross CP_RI_CDS_CBD_DROP_FLR_P , CP_RI_PM_RST_ACT_CNT_0 ;
    XCP_RI_CDS_CBD_DROP_FLR_NP_W_PM_RST_ACT_CNT_0 : cross CP_RI_CDS_CBD_DROP_FLR_NP , CP_RI_PM_RST_ACT_CNT_0 ;

    CP_RI_PF_FUNC_IN_RST : coverpoint { hqm_sif_core.i_hqm_ri.func_in_rst [ 0 ] } iff ( hqm_sif_core.prim_rst_b ) ;

    CP_RI_CDS_HDR_V : coverpoint { hqm_sif_core.i_hqm_ri.i_ri_cds.cds_hdr.iosfsb } iff ( hqm_sif_core.prim_rst_b &
                                                                                               hqm_sif_core.i_hqm_ri.i_ri_cds.cds_hdr_v ) {
      bins IOSF = { 7 } ;
      bins PRIM = { 0 } ;
    }

    CP_TI_TRN_PHDR_FIFO_POP_DEPTH : coverpoint { hqm_sif_core.i_hqm_iosfp_core.i_hqm_ti.i_ti_trn.phdr_fifo_pop_depth_nc } iff ( hqm_sif_core.prim_rst_b ) {
      ignore_bins fifo_empty = { 0 } ;
      bins fifo_not_empty = { [ 1 : 64 ] } ;
      ignore_bins fifo_invalid = { [ 65 : 127 ] } ;
    }

    CP_TI_TRN_PDATA_FIFO_POP_DEPTH : coverpoint { hqm_sif_core.i_hqm_iosfp_core.i_hqm_ti.i_ti_trn.pdata_fifo_pop_depth_nc } iff ( hqm_sif_core.prim_rst_b ) {
      ignore_bins fifo_empty = { 0 } ;
      bins fifo_not_empty = { [ 1 : 64 ] } ;
      ignore_bins fifo_invalid = { [ 65 : 127 ] } ;
    }

    XCP_RI_PF_FUNC_IN_RST_HDR_V : cross CP_RI_PF_FUNC_IN_RST , CP_RI_CDS_HDR_V , CP_TI_TRN_PHDR_FIFO_POP_DEPTH , CP_TI_TRN_PDATA_FIFO_POP_DEPTH ;

    CP_RI_CDS_PRIM_SIDE_ARB_REQS : coverpoint { hqm_sif_core.i_hqm_ri.i_ri_cds.prim_side_arb_reqs } iff ( hqm_sif_core.prim_rst_b ) {
      bins arb_idle = { 0 } ;
      bins sideband = { 1 } ;
      bins primary = { 2 } ;
      bins prim_side = { 3 } ;
    }

    CP_RI_CDS_PRIM_SIDE_ARB_HOLD : coverpoint { hqm_sif_core.i_hqm_ri.i_ri_cds.prim_side_arb_hold_q } iff ( hqm_sif_core.prim_rst_b ) ;

    CP_RI_CDS_HCW_TIMEOUT_ERROR : coverpoint { hqm_sif_core.i_hqm_ri.i_ri_cds.hcw_timeout_error } iff ( hqm_sif_core.prim_rst_b ) ;
    CP_RI_CDS_HCW_ENQ_PAR_ERROR : coverpoint { hqm_sif_core.i_hqm_ri.i_ri_cds.hcw_enq_par_error } iff ( hqm_sif_core.prim_rst_b ) ;
    CP_RI_CDS_MALFORM_PKT       : coverpoint { hqm_sif_core.i_hqm_ri.i_ri_cds.cds_malform_pkt } iff ( hqm_sif_core.prim_rst_b ) ;
    CP_RI_CDS_BAR_DECODE_ERR    : coverpoint { hqm_sif_core.i_hqm_ri.i_ri_cds.cds_bar_decode_err_wp } iff ( hqm_sif_core.prim_rst_b ) ;

  endgroup

  CG_SIF_PRIM_CLK i_CG_SIF_PRIM_CLK = new();

`endif

endmodule

bind hqm_sif_core hqm_sif_cover i_hqm_sif_cover();

`endif
