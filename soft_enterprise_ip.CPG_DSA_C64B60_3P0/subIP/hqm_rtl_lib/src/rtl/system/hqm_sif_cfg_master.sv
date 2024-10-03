//-----------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2020 Intel Corporation All Rights Reserved.
//
// The source code contained or described herein and all documents related to the source code
// ("Material") are owned by Intel Corporation or its suppliers or licensors. Title to the Material
// remains with Intel Corporation or its suppliers and licensors. The Material contains trade
// secrets and proprietary and confidential information of Intel or its suppliers and licensors.
// The Material is protected by worldwide copyright and trade secret laws and treaty provisions.
// No part of the Material may be used, copied, reproduced, modified, published, uploaded, posted,
// transmitted, distributed, or disclosed in any way without Intel's prior express written permission.
//
// No license under any patent, copyright, trade secret or other intellectual property right is
// granted to or conferred upon you by disclosure or delivery of the Materials, either expressly, by
// implication, inducement, estoppel or otherwise. Any license under such intellectual property rights
// must be express and approved by Intel in writing.
//
//-----------------------------------------------------------------------------------------------------

module hqm_sif_cfg_master

         import hqm_AW_pkg::*, hqm_pkg::*, hqm_system_pkg::*, hqm_rtlgen_pkg_v12::*, hqm_sif_csr_pkg::*;
(
         input  logic                                   prim_gated_clk
        ,input  logic                                   prim_gated_rst_b

        ,input  logic                                   flr_triggered_wl

        //---------------------------------------------------------------------------------------------
        // CFG interface

        ,input  hqm_rtlgen_pkg_v12::cfg_req_32bit_t     hqm_csr_ext_mmio_req
        ,input  logic                                   hqm_csr_ext_mmio_req_apar
        ,input  logic                                   hqm_csr_ext_mmio_req_dpar

        ,input  hqm_sif_csr_sai_export_t                hqm_sif_csr_sai_export

        ,output hqm_rtlgen_pkg_v12::cfg_ack_32bit_t     hqm_csr_ext_mmio_ack
        ,output logic [1:0]                             hqm_csr_ext_mmio_ack_err

        ,input  CFG_MASTER_TIMEOUT_t                    cfg_master_timeout

        ,output logic                                   cfgm_timeout_error

        ,output logic                                   cfgm_idle
        ,output new_CFGM_STATUS_t                       cfgm_status
        ,output new_CFGM_STATUS2_t                      cfgm_status2

        //---------------------------------------------------------------------------------------------
        // APB interface

        ,output logic                                   psel
        ,output logic                                   penable
        ,output logic                                   pwrite
        ,output logic   [31:0]                          paddr
        ,output logic   [31:0]                          pwdata
        ,output cfg_user_t                              puser

        ,input  logic                                   pready
        ,input  logic                                   pslverr
        ,input  logic   [31:0]                          prdata
        ,input  logic                                   prdata_par
);

//-----------------------------------------------------------------------------------------------------

logic                                   cfg_read;
logic                                   cfg_write;
logic                                   cfg_req_v;
logic                                   cfg_sai_v;

logic                                   psel_next;
logic                                   psel_q;
logic                                   penable_next;
logic                                   penable_q;
logic                                   pwrite_q;
logic   [31:0]                          paddr_q;
logic                                   paddr_par_q;
logic   [31:0]                          pwdata_q;
logic                                   pwdata_par_q;

logic                                   pready_next;
logic                                   pready_q;
logic                                   pslverr_q;
logic   [31:0]                          prdata_q;
logic                                   prdata_par_q;

logic                                   cfg_rvalid_next;
logic                                   cfg_rvalid_q;
logic                                   cfg_wvalid_next;
logic                                   cfg_wvalid_q;
logic                                   cfg_sai_successfull_next;
logic                                   cfg_sai_successfull_q;
logic                                   cfg_error_next;
logic                                   cfg_error_q;
logic   [31:0]                          cfg_rdata_next;
logic   [31:0]                          cfg_rdata_q;
logic                                   apb_req_done;

logic   [31:0]                          pcnt_next;
logic   [31:0]                          pcnt_q;
logic                                   timeout_next;
logic                                   timeout_q;

//-----------------------------------------------------------------------------------------------------
// Convert cfg access to APB request

hqm_AW_unused_bits i_unused (   

         .a     (|{hqm_csr_ext_mmio_req.sai
                  ,hqm_csr_ext_mmio_req.fid
                  ,hqm_csr_ext_mmio_req.addr[47:32]
                })
);

assign cfg_read  = hqm_csr_ext_mmio_req.valid & ~hqm_csr_ext_mmio_req.opcode[0];
assign cfg_write = hqm_csr_ext_mmio_req.valid &  hqm_csr_ext_mmio_req.opcode[0];

