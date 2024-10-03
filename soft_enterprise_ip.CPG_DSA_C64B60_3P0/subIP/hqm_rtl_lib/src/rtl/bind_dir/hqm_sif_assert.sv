
`ifndef INTEL_SVA_OFF

module hqm_sif_assert import hqm_AW_pkg::*, hqm_pkg::*, hqm_sif_pkg::*; ();

logic continue_on_perr;
int   exp_mcperr;
int   exp_mdperr;

initial begin
 continue_on_perr=0; if ($test$plusargs("HQM_IOSF_CONTINUE_ON_PERR")) continue_on_perr='1;
 exp_mcperr=0; $value$plusargs({"HQM_EXP_IOSF_MCPERR","=%d"}, exp_mcperr);
 exp_mdperr=0; $value$plusargs({"HQM_EXP_IOSF_MDPERR","=%d"}, exp_mdperr);
end

always @(posedge hqm_sif_core.prim_gated_clk) begin

 if (continue_on_perr & (hqm_sif_core.prim_gated_rst_b === 1'b1)) begin
  if (hqm_sif_core.ri_parity_alarm)              $display ("%t: [HQMI_DEBUG]: WARNING: An RI parity error occurred!", $time);
  if (hqm_sif_core.sif_parity_alarm)             $display ("%t: [HQMI_DEBUG]: WARNING: A SIF parity error occurred!", $time);
  if (hqm_sif_core.hqm_csr_ext_mmio_ack_err)     $display ("%t: [HQMI_DEBUG]: WARNING: An APB parity error occurred!", $time);
  if ($rose(hqm_sif_core.sb_ep_parity_err_sync)) $display ("%t: [HQMI_DEBUG]: WARNING: An IOSFSB parity error occurred!", $time);
 end

end

`HQM_SDG_ASSERTS_FORBIDDEN(
     hqm_sif_timeout_error
    ,hqm_sif_core.timeout_error
    ,posedge hqm_sif_core.prim_gated_clk
    ,~hqm_sif_core.prim_gated_rst_b
    ,`HQM_SVA_ERR_MSG($psprintf("A CFG timeout occurred!"))
    , SDG_SVA_SOC_SIM
  )

`HQM_SDG_ASSERTS_FORBIDDEN(
     hqm_sif_fifo_underflow
    ,(hqm_sif_core.i_hqm_sif_infra_core.fifo_underflow & ~hqm_sif_core.i_hqm_sif_infra_core.sif_alarm_err.FIFO_UNDERFLOW)
    ,posedge hqm_sif_core.prim_gated_clk
    ,~hqm_sif_core.prim_gated_rst_b
    ,`HQM_SVA_ERR_MSG($psprintf("A FIFO underflow occurred!"))
    , SDG_SVA_SOC_SIM
  )

`HQM_SDG_ASSERTS_FORBIDDEN(
     hqm_sif_fifo_overflow
    ,(hqm_sif_core.i_hqm_sif_infra_core.fifo_overflow & ~hqm_sif_core.i_hqm_sif_infra_core.sif_alarm_err.FIFO_OVERFLOW)
    ,posedge hqm_sif_core.prim_gated_clk
    ,~hqm_sif_core.prim_gated_rst_b
    ,`HQM_SVA_ERR_MSG($psprintf("A FIFO overflow occurred!"))
    , SDG_SVA_SOC_SIM
  )

`HQM_SDG_ASSERTS_FORBIDDEN(
     hqm_sif_sb_ep_parity_error
    ,(hqm_sif_core.i_hqm_sif_infra_core.sb_ep_parity_err_sync & ~hqm_sif_core.i_hqm_sif_infra_core.sif_alarm_err.SB_EP_PARITY_ERR)
    ,posedge hqm_sif_core.prim_gated_clk
    ,(~hqm_sif_core.prim_gated_rst_b | continue_on_perr)
    ,`HQM_SVA_ERR_MSG($psprintf("A sideband parity error occurred!"))
    , SDG_SVA_SOC_SIM
  )

`HQM_SDG_ASSERTS_FORBIDDEN(
     hqm_sif_parity_alarm
    ,hqm_sif_core.sif_parity_alarm
    ,posedge hqm_sif_core.prim_gated_clk
    ,(~hqm_sif_core.prim_gated_rst_b | continue_on_perr)
    ,`HQM_SVA_ERR_MSG($psprintf("A SIF parity error was detected!"))
    , SDG_SVA_SOC_SIM
  )

`HQM_SDG_ASSERTS_FORBIDDEN(
     hqm_sif_ri_parity_alarm
    ,hqm_sif_core.ri_parity_alarm
    ,posedge hqm_sif_core.prim_gated_clk
    ,(~hqm_sif_core.prim_gated_rst_b | continue_on_perr)
    ,`HQM_SVA_ERR_MSG($psprintf("An RI parity error was detected!"))
    , SDG_SVA_SOC_SIM
  )

`HQM_SDG_ASSERTS_FORBIDDEN(
     hqm_apb_pslver_alarm
    ,hqm_sif_core.hqm_csr_ext_mmio_ack_err[1]
    ,posedge hqm_sif_core.prim_gated_clk
    ,(~hqm_sif_core.prim_gated_rst_b | continue_on_perr)
    ,`HQM_SVA_ERR_MSG($psprintf("An APB slave error was detected!"))
    , SDG_SVA_SOC_SIM
  )

`HQM_SDG_ASSERTS_FORBIDDEN(
     hqm_apb_parity_alarm
    ,hqm_sif_core.hqm_csr_ext_mmio_ack_err[0]
    ,posedge hqm_sif_core.prim_gated_clk
    ,(~hqm_sif_core.prim_gated_rst_b | continue_on_perr)
    ,`HQM_SVA_ERR_MSG($psprintf("An APB parity error was detected!"))
    , SDG_SVA_SOC_SIM
  )

`HQM_SDG_ASSERTS_REQ_GRANTED_WITHIN(
     hqm_sif_adr_granted
    ,hqm_sif_core.pm_hqm_adr_assert
    ,1
    ,256
    ,hqm_sif_core.hqm_pm_adr_ack
    ,hqm_sif_core.prim_freerun_clk
    ,hqm_sif_core.prim_gated_rst_b
    ,`HQM_SVA_ERR_MSG($psprintf("hqm_pm_adr_ack did not assert in response to pm_hqm_adr_assert within 256 clocks!"))
    , SDG_SVA_SOC_SIM
  )

`ifndef HQM_SFI

// Parity monitoring

always @(posedge hqm_sif_core.prim_gated_clk) begin

 if (continue_on_perr & (hqm_sif_core.prim_gated_rst_b === 1'b1)) begin

    if (hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.i_hqm_iosf_mstr_scrbd.ibcpl_hdr_fifo_push &
        (^hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.i_hqm_iosf_mstr_scrbd.ibcpl_hdr_fifo_push_data)) begin
     $display ("%t: [HQMI_DEBUG]: WARNING: Parity was not even on the SIF MSTR IBCPL HDR FIFO push data!",$time);
    end
    if (hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.i_hqm_iosf_mstr_scrbd.ibcpl_data_fifo_push &
        (^hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.i_hqm_iosf_mstr_scrbd.ibcpl_data_fifo_push_data)) begin
     $display ("%t: [HQMI_DEBUG]: WARNING: Parity was not even on the SIF MSTR IBCPL DATA FIFO push data!",$time);
    end

 end

end

`HQM_SDG_ASSERTS_FORBIDDEN(
     hqm_sif_ibcpl_hdr_fifo_push_parity_err
    ,(hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.i_hqm_iosf_mstr_scrbd.ibcpl_hdr_fifo_push &
        (^hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.i_hqm_iosf_mstr_scrbd.ibcpl_hdr_fifo_push_data))
    ,posedge hqm_sif_core.prim_gated_clk
    ,(~hqm_sif_core.prim_gated_rst_b | continue_on_perr)
    ,`HQM_SVA_ERR_MSG($psprintf("Parity was not even on the SIF IBCPL HDR FIFO push data!"))
    , SDG_SVA_SOC_SIM
  )

`HQM_SDG_ASSERTS_FORBIDDEN(
     hqm_sif_ibcpl_data_fifo_push_parity_err
    ,(hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.i_hqm_iosf_mstr_scrbd.ibcpl_data_fifo_push &
        (^hqm_sif_core.i_hqm_iosfp_core.i_hqm_iosf_mstr.i_hqm_iosf_mstr_scrbd.ibcpl_data_fifo_push_data))
    ,posedge hqm_sif_core.prim_gated_clk
    ,(~hqm_sif_core.prim_gated_rst_b | continue_on_perr)
    ,`HQM_SVA_ERR_MSG($psprintf("Parity was not even on the SIF IBCPL DATA FIFO push data!"))
    , SDG_SVA_SOC_SIM
  )

`HQM_SDG_ASSERTS_FORBIDDEN(
     hqm_sif_ri_cds_bad_msg_drop_usr_pmem_req
    ,(hqm_sif_core.i_hqm_ri.i_ri_cds.cds_take_decode &
      hqm_sif_core.i_hqm_ri.i_ri_cds.usr_pmem_req &
      hqm_sif_core.i_hqm_ri.i_ri_cds.cbd_msg_drop)
    ,posedge hqm_sif_core.prim_gated_clk
    ,(~hqm_sif_core.prim_gated_rst_b | continue_on_perr)
    ,`HQM_SVA_ERR_MSG($psprintf("usr_pmem_req and cbd_msg_drop asserted at the same time!"))
    , SDG_SVA_SOC_SIM
  )

int mcperr_cnt;
int mdperr_cnt;

always_ff @(posedge hqm_sif_core.prim_gated_clk or negedge hqm_sif_core.prim_gated_rst_b) begin
 if (~hqm_sif_core.prim_gated_rst_b) begin
  mcperr_cnt <= '0;
  mdperr_cnt <= '0;
 end else begin

  if (hqm_sif_core.mcparity != ^{hqm_sif_core.mfmt,
                                  hqm_sif_core.mtype,
                                  hqm_sif_core.mtc,
                                  hqm_sif_core.mep,
                                  hqm_sif_core.mro,
                                  hqm_sif_core.mns,
                                  hqm_sif_core.mat,
                                  hqm_sif_core.mlength,
                                  hqm_sif_core.mrqid,
                                  hqm_sif_core.mtag,
                                  hqm_sif_core.mlbe,
                                  hqm_sif_core.mfbe,
                                  hqm_sif_core.maddress,
                                  hqm_sif_core.mtd,
                                  hqm_sif_core.mth,
                                  hqm_sif_core.i_hqm_iosfp_core.mrsvd1_1,
                                  hqm_sif_core.mrsvd1_3,
                                  hqm_sif_core.mrsvd1_7,
                                  hqm_sif_core.i_hqm_iosfp_core.mrsvd0_7,
                                  hqm_sif_core.mido,
                                  hqm_sif_core.mpasidtlp,
                                  hqm_sif_core.mrs
                                 })                   mcperr_cnt <= mcperr_cnt+1;

  if (hqm_sif_core.mdparity != ^hqm_sif_core.mdata) mdperr_cnt <= mdperr_cnt+1;

 end
end

final begin
 if ((exp_mcperr>0) && (exp_mcperr != mcperr_cnt)) begin
  $display("[HQMI_DEBUG]: ERROR: Expected %0d SIF master header parity errors but saw %0d",exp_mcperr,mcperr_cnt);
 end
 if ((exp_mdperr>0) && (exp_mdperr != mdperr_cnt)) begin
  $display("[HQMI_DEBUG]: ERROR: Expected %0d SIF master data parity errors but saw %0d",exp_mdperr,mdperr_cnt);
 end
end

`endif

endmodule

bind hqm_sif_core hqm_sif_assert i_hqm_sif_assert();

`endif

