// -------------------------------------------------------------------
// --                      Intel Proprietary
// --              Copyright 2020 Intel Corporation
// --                    All Rights Reserved
// -------------------------------------------------------------------
// -- Module Name       : hqm_system_msix_mem_wrap
// -- Author            : Mike Betker
// -- Project Name      : HQM
// -- Description       : This module instantiates the generated msix memory address map
// -------------------------------------------------------------------

module hqm_system_msix_mem_wrap

        import hqm_AW_pkg::*, hqm_pkg::*, hqm_system_pkg::*, hqm_system_csr_pkg::*, hqm_sif_pkg::*;
(
        //-----------------------------------------------------------------
        // Reset
        //-----------------------------------------------------------------
        input  logic                                            hqm_inp_gated_rst_n,
    
        //-----------------------------------------------------------------
        // Request/Acknowledge interfaces
        //-----------------------------------------------------------------
        input  hqm_rtlgen_pkg_v12::cfg_req_32bit_t              hqm_msix_mem_req,
        output hqm_rtlgen_pkg_v12::cfg_ack_32bit_t              hqm_msix_mem_ack,


        //-----------------------------------------------------------------
        // MSIX Pending Bit array
        //-----------------------------------------------------------------
        input  logic [HQM_SYSTEM_NUM_MSIX-1:0]                  msix_pba,

        //-----------------------------------------------------------------
        // Handcoded interfaces
        //-----------------------------------------------------------------
        input  hqm_msix_mem_pkg::hqm_msix_mem_hc_rvalid_t       hqm_msix_mem_hc_rvalid,
        input  hqm_msix_mem_pkg::hqm_msix_mem_hc_wvalid_t       hqm_msix_mem_hc_wvalid,
        input  hqm_msix_mem_pkg::hqm_msix_mem_hc_error_t        hqm_msix_mem_hc_error,
        input  hqm_msix_mem_pkg::hqm_msix_mem_hc_reg_read_t     hqm_msix_mem_hc_reg_read,

        output hqm_msix_mem_pkg::hqm_msix_mem_handcoded_t       hqm_msix_mem_hc_we,
        output hqm_msix_mem_pkg::hqm_msix_mem_hc_re_t           hqm_msix_mem_hc_re,
        output hqm_msix_mem_pkg::hqm_msix_mem_hc_reg_write_t    hqm_msix_mem_hc_reg_write
);
    
localparam NUM_MSIX_PBA_REG     = (HQM_SYSTEM_NUM_MSIX+31)/32;

hqm_msix_mem_pkg::new_HQM_MSIX_PBA_t [NUM_MSIX_PBA_REG-1:0]      new_msix_pba;
hqm_msix_mem_pkg::HQM_MSIX_PBA_t     [NUM_MSIX_PBA_REG-1:0]      msix_pba_nc;

generate
  genvar pba;
  for ( pba = 0; pba < NUM_MSIX_PBA_REG ; pba++ ) begin: g_msix_pba
    if (HQM_SYSTEM_NUM_MSIX >= ((pba+1)*32)) begin : g_msix_pba_full_word
      assign new_msix_pba[pba] = msix_pba[(pba*32)+:32];
    end else begin : g_msix_pba_partial_word
      assign new_msix_pba[pba] = {{(6'd32-{1'b0,HQM_SYSTEM_NUM_MSIX[4:0]}){1'b0}},msix_pba[(HQM_SYSTEM_NUM_MSIX-1):(pba*32)]};
    end
  end
endgenerate

hqm_msix_mem i_hqm_msix_mem (
//     INPUTS    //
  .hqm_inp_gated_rst_n                                  (hqm_inp_gated_rst_n),

  .req                                                  (hqm_msix_mem_req),

  .new_HQM_MSIX_PBA                                     (new_msix_pba),

  .handcode_reg_rdata_MSG_ADDR_L                        (hqm_msix_mem_hc_reg_read.MSG_ADDR_L),
  .handcode_reg_rdata_MSG_ADDR_U                        (hqm_msix_mem_hc_reg_read.MSG_ADDR_U),
  .handcode_reg_rdata_MSG_DATA                          (hqm_msix_mem_hc_reg_read.MSG_DATA),
  .handcode_reg_rdata_VECTOR_CTRL                       (hqm_msix_mem_hc_reg_read.VECTOR_CTRL),

  .handcode_rvalid_MSG_ADDR_L                           (hqm_msix_mem_hc_rvalid.MSG_ADDR_L),
  .handcode_rvalid_MSG_ADDR_U                           (hqm_msix_mem_hc_rvalid.MSG_ADDR_U),
  .handcode_rvalid_MSG_DATA                             (hqm_msix_mem_hc_rvalid.MSG_DATA),
  .handcode_rvalid_VECTOR_CTRL                          (hqm_msix_mem_hc_rvalid.VECTOR_CTRL),

  .handcode_wvalid_MSG_ADDR_L                           (hqm_msix_mem_hc_wvalid.MSG_ADDR_L),
  .handcode_wvalid_MSG_ADDR_U                           (hqm_msix_mem_hc_wvalid.MSG_ADDR_U),
  .handcode_wvalid_MSG_DATA                             (hqm_msix_mem_hc_wvalid.MSG_DATA),
  .handcode_wvalid_VECTOR_CTRL                          (hqm_msix_mem_hc_wvalid.VECTOR_CTRL),

  .handcode_error_MSG_ADDR_L                            (hqm_msix_mem_hc_error.MSG_ADDR_L),
  .handcode_error_MSG_ADDR_U                            (hqm_msix_mem_hc_error.MSG_ADDR_U),
  .handcode_error_MSG_DATA                              (hqm_msix_mem_hc_error.MSG_DATA),
  .handcode_error_VECTOR_CTRL                           (hqm_msix_mem_hc_error.VECTOR_CTRL),

//     OUTPUTS    //
  .ack                                                  (hqm_msix_mem_ack),

  .HQM_MSIX_PBA                                         (msix_pba_nc),

  // Register signals for HandCoded registers
  .handcode_reg_wdata_MSG_ADDR_L                        (hqm_msix_mem_hc_reg_write.MSG_ADDR_L),
  .handcode_reg_wdata_MSG_ADDR_U                        (hqm_msix_mem_hc_reg_write.MSG_ADDR_U),
  .handcode_reg_wdata_MSG_DATA                          (hqm_msix_mem_hc_reg_write.MSG_DATA),
  .handcode_reg_wdata_VECTOR_CTRL                       (hqm_msix_mem_hc_reg_write.VECTOR_CTRL),

  .we_MSG_ADDR_L                                        (hqm_msix_mem_hc_we.MSG_ADDR_L),
  .we_MSG_ADDR_U                                        (hqm_msix_mem_hc_we.MSG_ADDR_U),
  .we_MSG_DATA                                          (hqm_msix_mem_hc_we.MSG_DATA),
  .we_VECTOR_CTRL                                       (hqm_msix_mem_hc_we.VECTOR_CTRL),

  .re_MSG_ADDR_L                                        (hqm_msix_mem_hc_re.MSG_ADDR_L),
  .re_MSG_ADDR_U                                        (hqm_msix_mem_hc_re.MSG_ADDR_U),
  .re_MSG_DATA                                          (hqm_msix_mem_hc_re.MSG_DATA),
  .re_VECTOR_CTRL                                       (hqm_msix_mem_hc_re.VECTOR_CTRL)

);        //    i_hqm_msix_mem

hqm_AW_unused_bits i_unused (   

    .a  (|msix_pba_nc)
);

endmodule