assign cfg_sai_v =  (hqm_csr_ext_mmio_req.bar    == 3'd0) ? 1'b1 :   // No SAI checks for FUNC_PF/FUNC_VF BAR spaces
                   ((hqm_csr_ext_mmio_req.opcode ==  MRD) ? hqm_sif_csr_sai_export.HQM_OS_W_read_en :
                                                            hqm_sif_csr_sai_export.HQM_OS_W_write_en);

assign cfg_req_v = hqm_csr_ext_mmio_req.valid & cfg_sai_v &
                        ((hqm_csr_ext_mmio_req.opcode == MRD) || (hqm_csr_ext_mmio_req.opcode == MWR)) &
                        (&hqm_csr_ext_mmio_req.be) &
                        (hqm_csr_ext_mmio_req.addr[31:28] >= 4'd1) &
                        (hqm_csr_ext_mmio_req.addr[31:28] <= 4'd10);

assign psel_next     = cfg_req_v & ~(cfg_rvalid_q | cfg_wvalid_q | timeout_q);
assign penable_next  = (|psel_q) & ~(cfg_rvalid_q | cfg_wvalid_q | timeout_q);

always_ff @(posedge prim_gated_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  psel_q    <= '0;
  penable_q <= '0;
  pwrite_q  <= '0;
 end else if (~flr_triggered_wl) begin
  psel_q    <= '0;
  penable_q <= '0;
  pwrite_q  <= '0;
 end else begin
  psel_q    <= psel_next;
  penable_q <= penable_next;
  pwrite_q  <= cfg_write;
 end
end

always_ff @(posedge prim_gated_clk) begin
 if (psel_next & ~penable_next) begin
  paddr_q      <= hqm_csr_ext_mmio_req.addr[31:0];
  paddr_par_q  <= hqm_csr_ext_mmio_req_apar;
  pwdata_q     <= hqm_csr_ext_mmio_req.data;
  pwdata_par_q <= hqm_csr_ext_mmio_req_dpar;
 end
end

assign psel    = psel_q    & ~apb_req_done;
assign penable = penable_q & ~apb_req_done;
assign pwrite  = pwrite_q;
assign paddr   = paddr_q;
assign pwdata  = pwdata_q;

always_comb begin

 puser        = '0;
 puser.a_par  = paddr_par_q;
 puser.wd_par = pwdata_par_q;

end

// Timeout

assign pcnt_next    = ((~penable_next & penable_q) | timeout_q) ? 32'd0 : (pcnt_q + {31'd0, penable_q});
assign timeout_next = (cfg_master_timeout.TIMEOUT_ENABLE & pcnt_q[cfg_master_timeout.TIMEOUT_PWR2]) |
                        (timeout_q & cfg_req_v);

always_ff @(posedge prim_gated_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  pcnt_q    <= '0;
  timeout_q <= '0;
 end else if (~flr_triggered_wl) begin
  pcnt_q    <= '0;
  timeout_q <= '0;
 end else begin
  if (penable_q | timeout_q) pcnt_q <= pcnt_next;
  timeout_q <= timeout_next;
 end
end

//-----------------------------------------------------------------------------------------------------
// Register APB response

assign pready_next = psel_q & penable_q & pready & ~timeout_q;

always_ff @(posedge prim_gated_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  pready_q <= '0;
 end else if (~flr_triggered_wl) begin
  pready_q <= '0;
 end else begin
  pready_q <= pready_next;
 end
end

always_ff @(posedge prim_gated_clk) begin
 if (pready_next) begin
  pslverr_q    <= pslverr;
  prdata_q     <= prdata;
  prdata_par_q <= prdata_par;
 end
end

//-----------------------------------------------------------------------------------------------------
// Convert APB response to CFG response

assign cfg_rvalid_next          = ((pready_q | timeout_q) & ~pwrite_q) | (cfg_read  & ~cfg_req_v);
assign cfg_wvalid_next          = ((pready_q | timeout_q) &  pwrite_q) | (cfg_write & ~cfg_req_v);
assign cfg_error_next           = ((cfg_read | cfg_write)  & ~cfg_req_v) | timeout_q;
assign cfg_rdata_next           = prdata_q & ~{32{timeout_q}};
assign cfg_sai_successfull_next = cfg_sai_v;

assign apb_req_done = |{pready_q, cfg_rvalid_q, cfg_wvalid_q};

always_ff @(posedge prim_gated_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  cfg_rvalid_q                  <= '0;
  cfg_wvalid_q                  <= '0;
  cfg_error_q                   <= '0;
  cfg_sai_successfull_q         <= '0;
 end else if (~flr_triggered_wl) begin
  cfg_rvalid_q                  <= '0;
  cfg_wvalid_q                  <= '0;
  cfg_error_q                   <= '0;
  cfg_sai_successfull_q         <= '0;
 end else begin
  cfg_rvalid_q                  <= cfg_rvalid_next;
  cfg_wvalid_q                  <= cfg_wvalid_next;
  cfg_error_q                   <= cfg_error_next;
  cfg_sai_successfull_q         <= cfg_sai_successfull_next;
 end
end

always_ff @(posedge prim_gated_clk) begin
 if (cfg_rvalid_next) begin
  cfg_rdata_q  <= cfg_rdata_next;
 end
end

assign hqm_csr_ext_mmio_ack.read_valid      = cfg_rvalid_q;
assign hqm_csr_ext_mmio_ack.read_miss       = cfg_rvalid_q & cfg_error_q;
assign hqm_csr_ext_mmio_ack.write_valid     = cfg_wvalid_q;
assign hqm_csr_ext_mmio_ack.write_miss      = cfg_wvalid_q & cfg_error_q;
assign hqm_csr_ext_mmio_ack.sai_successfull = ~(cfg_rvalid_q | cfg_wvalid_q) | cfg_sai_successfull_q;        // force to one if not responding
assign hqm_csr_ext_mmio_ack.data            = cfg_rdata_q;

// Bit 1 indicates a pslverr from the hqm_proc
// Bit 0 indicates a read data parity error

assign hqm_csr_ext_mmio_ack_err             = {((cfg_wvalid_q | cfg_rvalid_q) & ~cfg_error_q &  pslverr_q)
                                              ,(cfg_rvalid_q & ~cfg_error_q & (^{prdata_par_q, prdata_q}))};

assign cfgm_timeout_error      = timeout_q;

assign cfgm_idle = ~psel_q;

//-----------------------------------------------------------------------------------------------------

assign cfgm_status2 = {  psel_q                 // 31
                        ,pslverr_q              // 30
                        ,pwrite_q               // 29
                        ,pwdata_q[28:0]         // 28:0
};

assign cfgm_status = paddr_q[31:0];

endmodule // hqm_sif_cfg_master

